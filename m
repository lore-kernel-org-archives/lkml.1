Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYCOTU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYCOTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 15:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYCOTUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 15:20:16 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2652 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYCOTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 15:20:14 -0400
Date: Sat, 15 Mar 2008 20:19:46 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: K8, EFFICEON and CORE2 support the cmovxx instructions.
Message-ID: <20080315191946.GA21817@mailshack.com>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205530409.27413.1242484373@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sat, 15 Mar 2008 20:19:48 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.31; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K8, EFFICEON and CORE2 support the cmovxx instructions.

Instead of listing the cpu's that have support for the
cmovxx instructions, list the cpu's that don't.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---

A bit of playing resulted in:

CPUS="M386 M486 M586 M586TSC M586MMX M686 MPENTIUMII MPENTIUMIII"
CPUS=$CPUS" MPENTIUMM MPENTIUM4 MK6 MK7 MK8 MCRUSOE MEFFICEON"
CPUS=$CPUS" MWINCHIPC6 MWINCHIP2 MWINCHIP3D MGEODEGX1 MGEODE_LX"
CPUS=$CPUS" MCYRIXIII MVIAC3_2 MVIAC7 MPSC MCORE2"

for cpu in $CPUS
do
        echo "CONFIG_${cpu}=y" > testconfig
        make ARCH=i386 allnoconfig KCONFIG_ALLCONFIG=testconfig > /dev/null
        echo ${cpu} >> result
        grep X86_CMOV .config >> result
        echo >> result
done

I'm quite sure that K8, EFFICEON and CORE2 support HAVE_CMOV, but
they did not set X86_CMOV.

Greetings,
	Alexander van Heukelum

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 31e92fb..7a3a2d4 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -399,7 +399,7 @@ config X86_TSC
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	depends on !(MCYRIXIII || MGEODE_LX || MGEODEGX1 || MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MK6 || M586MMX || M586TSC || M586 || M486 || M386)
 
 config X86_MINIMUM_CPU_FAMILY
 	int

