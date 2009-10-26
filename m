Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZJZQ5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZJZQ5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZJZQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:57:13 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48927 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZJZQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Yzn1WC/bjAmGZnQu/oeM6sA8sjhMglM6tfE3DsybPO1d4zne7QR+2OdKgmQ/1IFWCP
         soDAuCyPBZYrRi5cUXOvS/PWj8xI5ocropI4FJP4Qj0lT9HppLw1Dck5o8volQeeC17z
         EvetXueLF10oO+8OZhP6k7HvK8Dl7lc0KWBLI=
Subject: Re: [PATCH -v5 10/11] tracing: add function graph tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1256574775.26028.321.camel@gandalf.stny.rr.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
	 <ac9c325539cc056d9539c96a68743a425f9612ce.1256483735.git.wuzhangjin@gmail.com>
	 <1256570001.26028.298.camel@gandalf.stny.rr.com>
	 <1256573467.5642.214.camel@falcon>
	 <1256574775.26028.321.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 27 Oct 2009 00:57:05 +0800
Message-Id: <1256576225.5642.244.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...] 
> 
> Yeah, and probably not as important in the mips world, as it is used
> more with embedded devices than desktops. We must always take the
> "paranoid" approach for tracing. At least in PPC and x86, we assume
> everything is broken ;-)  And we want to be as robust as possible. If
> something goes wrong, we want to detect it ASAP and report it. And keep
> the system from crashing.
> 
> At least with MIPS we don't need to worry about crashing Linus's
> desktop. With is the #1 priority we have on x86 ... "Don't crash Linus's
> desktop!".
> 
> If Linus sees a warning, he'll bitch at us. If we crash his box, and he
> was to lose any information, he'll strip out our code!
> 

Okay, a new patch for all of the exception handling will go into -v7.

> 
> > 
> > So, we just need to replace this:
> > 
> > 		if ((code & MOV_FP_SP) == MOV_FP_SP)
> > 			return parent_addr;	
> > 	
> > by
> > 
> > #define S_INSN	(0xafb0 << 16)
> > 
> > 		if ((code & S_INSN) != S_INSN)
> > 			return parent_addr;
> 
> I would be even more paranoid, and make sure each of those stores, store
> into sp.

get it :-)

(I need to be more paranoid too, otherwise, Steven will not accept my
patches!)

> 
> > 
> > > 
> > > > +
> > > > +	sp = fp + (code & STACK_OFFSET_MASK);
> > > > +	ra = *(unsigned long *)sp;
> > > 
> > > Also might want to make the above into a asm with exception handling.
> > > 
> > > > +
> > > > +	if (ra == parent)
> > > > +		return sp;
> > > > +
> > > > +	ftrace_graph_stop();
> > > > +	WARN_ON(1);
> > > > +	return parent_addr;
> > > 
> > > Hmm, may need to do more than this. See below.
> > > 
[...]
> > > > +
> > > > +	old = *parent;
> > > > +
> > > > +	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
> > > > +							 (unsigned long)parent,
> > > > +							 fp);
> > > > +
> > > > +	*parent = return_hooker;
> > > 
> > > Although you may have turned off fgraph tracer in
> > > ftrace_get_parent_addr, nothing stops the below from messing with the
> > > stack. The return stack may get off sync and break later. If you fail
> > > the above, you should not be calling the push function below.
> > > 
> > 
> > We need to really stop before ftrace_push_return_trace to avoid messing
> > with the stack :-) but if we have stopped the tracer, is it important to
> > mess with the stack or not?
> 
> The ftrace_push_return_trace does not test if the trace stopped, that is
> expected to be done by the caller. If you mess with the stack set up,
> you will crash the box. Remember, before the failure, you could have
> already replaced return jumps. Those will still be falling back to the
> return_to_handler. If you mess with the stack, but don't update the
> return, the other returns will be out of sync and call the wrong return
> address.
> 

As you can see, after stopping the function graph tracer(here the function is non-leaf)
with ftrace_graph_stop() in ftrace_get_parent_addr(), I return the old parent_addr,
this is only the stack address in the stack space of ftrace_graph_caller, which means
that, I never touch the real stack address of the non-leaf function, and it will not trap
into the return_to_handler hooker 'Cause the non-leaf function will load it's own normal
return address from it's own stack, and then just return back normally.
	-- This is another trick :-)

Regards,
	Wu Zhangjin

