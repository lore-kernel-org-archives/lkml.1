Return-Path: <linux-kernel-owner+w=401wt.eu-S1765279AbXKOQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765279AbXKOQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbXKOQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:44:20 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:47174 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbXKOQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:44:19 -0500
Date: Thu, 15 Nov 2007 16:44:06 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on odd APIC behavior
In-Reply-To: <200711151627.25622.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64N.0711151637220.19041@blysk.ds.pg.gda.pl>
References: <200711150054.34312.oliver@neukum.org>
 <Pine.LNX.4.64N.0711151313410.19041@blysk.ds.pg.gda.pl>
 <200711151627.25622.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Oliver Neukum wrote:

> >  Certainly.  One possibility is to have multiple processors marked as the 
> > destination, e.g. a logical delivery mode destination programmed with 
> > multiple bits set.
> 
> What would be the consequences?

 It depends on the exact setup and conditions.

> I am seeing an interrupt for an UHCI on #20 CPU1 also arriving on
> #19 CPU0, triggering the spurious interrupt detection.

 Well, if you see spurious interrupt detection triggered, then it is not a 
problem with the interrupt being delivered multiple times (that's handled 
silently by the interrupt dispatched), but likely the interrupt line being 
deasserted too late.  Does it happen frequently?  If your ERR counter in 
/proc/interrupts increments quite fast, then perhaps a driver does not 
handle interrupts well enough for your system.  Or there is noise on an 
interrupt line.

 You would have to provide more information to get more accurate feedback.

  Maciej
