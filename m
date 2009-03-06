Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCFPf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCFPf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZCFPfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:35:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZCFPfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:35:16 -0500
Message-ID: <49B1428A.9050500@redhat.com>
Date: Fri, 06 Mar 2009 10:34:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip 0/4] Text edit lock and atomic text_poke()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of patches which introduce text_mutex for protecting
editing kernel text from each other subsystems, and make text_poke()
atomic by using fixmap.

BTW,

> Paravirt and alternatives are always done when SMP is inactive, so there is no
> need to use locks.

Mathieu, I'm not sure that means. alternatives will be called from module
init code and other place where the system has already been running multi-
-threads(and they use smp_alt mutex). So, is it possible that those functions
will sleep or yield to another process?

Anyway, I added a new patch which locks text_mutex in alternative_smp_*.

Thank you,

 arch/x86/include/asm/fixmap.h |    2 ++
 arch/x86/kernel/alternative.c |   29 ++++++++++++++++++++---------
 include/linux/memory.h        |    6 ++++++
 kernel/kprobes.c              |   15 +++++++++++++--
 mm/memory.c                   |    9 +++++++++
 5 files changed, 50 insertions(+), 11 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

