Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZK0EPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZK0EPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZK0EPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:15:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49922 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZK0EPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OuHKoIXuXQkKA8gti8WX1wLj1goYWnWCVm8qt/SsuH73F28wM8XfcPGsPbrRfmjmgg
         lWkmPfrRW3+ipwgGb/ZQ3CEN13SNOc2PwMARt4PBU+XS8mJ34DTnE/DgWrQUlN/kxBh9
         lG22BZB7hyyRf+PxnoItIX/JHGzSMsllDsNNQ=
Date: Fri, 27 Nov 2009 05:15:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace_syscalls: add missed field
Message-ID: <20091127041540.GA5221@nowhere>
References: <4B0E330D.1070206@cn.fujitsu.com> <20091126223153.GA7177@nowhere> <4B0F4F63.6040307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0F4F63.6040307@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 12:02:43PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Thu, Nov 26, 2009 at 03:49:33PM +0800, Lai Jiangshan wrote:
> >> Field syscall number is missed in syscall_enter_define_fields()/
> >> syscall_exit_define_fields().
> >>
> >> syscall number is also needed for event filter or other users.
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > 
> 
> 
> For all kinds of tracer, all fields are "defined"
> by trace_define_field(), except this one.
> Maybe because I don't like inconsistent codes.


:)


> > 
> > Well, I don't think it's very useful for in-kernel filtering.
> > Filtering a syscall event by its number would mean filtering all
> > event for this syscall. This is the same as not tracing it.
> > 
> > Or do you have other usecases in mind?
> > 
> 
> Current, only filter use struct ftrace_event_call->fields,
> so there is no other usecases ^_^.
> But my next take of "tracing: use defined fields to print formats"
> will use it.


Oh really you are planning such patch? That looks hard to do
considering the tricky things that happen in fields printing
sometimes. Also printing the fields is often a human
interpretation on how to handle them, so... Anyway, I'll just
wait for your patches and see.

That said I really have no opposition against this patch.
For consistency over what is done with every other trace event
fields, and to anticipate any further uses of trace event fields
definition other than filtering:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

(Steve, Ingo, should I queue it or...what do you prefer?)

