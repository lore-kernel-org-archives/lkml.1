Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbYARWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbYARWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760707AbYARWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:03:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759132AbYARWDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:03:08 -0500
Date: Fri, 18 Jan 2008 23:02:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
Message-ID: <20080118220200.GA1071@elte.hu>
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080118203259.GA3079@elte.hu> <20080118213711.GA24979@elte.hu> <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> > but in exchange you broke all of 32-bit with CONFIG_PARAVIRT=y. 
> > Which means you did not even build-test it on 32-bit, let alone boot 
> > test it...
> 
> Why are we rushing so much to do 64-bit paravirt that we are breaking 
> working configurations?  If the developement is going to be this 
> chaotic, it should be done and tested out of tree until it can 
> stabilize.

what you see is a open feedback cycle conducted on lkml. People send 
patches for arch/x86, and we tell them if it breaks something. The bug 
was found before i pushed out the x86.git devel tree (and the fix is 
below - but this shouldnt matter to you because the bug never hit a 
public x86.git tree).

	Ingo

Index: linux/include/asm-x86/paravirt.h
===================================================================
--- linux.orig/include/asm-x86/paravirt.h
+++ linux/include/asm-x86/paravirt.h
@@ -619,6 +619,7 @@ static inline void write_cr4(unsigned lo
 	PVOP_VCALL1(pv_cpu_ops.write_cr4, x);
 }
 
+#ifdef CONFIG_X86_64
 static inline unsigned long read_cr8(void)
 {
 	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr8);
@@ -628,6 +629,7 @@ static inline void write_cr8(unsigned lo
 {
 	PVOP_VCALL1(pv_cpu_ops.write_cr8, x);
 }
+#endif
 
 static inline void raw_safe_halt(void)
 {
