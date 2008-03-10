Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYCJTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYCJTBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYCJTB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:01:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYCJTB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:01:28 -0400
Date: Mon, 10 Mar 2008 15:01:16 -0400
From: Rik van Riel <riel@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080310150116.72c9f583@bree.surriel.com>
In-Reply-To: <20080310092213.7ba878b3@core>
References: <200803092346.17556.phillips@phunq.net>
	<20080310092213.7ba878b3@core>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 09:22:13 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > So now you can ask some hard questions: what if the power goes out 
> > completely or the host crashes or something else goes wrong while 
> > critical data is still in the ramdisk?  Easy: use reliable components.  
> 
> Nice fiction - stuff crashes eventually - not that this isn't useful. For
> a long time simply loading a 2-3GB Ramdisk off hard disk has been a good
> way to build things like compile engines where loss of state is not bad.
> 
> > If UPS power runs out while ramback still holds unflushed dirty data 
> > then things get ugly.  Hopefully a fsck -f will be able to pull 
> > something useful out of the mess.  (This is where you might want to be 
> > running Ext3.)  The name of the game is to install sufficient UPS power 
> > to get your dirty ramdisk data onto stable storage this time, every 
> > time.
> 
> Ext3 is only going to help you if the ramdisk writeback respects barriers
> and ordering rules ?

That could get ugly when ext3 has written to the same block multiple
times.  To get some level of consistency, ramback would need to keep
around the different versions and flush them in order.

-- 
All rights reversed.
