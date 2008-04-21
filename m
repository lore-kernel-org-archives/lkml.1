Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYDUTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYDUTTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbYDUTSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:18:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbYDUTSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:18:51 -0400
Date: Mon, 21 Apr 2008 21:18:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: kgdb build error
Message-ID: <20080421191838.GB3104@elte.hu>
References: <480C78AF.1060903@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C78AF.1060903@trash.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Patrick McHardy <kaber@trash.net> wrote:

> I get this build error with current -git on x86_64 (config attached):
>
>   CC      arch/x86/kernel/kgdb.o
> arch/x86/kernel/kgdb.c:52:28: error: asm/mach_apic.h: No such file or 
> directory
> arch/x86/kernel/kgdb.c: In function 'kgdb_roundup_cpus':
> arch/x86/kernel/kgdb.c:337: error: implicit declaration of function 
> 'send_IPI_allbutself'

yep, this should fix it:

  http://lkml.org/lkml/2008/4/19/35

(also attached below, or available in x86.git.)

	Ingo

------------------------->
Subject: x86: KGDB build fix
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kgdb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-x86.q/arch/x86/kernel/kgdb.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/kgdb.c
+++ linux-x86.q/arch/x86/kernel/kgdb.c
@@ -46,11 +46,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
-#ifdef CONFIG_X86_32
-# include <mach_ipi.h>
-#else
-# include <asm/mach_apic.h>
-#endif
+#include <mach_ipi.h>
 
 /*
  * Put the error code here just in case the user cares:
