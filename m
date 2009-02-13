Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZBMFXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZBMFXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZBMFWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:22:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZBMFWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:22:53 -0500
Date: Fri, 13 Feb 2009 00:22:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/7][RFC] powerpc64, tracing: add function graph tracer
 with dynamic tracing
In-Reply-To: <1234498509.26036.35.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0902130020420.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org>  <20090212011343.074329920@goodmis.org> <1234498509.26036.35.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Feb 2009, Benjamin Herrenschmidt wrote:

> 
> > @@ -55,8 +56,9 @@ static unsigned char *ftrace_call_replace(unsigned
> > long ip, unsigned long addr)
> >  	 */
> >  	addr = GET_ADDR(addr);
> >  
> > -	/* Set to "bl addr" */
> > -	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> > +	/* if (link) set op to 'bl' else 'b' */
> > +	op = 0x48000000 | (link ? 1 : 0);
> > +	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> 
> Any reason why you aren't using the code in
> arch/powerpc/lib/code-patching.c here ?

Yes, because I did not know about it ;-)

I'll write up a patch to change this. But I'll post this series as is for 
now.

Thanks,

-- Steve

