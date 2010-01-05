Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971Ab0AEPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0AEPvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945Ab0AEPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:50:59 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:33031 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0AEPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:50:58 -0500
Date: Tue, 5 Jan 2010 16:50:53 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results on s390x)
Message-ID: <20100105165053.3e75e438@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100105154725.GB9376@redhat.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<20100104155225.GA16650@redhat.com>
	<20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
	<20100104181412.GA21146@redhat.com>
	<20100104211147.4CC94D532@magilla.sf.frob.com>
	<20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com>
	<20100105153633.GA9376@redhat.com>
	<20100105154725.GB9376@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 16:47:25 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/05, Oleg Nesterov wrote:
> >
> > Anyway. I modified the debugging patch a bit:
> >
> > --- K/arch/s390/kernel/traps.c~	2009-12-22 10:41:52.909174198 -0500
> > +++ K/arch/s390/kernel/traps.c	2010-01-05 09:49:19.541792379 -0500
> > @@ -384,6 +384,8 @@ void __kprobes do_single_step(struct pt_
> >  	}
> >  	if (tracehook_consider_fatal_signal(current, SIGTRAP))
> >  		force_sig(SIGTRAP, current);
> > +	else
> > +		printk("XXX: %d %d\n", current->pid, test_thread_flag(TIF_SINGLE_STEP));
> >  }
> >
> >  static void default_trap_handler(struct pt_regs * regs, long interruption_code)
> > -------------------------------------------------------------------------------
> 
> Ah, please ignore. I guess TIF_SINGLE_STEP was already cleared by the caller
> in entry.S

Yes, TIF_SINGLE_STEP is checked in entry.S and cleared before do_signal
is called. That is the "ni" instruction at sysc_singlestep and
sysc_sigpending.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

