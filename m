Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYB1Gpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYB1Gpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYB1Gp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:28 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:47789 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYB1Gp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:27 -0500
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Adrian Bunk'" <bunk@kernel.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Jesper Nilsson" <Jesper.Nilsson@axis.com>
Cc: "'Sam Ravnborg'" <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: RE: cris: build creates links in the source directory
Date: Thu, 28 Feb 2008 07:45:00 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C404A8@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66805B645B0@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is correct and we have thoughts about using Makfiles and compiler flags
to resolve this instead as done for other architectures.

/Mikael

-----Original Message-----
From: Adrian Bunk [mailto:bunk@kernel.org] 
Sent: Wednesday, February 27, 2008 11:06 PM
To: Mikael Starvik; Jesper Nilsson
Cc: dev-etrax; Sam Ravnborg; linux-kernel@vger.kernel.org
Subject: cris: build creates links in the source directory


Especially when building with a separate object directory the following 
part of arch/cris/Makefile is not so nice since it creates links in the 
source directory:

<--  snip  -->

# Create some links to make all tools happy
$(SRC_ARCH)/.links:
        @rm -rf $(SRC_ARCH)/drivers
        @ln -sfn $(SARCH)/drivers $(SRC_ARCH)/drivers
        @rm -rf $(SRC_ARCH)/boot
        @ln -sfn $(SARCH)/boot $(SRC_ARCH)/boot
        @rm -rf $(SRC_ARCH)/lib
        @ln -sfn $(SARCH)/lib $(SRC_ARCH)/lib
        @rm -f $(SRC_ARCH)/arch/mach
        @rm -rf $(SRC_ARCH)/arch
        @ln -sfn $(SARCH) $(SRC_ARCH)/arch
ifdef CONFIG_ETRAX_ARCH_V32
        @ln -sfn ../$(SARCH)/$(MACH) $(SRC_ARCH)/arch/mach
endif
        @rm -rf $(SRC_ARCH)/kernel/vmlinux.lds.S
        @ln -sfn ../$(SARCH)/vmlinux.lds.S $(SRC_ARCH)/kernel/vmlinux.lds.S
        @rm -rf $(SRC_ARCH)/kernel/asm-offsets.c
        @ln -sfn ../$(SARCH)/kernel/asm-offsets.c
$(SRC_ARCH)/kernel/asm-offsets.c
        @touch $@

# Create link to sub arch includes
$(srctree)/include/asm-$(ARCH)/.arch: $(wildcard 
include/config/arch/*.h)
        @echo '  SYMLINK include/asm-$(ARCH)/arch ->
include/asm-$(ARCH)/$(SARCH)'
        @rm -f $(srctree)/include/asm-$(ARCH)/arch/mach
        @rm -f $(srctree)/include/asm-$(ARCH)/arch
        @ln -sf $(SARCH) $(srctree)/include/asm-$(ARCH)/arch
ifdef CONFIG_ETRAX_ARCH_V32
        @ln -sf $(MACH) $(srctree)/include/asm-$(ARCH)/arch/mach
endif
        @touch $@

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

