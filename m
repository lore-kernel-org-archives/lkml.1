Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZGUVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZGUVs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZGUVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:48:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:23558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbZGUVsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,242,1246863600"; 
   d="scan'208";a="534770656"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Sam Ravnborg'" <sam@ravnborg.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-kbuild@vger.kernel.org'" <linux-kbuild@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>
CC: "'Al Viro'" <viro@zeniv.linux.org.uk>, "Luck, Tony" <tony.luck@intel.com>
Date: Tue, 21 Jul 2009 14:48:22 -0700
Subject: RE: [PATCH 03/10] ia64: move nr-irqs.h to include/generated
Thread-Topic: [PATCH 03/10] ia64: move nr-irqs.h to include/generated
Thread-Index: AcoKSHGuJP9IZmgaQZGWRPeYF1/MkQAA7nGg
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B09F47F2@orsmsx505.amr.corp.intel.com>
References: <20090721211040.GA7688@merkur.ravnborg.org>
 <1248211181-6757-3-git-send-email-sam@ravnborg.org>
In-Reply-To: <1248211181-6757-3-git-send-email-sam@ravnborg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>---
> arch/ia64/Makefile          |    2 +-
> arch/ia64/include/asm/irq.h |    2 +-
> arch/ia64/kernel/Makefile   |    7 ++-----
> 3 files changed, 4 insertions(+), 7 deletions(-)
>
>diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
>index 58a7e46..e9fcac6 100644
>--- a/arch/ia64/Makefile
>+++ b/arch/ia64/Makefile
>@@ -108,4 +108,4 @@ archprepare: make_nr_irqs_h FORCE
> PHONY += make_nr_irqs_h FORCE
>
> make_nr_irqs_h: FORCE
>-	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/asm-ia64/nr-irqs.h
>+	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/generated/nr-irqs.h
>diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
>index 5282546..91b920f 100644
>--- a/arch/ia64/include/asm/irq.h
>+++ b/arch/ia64/include/asm/irq.h
>@@ -13,7 +13,7 @@
>
> #include <linux/types.h>
> #include <linux/cpumask.h>
>-#include <asm-ia64/nr-irqs.h>
>+#include <generated/nr-irqs.h>
>
> static __inline__ int
> irq_canonicalize (int irq)
>diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
>index 6b7edca..cedd773 100644
>--- a/arch/ia64/kernel/Makefile
>+++ b/arch/ia64/kernel/Makefile
>@@ -81,17 +81,14 @@ define cmd_nr_irqs
> endef
>
> # We use internal kbuild rules to avoid the "is up to date" message from
>make
>-arch/$(SRCARCH)/kernel/nr-irqs.s: $(srctree)/arch/$(SRCARCH)/kernel/nr-
>irqs.c \
>-				$(wildcard $(srctree)/include/asm-ia64/*/irq.h)
>+arch/ia64/kernel/nr-irqs.s: arch/ia64/kernel/nr-irqs.c
> 	$(Q)mkdir -p $(dir $@)
> 	$(call if_changed_dep,cc_s_c)
>

Could you keep the SRCARCH and srctree variables? There is no need to hard code them.

>-include/asm-ia64/nr-irqs.h: arch/$(SRCARCH)/kernel/nr-irqs.s
>+include/generated/nr-irqs.h: arch/ia64/kernel/nr-irqs.s
> 	$(Q)mkdir -p $(dir $@)
> 	$(call cmd,nr_irqs)
>
>-clean-files += $(objtree)/include/asm-ia64/nr-irqs.h
>-
> #
> # native ivt.S, entry.S and fsys.S
> #

Ditto.

