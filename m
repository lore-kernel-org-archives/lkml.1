Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYBYSYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYBYSYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYBYSYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:24:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYBYSYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:24:09 -0500
Message-ID: <47C3078E.3000008@redhat.com>
Date: Mon, 25 Feb 2008 13:23:10 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <30804.1203962369@turing-police.cc.vt.edu>
In-Reply-To: <30804.1203962369@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Alan to CC ]

Valdis.Kletnieks@vt.edu wrote:
> The symbol 'mcount' has EXPORT_SYMBOL_GPL attached to it.  This is because
> "things that use this symbol are too chummy with kernel internals to not be
> derivative".  However, the symbol may or may not actually be referenced by a
> given module, depending on the setting of CONFIG_FTRACE.  This leads to an
> interesting result:  The module may or may not be too chummy depending on a
> variable outside its control, and the module source code doesn't have any say
> in the matter.  So we have a .c file that *is* a derivative work if the kernel
> is built one way, and is *not* if the kernel is built another.  Worse yet,
> it *also* depends at runtime on the setting of /proc/sys/kernel/ftrace_enabled
> 
> But it's the SAME EXACT SOURCE.  And since the source file isn't called
> schrodinger.c, I believe the following patch is in order..
> 
> (As an aside, arch/um/kernel/gprof_syms.c already lists mcount as a
> SYMBOL, not a SYMBOL_GPL - yet another inconsistency.
> 

The reason I added GPL is not because of some idea that this is all 
"chummy" with the kernel. But because I derived the mcount code from 
glibc's version of mcount. Now you may argue that glibc is under LGPL 
and a non-GPL export is fine. But I've been advised that if I ever take 
code from someone else, to always export it with GPL.

-- Steve

