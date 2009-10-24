Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZJXOTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZJXOTE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 10:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZJXOTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 10:19:03 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35583 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZJXOTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 10:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O9+56XiOqhqxfscWh6a/YXnFxJtZdhmnRYCrYn0TQ30vtAtq0D5FkGEIFj25fd+eMA
         R91LiJ3JUN4jV1LFMRAEpcB6jvG8k19wprDl4gYQRbGbQVE9P7JcmXXzQNykrFbP8TkB
         eOFDWKYWTTAV8GRvU/tXnOvHopXtZj+ioBkUg=
Date: Sat, 24 Oct 2009 16:19:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
Message-ID: <20091024141900.GA5055@nowhere>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 04:16:52PM +0200, Frederic Weisbecker wrote:
> Hi all,
> 
> This is the v2 of the hw-breakpoints API rewrite on top of perf events.
> You can find the previous version here:
> http://lwn.net/Articles/351922/
> 
> Changes in v2:
>     
>     - Follow the perf "event " rename
>     - The ptrace regression have been fixed (ptrace breakpoint perf events
>       weren't released when a task ended)
>     - Drop the struct hw_breakpoint and store generic fields in
>       perf_event_attr.
>     - Separate core and arch specific headers, drop
>       asm-generic/hw_breakpoint.h and create linux/hw_breakpoint.h
>     - Use new generic len/type for breakpoint
>     - Handle off case: when breakpoints api is not supported by an arch
>     - Use proper in-kernel perf api provided by Arjan.
> 
> There are still a lot of things that need to be cleaned, simplified,
> improved (ptrace side, the bp api, etc....) I guess these things can
> be done incrementally if you agree.
> 
> I've also tried to get an arch-independent api. Generic fields for
> breakpoints are stored in perf_event_attr structure (type, len, addr).
> This needs to be discussed and improved before it becomes a perf
> userspace ABI. We need to find a generic enough structure to host
> the breakpoints parameters, something that can better fit to most arch
> (handling breakpoint ranges in powerpc, etc...).
> 
> Thanks.
> 
> ---
> 
> The following patchset are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perfevents/hw-breakpoint


BTW, this is a branch based on tip:tracing/hw_breakpoint with tip:perf/core
merged inside.

