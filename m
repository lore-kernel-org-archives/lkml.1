Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZJKRdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZJKRdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbZJKRdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:33:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:47408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZJKRdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:33:03 -0400
Date: Sun, 11 Oct 2009 10:33:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       hpa@zytor.com
Subject: Re: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED
Message-ID: <20091011103302.62bded41@infradead.org>
In-Reply-To: <adaiqelj20l.fsf@cisco.com>
References: <20091011084311.0ab3c3ea@infradead.org>
	<adaiqelj20l.fsf@cisco.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 10:04:10 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> Makes sense, but given that X86_PAT depends on MTRR
> 
>  config X86_PAT
>  	bool
> -	prompt "x86 PAT support"
> +	default y
> +	prompt "x86 PAT support" if EMBEDDED
>  	depends on MTRR
> 
> should we give the same treatment to the MTRR option too?  (As far as
> I can tell, MTRR defaults to n in the current Kconfig too)
> 

good point



>From db3a4eb2b16907c0651ed5d4bcdfbd395a0a7ad4 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 11 Oct 2009 08:40:15 -0700
Subject: [PATCH] x86: Relegate CONFIG_X86_PAT and CONFIG_MTRR to EMBEDDED

MTRR and PAT support (which got added to CPUs over 10 years ago) are no
longer really optional in that more and more things are depending on PAT
just working, including various drivers and newer versions of X.  (to not
even speak of MTRR)
Having this as a regular config option just no longer makes sense.

This patch relegates CONFIG_X86_PAT to the EMBEDDED category, in the hope to
eventually completely retire it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4427956..2fbc3c6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1327,7 +1327,9 @@ config MATH_EMULATION
 	  kernel, it won't hurt.
 
 config MTRR
-	bool "MTRR (Memory Type Range Register) support"
+	bool
+	default y
+	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1393,7 +1395,8 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	bool
-	prompt "x86 PAT support"
+	default y
+	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
-- 
1.6.2.5




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
