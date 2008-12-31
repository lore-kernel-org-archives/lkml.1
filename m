Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYLaJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYLaJrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYLaJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:47:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYLaJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:47:11 -0500
Subject: Re: [PATCH -tip] fix compilation error
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081231084420.GA13665@elte.hu>
References: <1230648007.10677.1.camel@jaswinder.satnam>
	 <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org>
	 <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere>
	 <495AC45D.8010102@kernel.org> <20081231014747.GB28472@nowhere>
	 <20081231081458.GB12942@elte.hu>
	 <3f9a31f40812310040y27c39b87v456ae38e46031624@mail.gmail.com>
	 <20081231084420.GA13665@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 15:15:02 +0530
Message-Id: <1230716702.24316.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 09:44 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> 
> > Hello Ingo,
> > 
> > On Wed, Dec 31, 2008 at 1:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > Could you check whether latest tip/master is still OK? I had these
> > > problems resolved locally (but forgot to push them out), and now i also
> > > had to do a few conflict resolutions with latest -git, hopefully i have
> > > not lost hpa's fixes ...
> > >
> > 
> > With latest/tip, I am still getting error on X86_32 machines :
> > 
> >   CC      mm/slab.o
> > mm/slab.c:105:31: error: tracing/kmemtrace.h: No such file or directory
> > make[1]: *** [mm/slab.o] Error 1
> > make: *** [mm] Error 2
> 
> ok, pushed out a new one - does it build fine now?
> 

Yes, Now it looks better, thanks :-)

I think it will be better to move trace/XXX below to linux/XXX to aviod
confusion and some minor cleanup in trace folder, do you thinks this is
useful :


---
 include/trace/boot.h      |    6 +++---
 include/trace/kmemtrace.h |    6 +++---
 mm/slab.c                 |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/trace/boot.h b/include/trace/boot.h
index 088ea08..21dcce3 100644
--- a/include/trace/boot.h
+++ b/include/trace/boot.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_TRACE_BOOT_H
-#define _LINUX_TRACE_BOOT_H
+#ifndef _TRACE_BOOT_H
+#define _TRACE_BOOT_H
 
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -57,4 +57,4 @@ static inline void enable_boot_trace(void) { }
 static inline void disable_boot_trace(void) { }
 #endif /* CONFIG_BOOT_TRACER */
 
-#endif /* __LINUX_TRACE_BOOT_H */
+#endif /* _TRACE_BOOT_H */
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index ad8b785..4ea5300 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -4,8 +4,8 @@
  * This file is released under GPL version 2.
  */
 
-#ifndef _LINUX_KMEMTRACE_H
-#define _LINUX_KMEMTRACE_H
+#ifndef _TRACE_KMEMTRACE_H
+#define _TRACE_KMEMTRACE_H
 
 #ifdef __KERNEL__
 
@@ -71,5 +71,5 @@ static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
 
 #endif /* __KERNEL__ */
 
-#endif /* _LINUX_KMEMTRACE_H */
+#endif /* _TRACE_KMEMTRACE_H */
 
diff --git a/mm/slab.c b/mm/slab.c
index ae76de2..0913e88 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -102,7 +102,6 @@
 #include	<linux/cpu.h>
 #include	<linux/sysctl.h>
 #include	<linux/module.h>
-#include	<trace/kmemtrace.h>
 #include	<linux/rcupdate.h>
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
@@ -114,6 +113,7 @@
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
 #include	<linux/kmemcheck.h>
+#include	<trace/kmemtrace.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
-- 
1.5.5.1



