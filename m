Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721Ab0B0TZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:25:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030653Ab0B0TZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:25:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=TaH4jK7ghYAA:10 a=7U3hwN5JcxgA:10 a=QTD71AIYG_kEDMf8JrcA:9 a=mHvY2_mEoVv-h3KehN0P2ix4SvoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
 function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20100227100223.GB5130@nowhere>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com>
	 <20100227100223.GB5130@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 27 Feb 2010 14:25:03 -0500
Message-ID: <1267298703.6328.181.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 11:02 +0100, Frederic Weisbecker wrote:

> >  		/*
> >  		 * Comments display at + 1 to depth. Since
> >  		 * this is a leaf function, keep the comments
> >  		 * equal to this depth.
> >  		 */
> > -		*depth = call->depth - 1;
> > +		cpu_data->depth = call->depth - 1;
> > +
> > +		/* No need to keep this function around for this depth */
> > +		if (call->depth < FTRACE_RETFUNC_DEPTH)
> 
> 
> 
> Do you really need to check that? call->depth >= FTRACE_RETFUNC_DEPTH
> are not recorded.
> 
> 

Call me paranoid, but working inside the kernel makes me paranoid. If
for some reason a trace gets corrupted here, not doing this check can
cause a kernel oops.

> 
> > +			cpu_data->enter_funcs[call->depth] = 0;

cpu_data->enter_funcs[102340320211] = 0;

would be bad ;-)


Hmm, I should also make sure depth is not less than zero. I'll send a
new patch to do that too.

-- Steve

> >  	}
> >  

