Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYHKTWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYHKTWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHKTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:21:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:34512 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYHKTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W94ToVNIA6D4mYnEDe2uVn7OXFOryeFt7hKdwVKNXgg+rkdF7B5xnYHtp4ejGtLz3F
         S4rRIwlrneXX9z++vhpKSgy9kpWAhefvBQdKChKv8KcmvwrYly0NjHp/S0Xzxfb9kvkj
         jnlinCjzx9L1bXwl4Cx3cyOaPVGRhu3QrVlO0=
Date: Mon, 11 Aug 2008 23:22:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, mingo@redhat.com, linux-kernel@vger.kernel.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: remove empty lines from stack traces/oopses
Message-ID: <20080811192210.GA5791@martell.zuzino.mipt.ru>
References: <20080731235137.GA4816@martell.zuzino.mipt.ru> <20080811170219.GJ4524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811170219.GJ4524@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 07:02:19PM +0200, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> >  show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
> >  		unsigned long *stack, unsigned long bp, char *log_lvl)
> >  {
> > -	printk("\nCall Trace:\n");
> > +	printk("Call Trace:\n");
> >  	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
> > -	printk("\n");
> >  }
> 
> hm, it's nice to have stack traces stand out a bit, and to not get the 
> 'Call Trace' embedded in the middle of a printk (which happens to crash 
> or produce a stack dump).

Sometimes all you have is 80x25 or just screenshot from some stupid windows
monitoring program.

> >  void show_trace(struct task_struct *task, struct pt_regs *regs,
> > @@ -386,6 +385,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
> >  		printk(" %016lx", *stack++);
> >  		touch_nmi_watchdog();
> >  	}
> > +	printk("\n");
> >  	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
> >  }
> >  
> > @@ -443,7 +443,6 @@ void show_registers(struct pt_regs *regs)
> >  		printk("Stack: ");
> >  		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
> >  				regs->bp, "");
> > -		printk("\n");
> >  
> >  		printk(KERN_EMERG "Code: ");
> 
> just to make sure i get the gist of your change, do you have a 'before' 
> and 'after' sample oops, so that we can see the difference?

Any recent oops with and without empty lines after Call trace: and
after calltrace.

