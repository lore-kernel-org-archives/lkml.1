Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYB0WHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYB0WHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYB0WHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:07:07 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35325 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbYB0WHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:07:06 -0500
Date: Thu, 28 Feb 2008 00:05:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: dev-etrax@axis.com, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: cris: build creates links in the source directory
Message-ID: <20080227220555.GY29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
        @ln -sfn ../$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
        @touch $@

# Create link to sub arch includes
$(srctree)/include/asm-$(ARCH)/.arch: $(wildcard 
include/config/arch/*.h)
        @echo '  SYMLINK include/asm-$(ARCH)/arch -> include/asm-$(ARCH)/$(SARCH)'
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

