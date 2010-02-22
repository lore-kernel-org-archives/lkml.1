Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0BVB1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:27:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54073 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0BVB1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:27:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lu8Ztj2F9Jof1vwirf9Cto83XHEZwylISG5UIX27VTuL6R1TjEojNfEpAEeptOe1o/
         dYBmYvxF7JO+MrpZTUGwczWDa7ELyF2m2RdRMFJp6jeLihO+KkN+rWxJR5Yw+bi0Ljp9
         mWfav8kNeFczi0M3o8T1m/AatUd+WeX88jdug=
Date: Mon, 22 Feb 2010 02:27:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100222012735.GA8791@nowhere>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> <1266491616-6270-3-git-send-regression-fweisbec@gmail.com> <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> <20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> <20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com> <20100218145055.GB855@nowhere> <4B7D68AA.8060105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7D68AA.8060105@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 11:19:54AM -0500, Masami Hiramatsu wrote:
> > For now it is stored is asm/ptrace.h, but that might be split in
> > the future, especially as ptrace has initially nothing related to
> > that. A documentation that deals with filenames or API enumerations
> > tend to be incidentally async with API evolutions.
> 
> yeah, now those APIs depend on pt_regs, so I put it in ptrace.h.
> 
> Thank you,


Are you guys fine with the following patch or should I bring
more details somewhere?

Thanks.

---
commit d3643132cfeac24ee20d2b6cd8cb06d73e6a6da9
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Thu Feb 18 14:25:21 2010 +0100

    tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API
    
    So that arch developers know how to implement it without the
    need to dig into changelogs.
    
    Reported-by: Mike Frysinger <vapier.adi@gmail.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: Masami Hiramatsu <mhiramat@redhat.com>
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: "David S . Miller" <davem@davemloft.net>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    LKML-Reference: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
    [added reference to ptrace.h in the config help]
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/arch/Kconfig b/arch/Kconfig
index 04e3aa7..50877ef 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -123,6 +123,11 @@ config USE_GENERIC_SMP_HELPERS
 
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
+	help
+	  This symbol should be selected by an architecure if it supports
+	  the API needed to access registers and stack entries from pt_regs,
+	  declared in asm/ptrace.h
+	  For example the kprobes-based event tracer needs this API.
 
 config HAVE_CLK
 	bool


