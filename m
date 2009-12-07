Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbZLGUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbZLGUVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934440AbZLGUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:21:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43537 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbZLGUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iycY+fcc6ZdLHDVJrOwHpa1n6O3a99WRXQgvdcxGJJvygJ0/+Pke89EqH3QV1PZHCJ
         RioS51HKzKWV0QXWvlah8UaUpHY7GkUffNl/AYlCP6ABPMtvskAdXuwZAtdaRVJIJOgi
         8CJ3o7n6BB15wS/QG1amH8MAw+8mGmMuIjZFo=
Date: Mon, 7 Dec 2009 21:21:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
	failed entries
Message-ID: <20091207202146.GE5049@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com> <1259082845.22249.1110.camel@gandalf.stny.rr.com> <20091124211423.GE5071@nowhere> <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com> <20091204104616.GC1931@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204104616.GC1931@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:46:16AM +0100, Jiri Olsa wrote:
> > sure, but it is not the trace_seq structure that overflows, it is the bare 
> > seq_file underneath. The s_show calls "trace_print_seq":
> > 
> > void trace_print_seq(struct seq_file *m, struct trace_seq *s)
> > {               
> >         int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
> >         
> >         seq_write(m, s->buffer, len);
> > 
> >         trace_seq_init(s);
> > }               
> > 
> > it flushes the trace_seq to the seq_file and reinits the trace_seq.
> > But the seq_file will get filled in the end, ending up with
> > not displayed output in that case I described in the first email.
> > 
> 
> hi, any feedback on this?
> 
> thanks,
> jirka


Steven has done some tests and it looks like you were right, the
problem comes from the seq_file, not the trace_seq.

Steve, any news about it?

Thanks.

