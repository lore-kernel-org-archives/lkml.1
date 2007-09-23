Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXIWWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXIWWBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXIWWBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:01:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXIWWBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:01:00 -0400
Message-ID: <46F6E1C2.20905@torque.net>
Date: Sun, 23 Sep 2007 17:59:30 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
References: <20070923040437.GA30170@havoc.gtf.org>
In-Reply-To: <20070923040437.GA30170@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Rather than sitting on this for far too long, I wanted to go ahead and
> get this out there.  I heard some chips might be trickling out into
> public hands.
> 
> This is a bare bones Broadcom 8603 SAS+SATA driver, attempting to use
> the vaunted libsas.  Notes:
> 
> * A quick glance at the FIXMEs will tell you obviously doesn't work.
> 
> * The hardware is quite simple and straightforward and easy to program
>   in an efficient way:  each SAS port has a command queue (DMA ring) and
>   a response queue (DMA ring).  Or if in SATA mode, just a command
>   queue.
> 
> * The SAS/SATA negotiation is largely out of our hands.  The silicon
>   does its thing, and then tells us what type of device connected.  We
>   are then expected to switch the port to either SAS mode or SATA mode,
>   accordingly.
> 
> * There is no firmware or anything.  Just DMA and register bitbanging.
>   We have plenty of low-level control.
> 
> * The state of SAS/SATA integration is perpetually pathetic.  Updates
>   in this area are likely.  There's a rumor Brian King @ IBM may look
>   into this area too.
> 
> * This driver pretty much completely lacks exception handling.
> 
> 
> As an aside, I am also writing a driver for Marvell chips that behave
> quite similarly to this chip.  It seems the future of storage might look
> like these Broadcom and Marvell SAS+SATA DMA ring interfaces, in the
> volume marketspace at least.

Jeff,
Is the lack of SMP support a driver limitation or is it
the silicon?

How about support for wide ports (i.e. when 2 or more HBA
phys are attached to remote phys which have the same SAS
addresses)?

Last question: can the chip run in SCSI target mode?

Doug Gilbert
