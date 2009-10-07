Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbZJGQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbZJGQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbZJGQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:29:23 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39755 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178AbZJGQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LZtekDg4ZzEdgkXKBa/dGpsbPUqGZOoVBDfxrE1f9y/s6dhnKrox+rnSfoCPXXfO9F
         A/bdwBmfvwmrB1nOTnm07YHx8LiTdWoRKOCHdSG++Twh13gZw2C6OifU9/4yIT4yGzsA
         4uyXByc0umbbTgNdXj8+LScIrD7WzjG8fDs4s=
Date: Wed, 7 Oct 2009 18:28:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091007162839.GA5903@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com> <20091005192609.GB6071@nowhere> <1254787973.13160.195.camel@gandalf.stny.rr.com> <4ACB52F6.7020106@redhat.com> <20091006224755.GC11007@nowhere> <4ACBEB4E.20803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACBEB4E.20803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:13:50PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Tue, Oct 06, 2009 at 10:23:50AM -0400, Masami Hiramatsu wrote:
> >> OK, so here are syntax ideas
> >>
> >> * current syntax
> >> <Ftrace>
> >> - $sp_var
> >> - %regs
> >> - @symbol
> >> <Perf>
> >> - local_var
> > 
> > 
> > This one looks good.
> > And why not turning @symbol into symbol?
> > Then it's up to perf probe to find the right
> > target.
> 
> Hmm, one big reason for separating local_vars
> and others is that I'd like to check whether
> perf-probe needs debuginfo or not.
> If there is no local_vars, we don't need to
> parse debuginfo. Sometimes, it is useful just
> for setting up probe points.
> 
> > And @ can be used for raw addresses?
> 
> Yeah, but @ can be shared with symbols and raw addresses.
> If the first char is digit, it's not a symbol.:-)
> 
> And also, @symbol actually has its syntax rule.:-)
> its real syntax is:
> @[MODULE:]SYMBOL[+OFFSET]
> or
> @ADDRESS (0xNN (base 16) or NN (base 10))
> 
> Perhaps, since perf-probe has another syntax rule,
> I don't want to confuse users. :-P
> 
> Thank you,
> 

Ok let's pick @ for symbols then.

Thanks.

