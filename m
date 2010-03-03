Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0CCUHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:07:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50705 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0CCUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:07:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fofHSaP/r17R0a8IFltfOeQALq7CBuKERIpYeOUy45IHk1D8y5D5XfoWGL+mcyKyj/
         qx9vWfnWol13TmtLWOlMcd2vWRCT6JDV/5dCpilPHKci4UGW73v3fuBW28e1IT4jyKh/
         p/UdY5ziNFY411td8zc1UQmIZ90bEI5M5gdiQ=
Date: Wed, 3 Mar 2010 21:07:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
	events
Message-ID: <20100303200727.GA5194@nowhere>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-3-git-send-regression-fweisbec@gmail.com> <1267605529.25158.75.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267605529.25158.75.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 09:38:49AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-03-03 at 07:55 +0100, Frederic Weisbecker wrote:
> >  /*
> > + * Hot regs snapshot support -- arch specific
> > + * This needs to be a macro because we want the current
> > + * frame pointer.
> > + */
> > +#ifndef PERF_SAVE_REGS
> > +#define PERF_SAVE_REGS(regs)   memset(regs, 0, sizeof(*regs));
> > +#endif
> 
> It would be nice to have the fallback at least set the current or
> calling IP, now you've basically wrecked stuff for everything !x86.


Oh I haven't wrecked that much !x86, no callchain was working on
trace events before, nor the ip was correct :-)

That said I agree with you, I'm going to reuse the CALLER_ADDRx
macros for that. This is the occasion to add a skip field
in PERF_SAVE_REGS to rewind where we want.

Thanks.

