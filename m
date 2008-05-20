Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbYETOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbYETOcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYETOcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:32:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYETOcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:32:04 -0400
Date: Tue, 20 May 2008 09:19:43 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
Message-ID: <20080520131943.GA4843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	hpa@zytor.com
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:49:28PM -0700, Yinghai Lu wrote:

 > > +       case X86_VENDOR_CENTAUR:
 > > +               if ((c->x86 > 6) || (c->x86 == 6 && c->x86_model >= 10))
 > > +                       set_cpu_cap(c, X86_FEATURE_PAT);
 > > +               break;
 > >        }
 > >
 > >        pat_disable(cpu_has_pat ?
 > 
 > you may need to return early...

Argh, old version of the patch.  This one should be right.

	Dave

---


>From conversation with Centaur engineers, both the newer generations
of the VIA C7, and their future CPUs support PAT, with no known errata.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..b9f14f9 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -62,6 +62,10 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
 			return;
 		break;
+	case X86_VENDOR_CENTAUR:
+		if ((c->x86 > 6) || (c->x86 == 6 && c->x86_model >= 10))
+			return;
+		break;
 	}
 
 	pat_disable(cpu_has_pat ?


-- 
http://www.codemonkey.org.uk
