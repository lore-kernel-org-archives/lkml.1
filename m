Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZBNPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZBNPUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZBNPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:20:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZBNPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:20:42 -0500
Date: Sat, 14 Feb 2009 10:20:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Michael Ellerman <michael@ellerman.id.au>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] powerpc, ftrace: use create_branch lib function
In-Reply-To: <1234619366.10265.3.camel@localhost>
Message-ID: <alpine.DEB.1.10.0902141019200.27713@gandalf.stny.rr.com>
References: <20090213150055.947823726@goodmis.org>  <20090213150147.180922180@goodmis.org> <1234619366.10265.3.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Feb 2009, Michael Ellerman wrote:
> >  
> >  	/* if (link) set op to 'bl' else 'b' */
> > -	op = 0x48000000 | (link ? 1 : 0);
> > -	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> > +	op = create_branch((unsigned int *)ip, addr, link ? 1 : 0);
> 
> If I was feeling nit-picky I'd say you should use:
> 
> op = create_branch((unsigned int *)ip, addr, link ? BRANCH_SET_LINK : 0);
> 
> 
> But admittedly we're unlikely to ever change the flag handling, so it's
> probably not worth the effort of a respin (or this email :).

Not worth the effort of a respin, I agree.

But it would be worth the effort of a clean up patch ;-)

Not for "oh this flag might change", but for reviewers looking at the
code and knowing exactly what that '1' means.

-- Steve

