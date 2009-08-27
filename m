Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZH0PZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZH0PZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZH0PZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:25:43 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59503 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZH0PZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QaeUzxaCPJBwBhVsJgeubMAjRhJ1uoCV+Fx7pjF0vJAKddRFEtSZJZSo6Pyo5Wewqb
         tblE5VcAEEXH9FiG5H/qO+tJ0HQ8Nz1ElVA18nxW0qF24AdvnvYMX4KK6vBH0PTu7FTS
         cKO9Q9dj+fSTkNsRKkHAzcfu103wL/K1wfrlA=
Date: Thu, 27 Aug 2009 17:25:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing/kprobes: Add dynamic tracepoints +
	instruction decoder
Message-ID: <20090827152539.GE6058@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <4A969F96.2020107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A969F96.2020107@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:00:38AM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > Ingo,
> > 
> > This is the kprobes tracing pile of patches. I've tested it
> > successfully by setting some kprobes through debugfs by hand.
> > 
> > It brings no known regressions.
> > 
> > However, the stress test provided by Masami have revealed some
> > unstable points. Some symbols are unsafe to probe and raise
> > probing recursion.
> > 
> > I've added a tiny patch in the series that helps identifying the
> > kprobe that has raised such situation.
> > For example it has learned me today that it's unsafe to trace
> > ret_from_exception() (obviously: it's on the int 3 handler path).
> 
> Thank you, Frederic.
> 
> I'm currently fixing those problems on x86-64 (on kvm).
> I'll also check it on x86-32, and fix it.
> 
> Thanks



Cool.
Don't hesitate to interate through small patches that fix these
sites.

So that I can continue to test it over time and report you what I find,
may be I can try to fix some of them too.

I haven't fixed ret_from_exception because I wasn't sure about the
right thing to do: putting it in the kprobes section or blacklist its
name. It's a bit more delicate to put assembly code into sections so... :)

