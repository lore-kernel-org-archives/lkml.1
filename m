Return-Path: <linux-kernel-owner+w=401wt.eu-S1763868AbXJEUEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763868AbXJEUEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759853AbXJEUEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:04:22 -0400
Received: from mail.suse.de ([195.135.220.2]:34915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624AbXJEUEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:04:21 -0400
From: Andreas Schwab <schwab@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr>
	<470694E0.7030408@freescale.com>
X-Yow: It's a lot of fun being alive...  I wonder if my bed is made?!?
Date: Fri, 05 Oct 2007 22:04:18 +0200
In-Reply-To: <470694E0.7030408@freescale.com> (Timur Tabi's message of "Fri\,
	05 Oct 2007 14\:47\:44 -0500")
Message-ID: <jed4vtnxa5.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> I'm writing a driver that talks to hardware that has a shift register.
> The register can be shifted either left or right, so all the bits
> obviously have to be in order, but it can be either order.

Bit addressing is strictly internal to the cpu, the smallest unit that
the cpu can address externally is a byte.  The only place where bit
order matters on the C level is in a bitfield that is overlayed over a
block of memory, but this is not visible outside the cpu.

> What I want to do is to have the driver detect when byte-endianness
> doesn't match bit-endianness when it writes the the word to a
> memory-mapped device.

The bit mapping on your device is strictly internal to the device and
has nothing to do with bit order on the C level.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
