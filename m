Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYCJOwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYCJOwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYCJOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:51:53 -0400
Received: from mx12.go2.pl ([193.17.41.142]:53837 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbYCJOvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:51:51 -0400
Message-ID: <47D54B03.1020605@o2.pl>
Date: Mon, 10 Mar 2008 15:51:47 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1pre (X11/2008030620)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net>
In-Reply-To: <200803092346.17556.phillips@phunq.net>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> Every little factor of 25 performance increase really helps.
> 
> Ramback is a new virtual device with the ability to back a ramdisk
> by a real disk, obtaining the performance level of a ramdisk but with
> the data durability of a hard disk.  To work this magic, ramback needs
> a little help from a UPS.  

So you apparently want three things:

a) ignoring fsync() and co on this device
b) disabling all write throttling on this device
c) never discarding cached data from this device

anything else i'm missing?

Alan already suggested the ramfs+writeback thread approach (possibly
with a little bit of help from the fs which could report just the dirty
regions), but i'm not sure even that is necessary.

(a) can be easily done (fixing the app, LD_PRELOAD or fs extension etc)
(b) couldn't the per-device write throttling be used to achieve this?
(c) shouldn't be impossible either, eg sticking PG_writeback comes to mind,
    just the mm accounting needs to remain sane.

IOW can't this be done in a more generic way (and w/o a ramdisk in the
middle)?

> a little help from a UPS.  In a typical test, ramback reduced a 25
> second file operation[1] to under one second including sync.  Even
> greater gains are possible for seek-intensive applications.

apples to oranges. what are the numbers for a nonjournalled disk-backed
fs and _without_ the sync? (You're not committing to stable storage anyway
so the sync is useless and if you don't respect the ordering so is the
journal)

artur 
