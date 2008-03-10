Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYCJIUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYCJIUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYCJIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:20:07 -0400
Received: from alpha.lp.pl ([194.1.144.4]:54197 "EHLO alpha.lp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYCJIUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:20:05 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 04:20:05 EDT
Date: Mon, 10 Mar 2008 08:51:49 +0100 (CET)
From: Grzegorz Kulewski <kangur@polcom.net>
X-X-Sender: kangur@alpha
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803092346.17556.phillips@phunq.net>
Message-ID: <Pine.LNX.4.63.0803100847000.3335@alpha>
References: <200803092346.17556.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Daniel Phillips wrote:
> Every little factor of 25 performance increase really helps.
>
> Ramback is a new virtual device with the ability to back a ramdisk
> by a real disk, obtaining the performance level of a ramdisk but with
> the data durability of a hard disk.  To work this magic, ramback needs
> a little help from a UPS.  In a typical test, ramback reduced a 25
> second file operation[1] to under one second including sync.  Even
> greater gains are possible for seek-intensive applications.
>
> The difference between ramback and an ordinary ramdisk is: when the
> machine powers down the data does not vanish because it is continuously
> saved to backing store.  When line power returns, the backing store
> repopulates the ramdisk while allowing application io to proceed
> concurrently.  Once fully populated, a little green light winks on and
> file operations once again run at ramdisk speed.
>
> So now you can ask some hard questions: what if the power goes out
> completely or the host crashes or something else goes wrong while
> critical data is still in the ramdisk?  Easy: use reliable components.
> Don't crash.  Measure your UPS window.  This is not much to ask in
> order to transform your mild mannered hard disk into a raging superdisk
> able to leap tall benchmarks at a single bound.
>
> If line power goes out while ramback is running, the UPS kicks in and a
> power management script switches the driver from writeback to
> writethrough mode.  Ramback proceeds to save all remaining dirty data
> while forcing each new application write through to backing store
> immediately.
>
> If UPS power runs out while ramback still holds unflushed dirty data
> then things get ugly.  Hopefully a fsck -f will be able to pull
> something useful out of the mess.  (This is where you might want to be
> running Ext3.)  The name of the game is to install sufficient UPS power
> to get your dirty ramdisk data onto stable storage this time, every
> time.

Are you using barriers or ordered disk writes with physical sync in the 
right moments or something like that? I think this is needed to allow any 
journaling filesystem to do it's job right.


> The basic design premise of ramback is alluringly simple: each write to
> a ramdisk sets a per-chunk dirty bit.  A kernel daemon continuously
> scans for and flushes dirty chunks to backing store.


Thanks,

GK

