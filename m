Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbXE1SLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbXE1SLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXE1SLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:11:08 -0400
Received: from za-gw.sanpeople.com ([196.211.225.226]:2041 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXE1SLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:11:07 -0400
Subject: Re: ARM: Section mismatch warnings
From: Andrew Victor <andrew@sanpeople.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070528170430.GB5737@flint.arm.linux.org.uk>
References: <20070528163253.GA29174@uranus.ravnborg.org>
	 <20070528170430.GB5737@flint.arm.linux.org.uk>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1180374973.2537.54.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 28 May 2007 19:56:14 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi Russell,

> > o-arm-ks8695/log.out:WARNING: arch/arm/mach-ks8695/built-in.o(.data+0x108):
>  Section mismatch: reference to .init.text:micrel_pci_map_irq
>  (after 'micrel_pci')
> 
> If this platform can have PCI stuff hotplugged, then this is a problem.
> If it's fixed then it isn't - PCI IRQ routing will only be used at boot
> time.  IOW, whether such a thing is a problem is conditional on the
> hardware/configuration which I'm not aware of.

The Micrel board doesn't support hotplugged PCI devices.
I guess other KS8695-based boards can have a PCI-to-Cardbus controller,
and that would need hotpluged PCI support.

But technically that function should probably not be marked as __init.
And "struct ks8695_pci_cfg" should be __initdata.

The PCI support for the KS8695 is not currently merged in mainline.  So
I will fix this (if nobody has yet) once the PCI support goes in.


Regards,
  Andrew Victor


