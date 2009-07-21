Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbZGUV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbZGUV60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZGUV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:58:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33775 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZGUV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:58:24 -0400
Date: Tue, 21 Jul 2009 23:58:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-kbuild@vger.kernel.org'" <linux-kbuild@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 03/10] ia64: move nr-irqs.h to include/generated
Message-ID: <20090721215823.GA7797@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org> <1248211181-6757-3-git-send-email-sam@ravnborg.org> <A6AD88C3F2289247BE726C37303E1EB8B09F47F2@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B09F47F2@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 02:48:22PM -0700, Yu, Fenghua wrote:
> >---
> > arch/ia64/Makefile          |    2 +-
> > arch/ia64/include/asm/irq.h |    2 +-
> > arch/ia64/kernel/Makefile   |    7 ++-----
> > 3 files changed, 4 insertions(+), 7 deletions(-)
> >
> >diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
> >index 58a7e46..e9fcac6 100644
> >--- a/arch/ia64/Makefile
> >+++ b/arch/ia64/Makefile
> >@@ -108,4 +108,4 @@ archprepare: make_nr_irqs_h FORCE
> > PHONY += make_nr_irqs_h FORCE
> >
> > make_nr_irqs_h: FORCE
> >-	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/asm-ia64/nr-irqs.h
> >+	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/generated/nr-irqs.h
> >diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
> >index 5282546..91b920f 100644
> >--- a/arch/ia64/include/asm/irq.h
> >+++ b/arch/ia64/include/asm/irq.h
> >@@ -13,7 +13,7 @@
> >
> > #include <linux/types.h>
> > #include <linux/cpumask.h>
> >-#include <asm-ia64/nr-irqs.h>
> >+#include <generated/nr-irqs.h>
> >
> > static __inline__ int
> > irq_canonicalize (int irq)
> >diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
> >index 6b7edca..cedd773 100644
> >--- a/arch/ia64/kernel/Makefile
> >+++ b/arch/ia64/kernel/Makefile
> >@@ -81,17 +81,14 @@ define cmd_nr_irqs
> > endef
> >
> > # We use internal kbuild rules to avoid the "is up to date" message from
> >make
> >-arch/$(SRCARCH)/kernel/nr-irqs.s: $(srctree)/arch/$(SRCARCH)/kernel/nr-
> >irqs.c \
> >-				$(wildcard $(srctree)/include/asm-ia64/*/irq.h)
> >+arch/ia64/kernel/nr-irqs.s: arch/ia64/kernel/nr-irqs.c
> > 	$(Q)mkdir -p $(dir $@)
> > 	$(call if_changed_dep,cc_s_c)
> >
> 
> Could you keep the SRCARCH and srctree variables? There is no need to hard code them.

I will update my patch to continue using SRCARCH.

I usually hardcode the name of the arch because it makes the
code IMO more explicit and thus more readable.

The use of srctree is not needed but I can add that back too.
Both changes are unrelated to the actual patch and I
just rutinely made it look like I would have doen it.


> 
> >-include/asm-ia64/nr-irqs.h: arch/$(SRCARCH)/kernel/nr-irqs.s
> >+include/generated/nr-irqs.h: arch/ia64/kernel/nr-irqs.s
> > 	$(Q)mkdir -p $(dir $@)
> > 	$(call cmd,nr_irqs)
> >
> >-clean-files += $(objtree)/include/asm-ia64/nr-irqs.h
> >-
> > #
> > # native ivt.S, entry.S and fsys.S
> > #
> 
> Ditto.
OK.

	Sam
