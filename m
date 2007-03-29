Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXC2Tq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXC2Tq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934143AbXC2Tq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:46:56 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:33565 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934142AbXC2Tqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:46:55 -0400
Date: Thu, 29 Mar 2007 14:43:14 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Linus Torvalds <torvalds@osdl.org>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       chuckmeade@mindspring.com
Subject: Please pull from 'for_linus' branch
Message-ID: <Pine.LNX.4.64.0703291434500.23408@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from 'for_linus' branch of
master.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git

These are a few fixes for 2.6.21 related to the quicc engine support.

to receive the following updates:

 arch/powerpc/sysdev/qe_lib/qe.c |    6 +++---
 include/asm-powerpc/immap_qe.h  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

Chuck Meade (1):
      [POWERPC] qe: Fix QUICC Engine SDMA setup errors

Timur Tabi (1):
      [POWERPC] qe: ucc_slow.guemr is in the wrong place

diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index e3d71e0..43f6cc9 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -251,13 +251,13 @@ static int qe_sdma_init(void)

 	/* allocate 2 internal temporary buffers (512 bytes size each) for
 	 * the SDMA */
-	sdma_buf_offset = qe_muram_alloc(512 * 2, 64);
+ 	sdma_buf_offset = qe_muram_alloc(512 * 2, 4096);
 	if (IS_MURAM_ERR(sdma_buf_offset))
 		return -ENOMEM;

 	out_be32(&sdma->sdebcr, sdma_buf_offset & QE_SDEBCR_BA_MASK);
-	out_be32(&sdma->sdmr, (QE_SDMR_GLB_1_MSK | (0x1 >>
-					QE_SDMR_CEN_SHIFT)));
+ 	out_be32(&sdma->sdmr, (QE_SDMR_GLB_1_MSK |
+ 					(0x1 << QE_SDMR_CEN_SHIFT)));

 	return 0;
 }
diff --git a/include/asm-powerpc/immap_qe.h b/include/asm-powerpc/immap_qe.h
index 9fdd049..1020b7f 100644
--- a/include/asm-powerpc/immap_qe.h
+++ b/include/asm-powerpc/immap_qe.h
@@ -258,8 +258,9 @@ struct ucc_slow {
 	u8	uccs;		/* UCCx status register */
 	u8	res3[0x24];
 	__be16	utpt;
+	u8	res4[0x52];
 	u8	guemr;		/* UCC general extended mode register */
-	u8	res4[0x200 - 0x091];
+	u8	res5[0x200 - 0x091];
 } __attribute__ ((packed));

 /* QE UCC Fast */
