Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZJEV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZJEV5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJEV47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:56:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:40409 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZJEV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HM8N7uon0+GI0697oazNJHxqNWvP1dCldzND43rHTbWe8fGRGkjZg6yXGmWEHHi2ae
         jHn502LCfjeidnqsX73pw8B3RfhcMV52duz2kvzB8zjys7IYkNRiNDTPERPhVWNP37LO
         SaixuP9F0kGxQ0vsjOvtx2pkr7vSCxFx7W1y8=
Date: Mon, 5 Oct 2009 23:55:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20091005215548.GH6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere> <4ACA60E9.30404@redhat.com> <20091005212137.GG6071@nowhere> <4ACA6660.7020607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA6660.7020607@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 05:34:24PM -0400, Masami Hiramatsu wrote:
> Hmm, one idea hits me, how about this? :)
> - %register
> - %%spvars (%%retval, %%arg0)


The problem is that such % or %% symbols have a specific
mean in some other well known areas.

If we borrow the % from the AT&T assembly syntax style
to use register names, that we can retrieve in gcc inline
assembly, then one may expect %% to have a meaning inspired
from the same area. %% has its sense in gcc inline assembly,
but applied there, it looks confusing.

I mean, I'm trying to think like someone reading a perf probe
command line without any documentation. The more this person
can understand this command line without documentation, the better.
We know that % is used for register names, some people know that %%
is used for register names too but when we are in gcc inline assembly
with var to reg resolution and need true registers name.
Then if I try to mirror this sense from gcc to perf probe use,
I feel confused, especially in the case of %%arg1.

In this case, we should rather have %%register and %arg0 :)

Hm, %register is a clear pattern.

Somehow, %retval looks clear too, retval is verbose enough and
% is still logical as return values are most of the time (always?)
put in a register.

But %%arg0 looks confusing.


