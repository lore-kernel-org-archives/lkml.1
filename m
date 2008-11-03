Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYKCPIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYKCPIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYKCPIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:08:45 -0500
Received: from aun.it.uu.se ([130.238.12.36]:59588 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbYKCPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:08:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18703.5082.59702.571742@harpo.it.uu.se>
Date: Mon, 3 Nov 2008 16:08:10 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk
Subject: Re: next-20081103: arch/arm/kernel/elf.c:30: error: 'e_flags'
	undeclared
In-Reply-To: <20081103142801.GA3918@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au>
	<20081103142801.GA3918@x200.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan writes:
 > s/e_flags/eflags/ but I'm not sure.

Correct. I sent the fixup patch below to rmk and the linux arm mailing
list yesterday, but I guess it hasn't found it's way to linux-next yet:

--- linux-2.6.28-rc2/arch/arm/kernel/elf.c.~1~	2008-11-02 16:24:46.000000000 +0100
+++ linux-2.6.28-rc2/arch/arm/kernel/elf.c	2008-11-02 16:25:49.000000000 +0100
@@ -27,7 +27,7 @@ int elf_check_arch(const struct elf32_hd
 		if ((eflags & EF_ARM_APCS_26) && !(elf_hwcap & HWCAP_26BIT))
 			return 0;
 
-		flt_fmt = e_flags & (EF_ARM_VFP_FLOAT | EF_ARM_SOFT_FLOAT);
+		flt_fmt = eflags & (EF_ARM_VFP_FLOAT | EF_ARM_SOFT_FLOAT);
 
 		/* VFP requires the supporting code */
 		if (flt_fmt == EF_ARM_VFP_FLOAT && !(elf_hwcap & HWCAP_VFP))

