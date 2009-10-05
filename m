Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZJET0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZJET0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZJET0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:26:50 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:50309 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZJET0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PaywfcQKPvD6YoV7pSYWtDZq9bFFBEu5OaRLzBSLpujLX7453WmAALNpseA1CHllZk
         E25Z8G6bMvtz4m1XTBuQDJJPnt8RzGEgfyTJsNF3Ee5Zq9qig1zTRxW3pUOmGfv1cMWK
         +QQFBt4XBedqAD6UhVh2ykpTosVbw+3N7eqoc=
Date: Mon, 5 Oct 2009 21:26:11 +0200
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
Message-ID: <20091005192609.GB6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA25D5.10703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 12:59:01PM -0400, Masami Hiramatsu wrote:
> As far as I can see in arch/*/include/asm/ptrace.h, all registers start with
> alphabets :-). So, I'd like to suggest renaming sp-vars to '_sp-vars'.
>
> Then, we will have;
> - $local-vars


There is a risk of bash collision.


> - @global-symbol


We could use global-symbol as is. Shadowing between global
and local vars could be dealt with scope resolution:

function:var
file:var
file:line:var

And throw errors while submitting a shadowed var name, crying until
the user defines the scope, only if needed of course (if there are
no shadowing detected, we can submit a naked variable name).


> - regs


That can conflict with variable names


> - _sp-vars


That too.


> - +|-Offs(ARG)

You mean for arg numbers?
So we would have +1 for argument 1?

arg(1) looks more easy to remember and to understand, no?

Thanks.

