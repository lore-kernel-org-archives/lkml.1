Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZJGEAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZJGEAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZJGEAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:00:01 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:42577 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZJGEAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iaVscIdEMY2hDKCcT+pLaIlsFrlaFEJU9+KT/p9ORYiDddOnmopexa9pF3+acAp8mY
         wO9z9Mcm6aANk6MchSsYzZl1pPbj9mQJjxm1p4s1zhEmx/dtjhLYrBcRZWaYe+nIsJAg
         bt+ZTaBdpnwxZGBh0TNyvccDf7Euo3dv3mYn4=
Subject: Re: [PATCH 3/3] tracing/syscalls: Use long for syscall ret format
 and  field definitions
From: Tom Zanussi <tzanussi@gmail.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
In-Reply-To: <c62985530910060015t74d8c116i8593839e6d8a3af5@mail.gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
	 <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
	 <c62985530910060015t74d8c116i8593839e6d8a3af5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Oct 2009 22:59:22 -0500
Message-Id: <1254887962.28917.101.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 09:15 +0200, Frédéric Weisbecker wrote:
> 2009/10/6, Tom Zanussi <tzanussi@gmail.com>:
> > The syscall event definitions use long for the syscall exit ret value,
> > but unsigned long for the same thing in the format and field
> > definitions.  Change them all to long.
> 
> 
> Thanks.
> 
> We may perhaps also want to change struct syscall_trace_exit
> according to that?
> That won't change the code behaviour, just the logic while
> reviewing.
> 
> It's just a neat, this patch itself is fine.
> 

Yeah, that should have been part of it too.  I'll submit another patch
later doing that.

Tom

> 
> >
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > ---
> >  kernel/trace/trace_syscalls.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > index 9fbce6c..527e17e 100644
> > --- a/kernel/trace/trace_syscalls.c
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -166,7 +166,7 @@ int syscall_exit_format(struct ftrace_event_call *call,
> > struct trace_seq *s)
> >  			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
> >  			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
> >  			       SYSCALL_FIELD(int, nr),
> > -			       SYSCALL_FIELD(unsigned long, ret));
> > +			       SYSCALL_FIELD(long, ret));
> >  	if (!ret)
> >  		return 0;
> >
> > @@ -212,7 +212,7 @@ int syscall_exit_define_fields(struct ftrace_event_call
> > *call)
> >  	if (ret)
> >  		return ret;
> >
> > -	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
> > +	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
> >  				 FILTER_OTHER);
> >
> >  	return ret;
> > --
> > 1.6.4.GIT
> >
> >

