Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXHAH1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXHAH1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbXHAH1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:27:32 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4701 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbXHAH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:27:31 -0400
Message-ID: <46B0361C.2060709@genesi-usa.com>
Date: Wed, 01 Aug 2007 08:28:28 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, Alan Curry <pacman@theworld.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>	<3a538bd3f5db759abb55a661e6e94c7a@kernel.crashing.org> <46B03561.9090800@genesi-usa.com>
In-Reply-To: <46B03561.9090800@genesi-usa.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just so you guys have it all in one pretty little package, these will remove
the need for the Pegasos IDE and ISA fixups in the prom_init.c too.

s" /pci@80000000/ide@C,1" find-device
d# 14 encode-int 0 encode-int
d# 15 encode-int 0 encode-int
encode+ encode+ encode+ s" interrupts" property
0x1018a encode-int s" class-code" property
device-end

s" /pci@80000000/isa@C" find-device
0x1 encode-int 0x0 encode-int 0x1006000 encode-int
0x0 encode-int 0x0 encode-int 0x1000 encode-int
encode+ encode+ encode+ encode+ encode+ s" ranges" property
device-end

If anyone wants to test and confirm the 8042 fix and then we can add
it to the end here.. we can unclutter the kernel.

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Matt Sealey wrote:
> Yeah please do a fixup for the boot wrapper.
> 
> Or, if you have trouble, go into the firmware and type "nvedit", add
> these lines;
> 
> " /isa/8042" find-device
> " 8042" encode-string device-type
> 
> (then ctrl-c to exit and nvstore to run it on next reboot. Try it without
> the patch first, on the firmware console, just to be sure I got it right,
> because I can't test it here)
> 
> You don't need to patch Linux at all. In fact for silly things like this
> I would recommend against it :)
> 
