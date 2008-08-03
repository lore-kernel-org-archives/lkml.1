Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYHCPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYHCPQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYHCPQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:16:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:49002 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYHCPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lZoBr0s1bfDgX/+4OuL4c0pLg82XRmwBP2vXD8KmpEXmSjfdwwFA8sf1zJCPI5X76Y
         bhbORrSfAa4gk3x0zorcj7Gr2A1MnDWvtR8qSQeLFXB5k9f/cjFOr4YtYt19byyl+2tR
         QmI/d5/2KI/LdvjnvZ8FhiNnUnp+T9drQvZtw=
Message-ID: <863e9df20808030816w3ace806cwb577f81deb2633f3@mail.gmail.com>
Date: Sun, 3 Aug 2008 20:46:42 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Ming Lei" <tom.leiming@gmail.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 1:20 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Could you add the support of tracing functions in one module only to ftrace?

You can do that at compile time only by selective compilation of
files/modules which need to be traced with the -pg CFLAG. For
instance, the inlined patch enables tracing of all functions in
softirq.o only.

Regards,
Abhishek Sagar

--
## For testing only

diff --git a/Makefile b/Makefile
index 40f2481..09d216b 100644
--- a/Makefile
+++ b/Makefile
@@ -532,10 +532,6 @@ KBUILD_CFLAGS      += -g
 KBUILD_AFLAGS  += -gdwarf-2
 endif

-ifdef CONFIG_FTRACE
-KBUILD_CFLAGS  += -pg
-endif
-
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/kernel/Makefile b/kernel/Makefile
index 82f1f3f..c099be3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -14,14 +14,8 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 CFLAGS_REMOVE_sched.o = -mno-spe

 ifdef CONFIG_FTRACE
-# Do not trace debug files and internal ftrace files
-CFLAGS_REMOVE_lockdep.o = -pg
-CFLAGS_REMOVE_lockdep_proc.o = -pg
-CFLAGS_REMOVE_mutex-debug.o = -pg
-CFLAGS_REMOVE_rtmutex-debug.o = -pg
-CFLAGS_REMOVE_cgroup-debug.o = -pg
-CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
+CFLAGS_softirq.o = -pg
+CFLAGS_REMOVE_sched.o = -mno-spe
 endif

 obj-$(CONFIG_PROFILING) += profile.o
