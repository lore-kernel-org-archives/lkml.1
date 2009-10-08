Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZJHMfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZJHMfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZJHMfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:35:04 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52329 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbZJHMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:35:03 -0400
To: paulmck@linux.vnet.ibm.com, catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
	<20091007155142.GB6743@linux.vnet.ibm.com>
In-Reply-To: <20091007155142.GB6743@linux.vnet.ibm.com>
Message-Id: <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 8 Oct 2009 21:34:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> > --- linux-2.6.32-rc3.orig/mm/kmemleak.c
> > +++ linux-2.6.32-rc3/mm/kmemleak.c
> > @@ -833,7 +833,7 @@ static void early_alloc(struct early_log
> >  	 */
> >  	rcu_read_lock();
> >  	object = create_object((unsigned long)log->ptr, log->size,
> > -			       log->min_count, GFP_KERNEL);
> > +			       log->min_count, GFP_ATOMIC);
> 
> Won't we need to check for object==NULL?
> 
> 							Thanx, Paul
> 
> >  	spin_lock_irqsave(&object->lock, flags);
> >  	for (i = 0; i < log->trace_len; i++)
> >  		object->trace[i] = log->trace[i];
> > 

Indeed. We need to check for NULL.

If the stack dump is correct, this error indicates circular function calls.
We need to find the location which triggers circular memory allocation.
Maybe just checking for NULL is not sufficient.
