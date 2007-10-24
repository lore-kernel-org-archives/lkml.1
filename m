Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXJXGxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXJXGxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXJXGxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:53:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60620 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbXJXGxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:53:34 -0400
Date: Wed, 24 Oct 2007 02:51:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: is CONFIG_APUS sufficiently deceased to be removed?
Message-ID: <Pine.LNX.4.64.0710240244490.7685@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  since a couple relatively recent commits show support for APUS being
ripped out of powerpc:

commit e6b6e3ffb9ee8926f9f2f7dc9147df73e27d5828
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Aug 27 23:29:53 2007 +0200

    [POWERPC] Remove APUS support from arch/ppc

    Current status of APUS:
    - arch/powerpc/: removed in 2.6.23
    - arch/ppc/: marked BROKEN since 2 years

    This therefore removes the remaining parts of APUS support from
    arch/ppc, include/asm-ppc, arch/powerpc and include/asm-powerpc.

    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
...
commit f21f49ea639ac3f24824177dac1268af75a2d373
Author: David Gibson <david@gibson.dropbear.id.au>
Date:   Wed Jun 13 14:52:54 2007 +1000

    [POWERPC] Remove the dregs of APUS support from arch/powerpc

    APUS (the Amiga Power-Up System) is not supported under arch/powerpc
    and it's unlikely it ever will be.  Therefore, this patch removes the
    fragments of APUS support code from arch/powerpc which have been
    copied from arch/ppc.

    A few APUS references are left in asm-powerpc in .h files which are
    still used from arch/ppc.

    Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
...

is it safe to assume that references to that non-existent Kconfig
variable can be tossed?

drivers/ide/ide-probe.c:#if defined(__mc68000__) || defined(CONFIG_APUS)
drivers/ide/ide-probe.c:#endif /* __mc68000__ || CONFIG_APUS */
drivers/ide/ide-probe.c:#if !defined(__mc68000__) && !defined(CONFIG_APUS)
drivers/ide/ide-probe.c:#endif /* __mc68000__ && CONFIG_APUS */
drivers/isdn/hisax/avm_pci.c:#ifdef CONFIG_APUS
drivers/isdn/hisax/avm_pci.c:#endif /* CONFIG_APUS */
drivers/isdn/hisax/avm_pci.c:#ifdef CONFIG_APUS
drivers/isdn/hisax/avm_pci.c:#endif /* CONFIG_APUS */
drivers/video/console/fbcon.c:#if defined(__mc68000__) || defined(CONFIG_APUS)
drivers/video/console/fonts.c:#if defined(__mc68000__) || defined(CONFIG_APUS)
drivers/video/console/fonts.c:#if defined(__mc68000__) || defined(CONFIG_APUS)
drivers/scsi/oktagon_esp.c:#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
drivers/scsi/oktagon_io.S:#ifdef CONFIG_APUS
sound/oss/dmasound/dmasound_paula.c:#ifdef CONFIG_APUS    [well, i'd ignore this one]

  and i'm guessing this can be nullified as well, yes?  no?

arch/m68k/amiga/chipram.c:#ifndef CONFIG_APUS_FAST_EXCEPT

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
