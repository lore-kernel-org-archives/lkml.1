Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZCFMIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZCFMIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 07:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZCFMIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 07:08:11 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:35165 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCFMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 07:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tPZxXjcUQZAcS28juegN1tAcqCltndhdqxWmPwwDrFDk9MTUewt1w6dWX1CvrI75aW
         kIsCXWHHFX8EEXX4kxF3AlWsY7W7w+8se1AX9TbXhmRNf4mO4fPg+AHb7/WWBsNAWJ42
         3CWyyT2rM+BNvBFtx4TU+R2fWA+J9zuIIKqeU=
Date: Fri, 6 Mar 2009 13:08:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] Binary ftrace_printk
Message-ID: <20090306120802.GC5988@nowhere>
References: <49af5ecb.1c07d00a.32d5.2f45@mx.google.com> <20090306105217.GB5988@nowhere> <20090306115822.GB18798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306115822.GB18798@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:58:22PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Mar 05, 2009 at 05:53:58AM +0100, Frederic Weisbecker wrote:
> > > 
> > > This new iteration addresses Steven's reviews.
> > > Notably:
> > > 
> > > - only build the ftrace_printk format section if CONFIG_TRACING is set
> > > - be scheduler tracing safe (don't use preempt_enable directly from
> > >   ftrace_printk to avoid tracing recursion)
> > > - fix a loss of format string when a module is unloaded. Since we can loose
> > >   it on the ring-buffer if it is in overwrite mode, we don't keep track
> > >   of the format given by the modules to free them. We just copy their
> > >   ftrace_printk string format forever. Note that it is safe against duplicate
> > >   strings since we verify if the string is already present in our list before
> > >   allocating a new one.
> > > 
> > > ---
> > 
> > 
> > tip:master has seen some changes concerning the tracing bits 
> > since this patchset submission, notably the movement of 
> > ftrace_printk to include/kernel.h
> > 
> > These patches probably won't anymore apply properly. Do you 
> > want me to rebase them against latest tip/master?
> 
> Yeah, please do. (Would there be a way for you to submit via 
> tools that preserve the email-threading of the patches? Right 
> now your mails come in separate threads each.)


Ok, I will try that. Until now I used a very simple smtp client.
I will try git-send-mail.

 
> > Or perhaps you prefer to wait for a Acked-by from Linus or 
> > Andrew?
> 
> The current lineup looks pretty good to me.
> 
> Patch #1 is what modifies lib/vsprintf.c and unless Linus or 
> Andrew objects i plan to put that into tip:core/printk so that 
> it's not embedded in the tracing tree and sent upstream 
> separately.
> 
> Then i'll merge that branch into the tracing tree and apply 
> patches #2...#5. So as long as you send against tip:master (i.e. 
> against the latest tracing bits) i'll be able to sort it out 
> neatly.
> 
> 	Ingo


Ok.

