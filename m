Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZKRSJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZKRSJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147AbZKRSJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:09:03 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:49827 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbZKRSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Oi2yWxSe1yiCk5lcPe6InJTHbjdAY5so8OuXPwfkANWhERkUplvZmDxp4igKSgFymP
         Hw6hV4yw89UqNTC6awvtqu4f0ejIqj5DBFbtUS9vyoo8HF+3B4RviePq0u/YB0aJMhB8
         flB/Ey3kP34zO9g7XT0HRup8zuy3RwFlwm5NE=
Date: Wed, 18 Nov 2009 19:08:59 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Mike Travis <travis@sgi.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
Message-ID: <20091118180859.GA2683@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Mike Travis <travis@sgi.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Roland Dreier <rdreier@cisco.com>,
	Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Rientjes <rientjes@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Jack Steiner <steiner@sgi.com>,
	Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
 <20091117191757.651569000@alcatraz.americas.sgi.com>
 <20091118104855.GA593@aftab>
 <4B042C51.7000500@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B042C51.7000500@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 09:18:09AM -0800, Mike Travis wrote:
> There are other patches that deal with these:
> 
> http://git.kernel.org/tip/15cd8812ab2ce62a2f779e93a8398bdad752291a
> http://git.kernel.org/tip/b01c845f0f2e3f9e54e6a78d5d56895f5b95e818

yep, it looks better now, thanks:

CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
...
Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 Ok.
Booting Node   3, Processors  #12 #13 #14 #15 #16 #17 Ok.
Booting Node   2, Processors  #18 #19 #20 #21 #22 #23 Ok.
Brought up 24 CPUs
Total of 24 processors activated (81398.64 BogoMIPS).

> >and clearly CPU cache info is too verbose. We might want to
> >kill it since we have it replicated in /sysfs. In that case,
> >arch/x86/kernel/cpu/common.c:display_cacheinfo() could become obsolete
> >and we could remove it... Or is there some reason for dumping that
> >particular information during boot?
> >
> 
> Yes, the above patches remove them entirely.

In that case, maybe a small fixlet like the following is in order:

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 18 Nov 2009 19:01:28 +0100
Subject: [PATCH] x86, cpu: mv display_cacheinfo -> cpu_detect_cache_sizes

display_cacheinfo() doesn't display anything anymore and it is solely
used to detect CPU cache sizes for /proc/cpuinfo. Rename it accordingly.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/kernel/cpu/amd.c       |    2 +-
 arch/x86/kernel/cpu/centaur.c   |    2 +-
 arch/x86/kernel/cpu/common.c    |    4 ++--
 arch/x86/kernel/cpu/cpu.h       |    2 +-
 arch/x86/kernel/cpu/cyrix.c     |    2 +-
 arch/x86/kernel/cpu/transmeta.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..7128b37 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -535,7 +535,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008) {
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..e58d978 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -294,7 +294,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 61242a5..9bf845d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,7 +61,7 @@ void __init setup_cpu_local_masks(void)
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 #else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
@@ -383,7 +383,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6de9a90..3624e8a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -32,6 +32,6 @@ struct cpu_dev {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
-extern void display_cacheinfo(struct cpuinfo_x86 *c);
+extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 19807b8..4fbd384 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -373,7 +373,7 @@ static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
 	/* Handle the GX (Formally known as the GX2) */
 
 	if (c->x86 == 5 && c->x86_model == 5)
-		display_cacheinfo(c);
+		cpu_detect_cache_sizes(c);
 	else
 		init_cyrix(c);
 }
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index bb62b3e..2800074 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -26,7 +26,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 
 	early_init_transmeta(c);
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
-- 
1.6.5



-- 
Regards/Gruss,
    Boris.
