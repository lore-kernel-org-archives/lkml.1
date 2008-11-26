Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYKZQsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYKZQsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYKZQsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:48:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYKZQsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:48:45 -0500
Date: Wed, 26 Nov 2008 11:48:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: add thread comm to function graph tracer
In-Reply-To: <20081125213748.2cd86b2b.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811261147250.26743@gandalf.stny.rr.com>
References: <20081126051622.134970943@goodmis.org> <20081126051710.149585354@goodmis.org> <20081125213748.2cd86b2b.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Nov 2008, Andrew Morton wrote:

> On Wed, 26 Nov 2008 00:16:26 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Impact: enhancement to function graph tracer
> > 
> > Export the trace_find_cmdline so the function graph tracer can
> > use it to print the comms of the threads.
> > 
> > -static char *trace_find_cmdline(int pid)
> > +char *trace_find_cmdline(int pid)
> >
> > ...
> >
> >  static int verif_pid(struct trace_seq *s, pid_t pid)
> >  {
> > +	char *comm;
> > +
> >  	if (last_pid != -1 && last_pid == pid)
> >  		return 1;
> >  
> >  	last_pid = pid;
> > -	return trace_seq_printf(s, "\n------------8<---------- thread %d"
> > +	comm = trace_find_cmdline(pid);
> > +
> > +	return trace_seq_printf(s, "\n------------8<---------- thread %s-%d"
> >  				    " ------------8<----------\n\n",
> > -				  pid);
> > +				    comm, pid);
> >  }
> 
> This code gets its int's and pid_t's all mixed up.  It's a bit cosmetic, but
> nice to get it right for readability's sake.

Hmm, I think I would like to keep all pids as ints. Perhaps because we do 
not have namespaces here ;-)

I'm totally confused by what to do. I'll have to think about it.

-- Steve

