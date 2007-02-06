Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbXBFHBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbXBFHBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXBFHBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:01:13 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44064 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbXBFHBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:01:12 -0500
Message-ID: <45C827B2.7050602@drzeus.cx>
Date: Tue, 06 Feb 2007 08:01:06 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, drzeus-wbsd@drzeus.cx
Subject: Re: wbsd: IRQ handler type mismatch
References: <45C7F32B.1060402@shaw.ca>
In-Reply-To: <45C7F32B.1060402@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> 
> It looks like wbsd is being loaded first, which being a nice PnP device
> sees that IRQ 6 is available and grabs it. Then the we try to load the
> floppy module (which is hard-coded to use IRQ 6) which fails because
> wbsd already owns IRQ6 (which is fine, there's no floppy controller
> anyway). The mismatch is occurring because wbsd passes IRQF_SHARED
> whereas floppy doesn't. I assume one of the two is likely wrong. Should
> wbsd really be passing IRQF_SHARED here? This is an LPC device which
> uses ISA-style edge triggered interrupts, is it safe to try and share an
> interrupt with this chip anyway?
> 

This is all perfectly valid. The wbsd hw and driver can handle sharing the
interrupt line, while the floppy cannot. If you want to avoid this, then don't
load the floppy driver or assign another irq for wbsd.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
