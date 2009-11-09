Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZKIDbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZKIDbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZKIDbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:31:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48850 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZKIDbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=u+uRL9XDRRWpwIW108J5CkO0y48fX1uP16L1BkblBdQEMS70vzy/L7Q7UiQzhaPKzM
         oBpcnCst/LDkpN9Pu+d22wV4ZxX74ZAqnGfpA9JIbAbUgY5R1pHCVQewinjXVvTgNrsu
         k+kyrKIEVndYS+Kt5K6gI3XLnmQkP7sKQMer8=
Subject: Re: [PATCH -v6 08/13] tracing: add IRQENTRY_EXIT section for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20091109022640.GC13153@nowhere>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
	 <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
	 <20091109022640.GC13153@nowhere>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 09 Nov 2009 11:31:08 +0800
Message-ID: <1257737468.3451.9.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-09 at 03:26 +0100, Frederic Weisbecker wrote:
> On Mon, Oct 26, 2009 at 11:13:25PM +0800, Wu Zhangjin wrote:
> > This patch add a new section for MIPS to record the block of the hardirq
> > handling for function graph tracer(print_graph_irq) via adding the
> > __irq_entry annotation to the the entrypoints of the hardirqs(the block
> > with irq_enter()...irq_exit()).
> > 
> > Thanks goes to Steven & Frederic Weisbecker for their feedbacks.
> > 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > +
> > +/*
> > + * do_IRQ handles all normal device IRQ's (the special
> > + * SMP cross-CPU interrupts have their own specific
> > + * handlers).
> > + */
> > +unsigned int __irq_entry do_IRQ(unsigned int irq)
> > +{
> > +	irq_enter();
> > +	__DO_IRQ_SMTC_HOOK(irq);
> > +	generic_handle_irq(irq);
> > +	irq_exit();
> > +
> > +	return 1;
> > +}
> 
> 
> 
> Nano-neat:
> 
> Why is it returning a value, it doesn't seem needed (the macro
> version didn't)?
> 

Will remove it later. 

> Anyway, that looks good to me. I hope the changes from macro
> to function calls will be ack by the MIPS maintainers.
> 

Hope Ralf give some feedbacks about it ;)

> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> 

Thanks!

BTW: 

Who should I resend this patchset to? you or Steven? If this patchset
are okay, I will rebase it on the latest tracing/core branch of -tip and
send the latest version out, and hope you can apply it, otherwise, I
need to rebase it to the future mainline versions again and again ;) and
at least, I have tested all of them and their combinations on YeeLoong
netbook, they work well. of course, more testing report from the other
MIPS developers are welcome ;)

Regards,
	Wu Zhangjin

