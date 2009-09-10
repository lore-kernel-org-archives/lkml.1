Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZIJSxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZIJSxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZIJSxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:53:42 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45774 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZIJSxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E7h2jcAgMtBEA5o0/97pxEWaDfC71EuNYmsgqXsHiMtwUuanQgMrdZb1Bch1mU59CG
         G5eJ6Fk/kIHQxQXy0M3GpRP5GJdh1hcKOOtcgxsa+X7c7FRZNtvJY1LrwiCc68vKvHjB
         cK5aoDxbARgQC8uDa48ElzSKac41vUBK9YvPg=
Date: Thu, 10 Sep 2009 20:53:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 4/5] hw-breakpoints: Arbitrate access to pmu following
	registers constraints
Message-ID: <20090910185336.GE6421@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-5-git-send-email-fweisbec@gmail.com> <1252593698.30578.176.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252593698.30578.176.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:41:38AM -0700, Daniel Walker wrote:
> On Thu, 2009-09-10 at 10:29 +0200, Frederic Weisbecker wrote:
> 
> > +static unsigned int max_task_bp_pinned(int cpu)
> >  {
> > -	if (atomic_inc_return(&bp_slot) == HBP_NUM) {
> > -		atomic_dec(&bp_slot);
> > +	int i;
> > +	unsigned int *tsk_pinned = per_cpu(task_bp_pinned, cpu);
> >  
> > -		return -ENOSPC;
> > +	for (i = HBP_NUM -1; i >= 0; i--) {
> > +		if (tsk_pinned[i] > 0)
> > +			return i + 1;
> >  	}
> 
> One checkpatch error in the code above..
> 
> ERROR: need consistent spacing around '-' (ctx:WxV)
> #206: FILE: kernel/hw_breakpoint.c:81:
> +       for (i = HBP_NUM -1; i >= 0; i--) {
>                          ^
> 
> Daniel


Oops, I'll fix that too, thanks.

