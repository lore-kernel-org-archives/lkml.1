Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZFTBVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZFTBVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbZFTBST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:19 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39148 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759358AbZFTBSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:18:07 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: D4SymNIVM1n6X0cIvMEgfo_IxrFCI3f5zCSUDaRdqjVxzsAG_a6x1R1qqd8cgZK_1zbwfLLwzJYW0pJMYemP9dov_rfXk6_C.Qx097iMl_qDSwcc_xYRr_EzIn8e9nb2kCrh2pZL_B8gA1tgvIT9jHYDkONHaols7K3WpmOPTdxzGGhu2cAYLjtLrKQgJBocUNoYfNQlARCnJDI8nmvhDKeB6QOpHB606XYrn1b7e2BS8SCcGvW7fAykGNMxWO5AITufZXOSzAI6oOEJ9BtUiXhkC8.WF9y9qv1qj564bEOB8Wz8D34PST5lX_eJdVq..PgE1fbFsP2rJ5xqqcCOqvnXaYxS_m.IilEiCOM2kf9p5tp2IW3gjhk-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 13/13] generic GPIO support misc files.
Date: Fri, 19 Jun 2009 18:11:12 -0700
Message-Id: <1245460272-4329-14-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-13-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-9-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-10-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-11-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-12-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-13-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of MCFSIM_PADDR and MCFSIM_PADAT now has MCF_BAR already added in.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/mcfsmc.h |    6 +++---
 arch/m68k/include/asm/nettel.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/include/asm/mcfsmc.h b/arch/m68k/include/asm/mcfsmc.h
index 2d7a4db..527bea5 100644
--- a/arch/m68k/include/asm/mcfsmc.h
+++ b/arch/m68k/include/asm/mcfsmc.h
@@ -167,15 +167,15 @@ void smc_remap(unsigned int ioaddr)
 	static int		once = 0;
 	extern unsigned short	ppdata;
 	if (once++ == 0) {
-		*((volatile unsigned short *)(MCF_MBAR+MCFSIM_PADDR)) = 0x00ec;
+		*((volatile unsigned short *)MCFSIM_PADDR) = 0x00ec;
 		ppdata |= 0x0080;
-		*((volatile unsigned short *)(MCF_MBAR+MCFSIM_PADAT)) = ppdata;
+		*((volatile unsigned short *)MCFSIM_PADAT) = ppdata;
 		outw(0x0001, ioaddr + BANK_SELECT);
 		outw(0x0001, ioaddr + BANK_SELECT);
 		outw(0x0067, ioaddr + BASE);
 
 		ppdata &= ~0x0080;
-		*((volatile unsigned short *)(MCF_MBAR+MCFSIM_PADAT)) = ppdata;
+		*((volatile unsigned short *)MCFSIM_PADAT) = ppdata;
 	}
 	
 	*((volatile unsigned short *)(MCF_MBAR+MCFSIM_CSCR3)) = 0x1180;
diff --git a/arch/m68k/include/asm/nettel.h b/arch/m68k/include/asm/nettel.h
index 0299f6a..4dec2d9 100644
--- a/arch/m68k/include/asm/nettel.h
+++ b/arch/m68k/include/asm/nettel.h
@@ -48,14 +48,14 @@ extern volatile unsigned short ppdata;
 static __inline__ unsigned int mcf_getppdata(void)
 {
 	volatile unsigned short *pp;
-	pp = (volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT);
+	pp = (volatile unsigned short *) MCFSIM_PADAT;
 	return((unsigned int) *pp);
 }
 
 static __inline__ void mcf_setppdata(unsigned int mask, unsigned int bits)
 {
 	volatile unsigned short *pp;
-	pp = (volatile unsigned short *) (MCF_MBAR + MCFSIM_PADAT);
+	pp = (volatile unsigned short *) MCFSIM_PADAT;
 	ppdata = (ppdata & ~mask) | bits;
 	*pp = ppdata;
 }
-- 
1.5.6.5

