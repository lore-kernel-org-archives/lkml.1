Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZIJSxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZIJSxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZIJSxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:53:09 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53163 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZIJSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y3D7VfSP42AR21vnnDrQcdGtW8EzFdt/SXOGW/QIyzT7fXJtCOVtiLcL05rANJQQRc
         Jv9IBmJzO12LWH2S/jmFcNRsc4b9TSC74IF5Pw7XO9bqc8DKE0HRhts+vWzWGMpimcR8
         qy5rCR5n1BBFLtjaMuApwGA9EF4xx2UQTwv/I=
Date: Thu, 10 Sep 2009 20:53:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090910185304.GD6421@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <20090910142540.GA3512@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910142540.GA3512@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:55:40PM +0530, K.Prasad wrote:
> On Thu, Sep 10, 2009 at 10:29:25AM +0200, Frederic Weisbecker wrote:
> > This patch rebase the implementation of the breakpoints API on top of
> > perf counters instances.
> > 
> > The core breakpoint API has changed a bit:
> > 
> > - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
> >   now it doesn't support all cpu wide breakpoints but this may be
> >   implemented soon.
> 
> Is there a reason why perf doesn't support counters effective on all
> CPUs (and all processes)?
> Atleast, it is vital for debugging aspects of hw-breakpoints...say to
> answer "Who all did a 'write' on the kernel variable that turned corrupt", etc.
> 
> The implementation to iteratively register a breakpoint on all CPUs would
> (as in trace_ksym.c) result in unclean semantics for the end user, when, a
> register_kernel_<> request fails on a given CPU and all previously
> registered breakpoints have to be reverted (but the user might have
> received a few breakpoint triggers by then as a result of the successful
> ones...i.e. register request fails, but still received 'some' output).


(Please shrink the end of the message if you don't answer in further parts.
I'm especially a bad example of what not to do :-)

Yeah it would be very convenient to have that. Is it possible considering
the current internal design of perf?

