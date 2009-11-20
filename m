Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZKTLXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZKTLXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZKTLXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:23:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZKTLXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:23:41 -0500
Date: Fri, 20 Nov 2009 12:23:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [tip:irq/core] genirq: switch /proc/irq/*/spurious to seq_file
Message-ID: <20091120112317.GA18758@elte.hu>
References: <20090828181743.GA14050@x200.localdomain>
 <tip-a1afb6371bb5341057056194d1168753f6d77242@git.kernel.org>
 <20091119185056.GA29223@x200.localdomain>
 <20091120101949.GD16781@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120101949.GD16781@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Wed, Nov 18, 2009 at 11:54:34AM +0000, tip-bot for Alexey Dobriyan wrote:
> > > --- a/kernel/irq/proc.c
> > > +++ b/kernel/irq/proc.c
> > > @@ -148,18 +148,28 @@ static const struct file_operations default_affinity_proc_fops = {
> > >  };
> > >  #endif
> > >  
> > > -static int irq_spurious_read(char *page, char **start, off_t off,
> > > -				  int count, int *eof, void *data)
> > > +static int irq_spurious_proc_show(struct seq_file *m, void *v)
> > >  {
> > > -	struct irq_desc *desc = irq_to_desc((long) data);
> > > -	return sprintf(page, "count %u\n"
> > > -			     "unhandled %u\n"
> > > -			     "last_unhandled %u ms\n",
> > > -			desc->irq_count,
> > > -			desc->irqs_unhandled,
> > > -			jiffies_to_msecs(desc->last_unhandled));
> > > +	struct irq_desc *desc = irq_to_desc((long) m->private);
> > 						   ^^^^^^^^^^
> > > +
> > > +	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
> > > +		   desc->irq_count, desc->irqs_unhandled,
> > > +		   jiffies_to_msecs(desc->last_unhandled));
> > > +	return 0;
> > > +}
> > > +
> > > +static int irq_spurious_proc_open(struct inode *inode, struct file *file)
> > > +{
> > > +	return single_open(file, irq_spurious_proc_show, NULL);
> > 
> > Oops, there has to be PDE(inode)->data instead of NULL.
> 
> Send a patch please.
> 
> Thanks,

Never mind - Thomas queued up the fix meanwhile.

Thanks,

	Ingo
