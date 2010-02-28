Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0B1SQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:16:35 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38708 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0B1SQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S8usmr9EyEHCa+4ezMz3Mr6Jqb6PHwB5YZDxqubHPlFHmXkR2Tw4nABDs1Z9Yly8u6
         A45qjnyH3GVtYEKkBn23L7761KXxAsInT9f+/TDJGM/tToB3SajpGCIGXq0ClSyxV6TV
         bGB8oU1tc4C0AlEnaeLphOLTQXnfr3TUr9UUM=
Date: Sun, 28 Feb 2010 19:16:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
	function graph tracer
Message-ID: <20100228181622.GB5248@nowhere>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com> <20100227100223.GB5130@nowhere> <1267298703.6328.181.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267298703.6328.181.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 02:25:03PM -0500, Steven Rostedt wrote:
> On Sat, 2010-02-27 at 11:02 +0100, Frederic Weisbecker wrote:
> 
> > >  		/*
> > >  		 * Comments display at + 1 to depth. Since
> > >  		 * this is a leaf function, keep the comments
> > >  		 * equal to this depth.
> > >  		 */
> > > -		*depth = call->depth - 1;
> > > +		cpu_data->depth = call->depth - 1;
> > > +
> > > +		/* No need to keep this function around for this depth */
> > > +		if (call->depth < FTRACE_RETFUNC_DEPTH)
> > 
> > 
> > 
> > Do you really need to check that? call->depth >= FTRACE_RETFUNC_DEPTH
> > are not recorded.
> > 
> > 
> 
> Call me paranoid, but working inside the kernel makes me paranoid. If
> for some reason a trace gets corrupted here, not doing this check can
> cause a kernel oops.


Ok but this may also hide a bug.

Could it be a WARN_ON_ONCE?


 
> > 
> > > +			cpu_data->enter_funcs[call->depth] = 0;
> 
> cpu_data->enter_funcs[102340320211] = 0;
> 
> would be bad ;-)
> 
> 
> Hmm, I should also make sure depth is not less than zero. I'll send a
> new patch to do that too.



With a WARN_ON_ONCE? :)


Thanks.

