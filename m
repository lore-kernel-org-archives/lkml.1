Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbXKOSFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbXKOSFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbXKOSFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:05:10 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:52410 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbXKOSFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:05:09 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: question on odd APIC behavior
Date: Thu, 15 Nov 2007 19:05:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200711150054.34312.oliver@neukum.org> <200711151627.25622.oliver@neukum.org> <Pine.LNX.4.64N.0711151637220.19041@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0711151637220.19041@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151905.03005.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 November 2007 schrieb Maciej W. Rozycki:
> On Thu, 15 Nov 2007, Oliver Neukum wrote:

> > I am seeing an interrupt for an UHCI on #20 CPU1 also arriving on
> > #19 CPU0, triggering the spurious interrupt detection.
> 
>  Well, if you see spurious interrupt detection triggered, then it is not a 
> problem with the interrupt being delivered multiple times (that's handled 
> silently by the interrupt dispatched), but likely the interrupt line being 
> deasserted too late.  Does it happen frequently?  If your ERR counter in 
> /proc/interrupts increments quite fast, then perhaps a driver does not 
> handle interrupts well enough for your system.  Or there is noise on an 
> interrupt line.
> 
>  You would have to provide more information to get more accurate feedback.

On irq 20, there's an UHCI, on irq 19 is an EHCI. For every interrupt on 20
there's a spurious interrupt on 19. USB devices on bus of the controller on 20
work. So I know all interrupts are seen. ERR does not increase. Interrupts
for devices on the bus of the controller on 19 arrive at 19 only.
As far as I can determine there are really interrupts on both CPUs on
different vectors for one physical interrupt request.

	Regards
		Oliver
