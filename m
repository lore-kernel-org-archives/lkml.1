Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYARM3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYARM3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYARM3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:29:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbYARM3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:29:39 -0500
Date: Fri, 18 Jan 2008 13:29:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080118122926.GA15216@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118122540.GH11044@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> perhaps the right solution would be to only build it in if 
> CONFIG_PCSPEAKER is "y" or "m". I.e. your original patch?

i've added your patch to x86.git - see below.

	Ingo

----------->
Subject: x86: fix unconditional arch/x86/kernel/pcspeaker.o compiling
From: Michael Opdenacker <michael-lists@free-electrons.com>

do not add the pcspkr platform device if pcspkr support is disabled.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-x86.q/arch/x86/kernel/Makefile
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/Makefile
+++ linux-x86.q/arch/x86/kernel/Makefile
@@ -68,7 +68,10 @@ obj-$(CONFIG_MGEODE_LX)		+= geode_32.o m
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+
+ifdef CONFIG_INPUT_PCSPKR
 obj-y				+= pcspeaker.o
+endif
 
 obj-$(CONFIG_SCx200)		+= scx200_32.o
 
