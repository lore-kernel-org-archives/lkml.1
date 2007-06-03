Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbXFCGVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbXFCGVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXFCGUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:20:53 -0400
Received: from heineken.digium.com ([216.207.245.2]:58963 "EHLO
	heineken.digium.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXFCGUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:20:52 -0400
Date: Sun, 3 Jun 2007 01:20:37 -0500 (CDT)
From: Matt Fredrickson <creslin@digium.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <13097765.160991180851637904.JavaMail.root@jupiler.digium.com>
In-Reply-To: <17916027.160971180851607681.JavaMail.root@jupiler.digium.com>
Subject: Re: Device Driver Etiquette
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [68.62.219.187]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Arjan van de Ven" <arjan@infradead.org> wrote:
> On Fri, 2007-06-01 at 12:47 -0500, Matthew Fredrickson wrote:
> 
> > My question is this: is there a way to either work around the
> problem I 
> > am seeing with the stack without recompiling the kernel with 8K
> stack 
> > size or without disabling irqs for such a long period of time (which
> I 
> > think is not a nice thing to do either) OR is it acceptable
> (although 
> > not nice) to simply fix it this way, by disabling irqs while it
> loads 
> > the firmware?
> 
> I wonder if you're chasing ghosts; 4K stack kernels have a seperate
> stack for interrupts so... those should be safe.
> 
> Btw, you forgot to post a pointer to the source code of your driver,
> so
> it's a lot harder for us (read: impossible) to give you good advice..

As someone mentioned in another post, I believe what is causing this problem is a combination of factors.  The triggering of the softlockup detector seems to be what pushes it over the edge.  I think I will try as suggested to change the timer for it so that it does not trigger while the card is initializing.

If you'd like to see the source, here's a link:
http://svn.digium.com/view/zaptel/trunk/wct4xxp/

I can't give you the stack trace right now, since I'm not in the office, but it begins in the vpm450_init function and goes into the Octasic API functions, in the ChannelOpen routines as well as the chip initialization routines (the ones that load the firmware.

---
Matthew Fredrickson
Kernel Developer
Digium, Inc.
