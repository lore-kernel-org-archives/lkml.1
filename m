Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZBTRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZBTRy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZBTRyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:54:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZBTRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:54:12 -0500
Date: Fri, 20 Feb 2009 12:54:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: break out modify loop immediately on detection
 of error
In-Reply-To: <20090220173334.GJ24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201252400.13747@gandalf.stny.rr.com>
References: <20090220163846.709775139@goodmis.org> <20090220164046.287797665@goodmis.org> <20090220173334.GJ24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -561,11 +561,15 @@ static void ftrace_replace_code(int enable)
> >  				if ((system_state == SYSTEM_BOOTING) ||
> >  				    !core_kernel_text(rec->ip)) {
> >  					ftrace_free_rec(rec);
> > -				} else
> > +				} else {
> >  					ftrace_bug(failed, rec->ip);
> > +					goto out;
> > +				}
> >  			}
> >  		}
> >  	}
> > + out:
> > +	return;
> 
> wouldnt a simple 'break' suffice? Hm, nope, 
> do_for_each_ftrace_rec() is a double loop.
> 
> Then perhaps a 'return' would perhaps be cleaner in this case. 
> (even though it does make the flow a bit assymetric - the out 
> label and the empty return looks a bit ugly.)

I guess a return would work too. I did the out jump to annotate the escape 
a bit more. Both are ugly IMHO. I'll switch it to return in the else 
statement.

-- Steve

