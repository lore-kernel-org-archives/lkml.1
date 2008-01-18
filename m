Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYARFZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYARFZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYARFZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:25:24 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:56779 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYARFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:25:23 -0500
Date: Fri, 18 Jan 2008 00:25:22 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: remove redundant cpu_has_ definitions
Message-ID: <20080118052522.GA1726@phobos.i.cabal.ca>
References: <20080118045921.GB974@phobos.i.cabal.ca> <47903376.9050204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47903376.9050204@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:04:54AM -0500, H. Peter Anvin wrote:
> Unnecessary.  These overrides are only needed for the anticases (known to 
> be zero) or for some special hacks.
>

Cool, guess that means a bunch of them can go...

> Stuff that have proper CPUID bits get these defined as constants via the  
> REQUIRED_MASK macros.
>

PSE, PGE, XMM, XMM2, and FXSR are defined as required features, and
will be optimized to a constant at compile time. Remove their redundant
definitions.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -195,21 +195,6 @@
 #undef  cpu_has_centaur_mcr
 #define cpu_has_centaur_mcr	0
 
-#undef  cpu_has_pse
-#define cpu_has_pse		1
-
-#undef  cpu_has_pge
-#define cpu_has_pge		1
-
-#undef  cpu_has_xmm
-#define cpu_has_xmm		1
-
-#undef  cpu_has_xmm2
-#define cpu_has_xmm2		1
-
-#undef  cpu_has_fxsr
-#define cpu_has_fxsr		1
-
 #endif /* CONFIG_X86_64 */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
