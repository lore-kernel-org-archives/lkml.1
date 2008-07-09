Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYGIGFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYGIGFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYGIGFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:05:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYGIGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:05:41 -0400
Date: Wed, 9 Jul 2008 08:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] Update x86 mmr list for SGI uv
Message-ID: <20080709060526.GE9760@elte.hu>
References: <20080702203935.GC6076@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080702203935.GC6076@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> This patch updates the X86 mmr list for SGI uv.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

applied to tip/x86/core, thanks Dimitri. I needed the two build fixes 
below - there were two duplicate sections introduced by the patch.

	Ingo

----------------------->
commit 5a7e02c712b848ab8627118f2cf2f524f83353a0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 08:02:54 2008 +0200

    x86, uv: build fix #2 for "x86, uv: update x86 mmr list for SGI uv"
    
    fix:
    
     In file included from arch/x86/kernel/tlb_uv.c:14:
     include/asm/uv/uv_mmrs.h:986: error: redefinition of ‘union uvh_rh_gam_cfg_overlay_config_mmr_u’
     include/asm/uv/uv_mmrs.h:988: error: redefinition of ‘struct uvh_rh_gam_cfg_overlay_config_mmr_s’
     include/asm/uv/uv_mmrs.h:1064: error: redefinition of ‘union uvh_rh_gam_mmioh_overlay_config_mmr_u’
     include/asm/uv/uv_mmrs.h:1066: error: redefinition of ‘struct uvh_rh_gam_mmioh_overlay_config_mmr_s’
    
    caused by another duplicate section (cut & paste error) in commit
    5d061e397db1 "x86, uv: update x86 mmr list for SGI uv".
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/uv/uv_mmrs.h b/include/asm-x86/uv/uv_mmrs.h
index a8a1ad5..151fd7f 100644
--- a/include/asm-x86/uv/uv_mmrs.h
+++ b/include/asm-x86/uv/uv_mmrs.h
@@ -1028,32 +1028,6 @@ union uvh_rh_gam_mmioh_overlay_config_mmr_u {
 };
 
 /* ========================================================================= */
-/*                   UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR                     */
-/* ========================================================================= */
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
-
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_rh_gam_mmioh_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_mmioh_overlay_config_mmr_s {
-	unsigned long	rsvd_0_29: 30;  /*    */
-	unsigned long	base   : 16;  /* RW */
-	unsigned long	m_io   :  6;  /* RW */
-	unsigned long	n_io   :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
 /*                    UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
commit b50853c59620459f7389862c3ecbacfd49c5b443
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 08:02:54 2008 +0200

    x86, uv: build fix #2 for "x86, uv: update x86 mmr list for SGI uv"
    
    fix:
    
     In file included from arch/x86/kernel/tlb_uv.c:14:
     include/asm/uv/uv_mmrs.h:986: error: redefinition of ‘union uvh_rh_gam_cfg_overlay_config_mmr_u’
     include/asm/uv/uv_mmrs.h:988: error: redefinition of ‘struct uvh_rh_gam_cfg_overlay_config_mmr_s’
     include/asm/uv/uv_mmrs.h:1064: error: redefinition of ‘union uvh_rh_gam_mmioh_overlay_config_mmr_u’
     include/asm/uv/uv_mmrs.h:1066: error: redefinition of ‘struct uvh_rh_gam_mmioh_overlay_config_mmr_s’
    
    caused by another duplicate section (cut & paste error) in commit
    5d061e397db1 "x86, uv: update x86 mmr list for SGI uv".
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/uv/uv_mmrs.h b/include/asm-x86/uv/uv_mmrs.h
index a8a1ad5..151fd7f 100644
--- a/include/asm-x86/uv/uv_mmrs.h
+++ b/include/asm-x86/uv/uv_mmrs.h
@@ -1028,32 +1028,6 @@ union uvh_rh_gam_mmioh_overlay_config_mmr_u {
 };
 
 /* ========================================================================= */
-/*                   UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR                     */
-/* ========================================================================= */
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
-
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_rh_gam_mmioh_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_mmioh_overlay_config_mmr_s {
-	unsigned long	rsvd_0_29: 30;  /*    */
-	unsigned long	base   : 16;  /* RW */
-	unsigned long	m_io   :  6;  /* RW */
-	unsigned long	n_io   :  4;  /* RW */
-	unsigned long	rsvd_56_62:  7;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
 /*                    UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
