Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbYFDPSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbYFDPSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYFDPSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:18:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:40842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYFDPSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:18:44 -0400
Date: Wed, 4 Jun 2008 17:18:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Petr Tesarik <ptesarik@suse.cz>, Christoph Hellwig <hch@lst.de>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Why is the rewritten ramdisk driver called brd instad of rd
Message-ID: <20080604151842.GA30484@wotan.suse.de>
References: <20080321130552.GA28274@lst.de> <1211880480.29836.11.camel@elijah.suse.cz> <20080528061130.GB16441@wotan.suse.de> <alpine.LNX.1.10.0806031309350.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0806031309350.4055@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:09:55PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2008-05-28 08:11, Nick Piggin wrote:
> 
> >On Tue, May 27, 2008 at 11:28:00AM +0200, Petr Tesarik wrote:
> >> On Fri, 2008-03-21 at 14:05 +0100, Christoph Hellwig wrote:
> >> > Any reason why the rewritten ramdisk driver has a new name?  It's for
> >> > all matters an inplace replacement of the old rd driver so it should
> >> > be called rd.c / rd.ko to not confused instaler/developers/etc.
> >> 
> >> I think it's because the old rd played some dirty tricks with the page
> >> cache, while the reworked one is a straightforward implementation of a
> >> normal _b_lock device -> hence the "b".
> >> 
> >> No guarantee of correctness.
> >
> >Yeah it was a rwrite from scratch and it lived with the rd.c code for
> >a while (although maybe never in mainline). I guess it might be good
> >idea to rename it back to rd?
> 
> Just add a MODULE_ALIAS("rd").

Couldn't hurt... shall we merge this, then?


Alias brd to rd in the hope of helping legacy users. Suggested by Jan.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c	2008-06-05 00:51:53.000000000 +1000
+++ linux-2.6/drivers/block/brd.c	2008-06-05 00:52:43.000000000 +1000
@@ -397,6 +397,7 @@ module_param(max_part, int, 0);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
+MODULE_ALIAS("rd");
 
 #ifndef MODULE
 /* Legacy boot options - nonmodular */
