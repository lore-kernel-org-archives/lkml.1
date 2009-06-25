Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZFYKEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZFYKEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZFYKE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:04:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZFYKE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:04:27 -0400
Date: Thu, 25 Jun 2009 12:04:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [GIT pull] futex fixes for 2.6.31
Message-ID: <20090625100413.GD29980@elte.hu>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain> <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain> <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain> <1245897826.2560.421.camel@ymzhang> <alpine.LFD.2.00.0906251151400.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0906251151400.2767@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 25 Jun 2009, Zhang, Yanmin wrote:
> > On Wed, 2009-06-24 at 21:48 +0200, Thomas Gleixner wrote:
> > > +static int fault_in_user_writeable(u32 __user *uaddr)
> > > +{
> > > +	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
> > > +				 sizeof(*uaddr), 1, 0, NULL, NULL);
> > The 4th parameter of get_user_pages means page number. ﻿sizeof(*uaddr) is equal to
> > 4, so you want 4 pages?
> 
> Grrr. I looked up the prototype of it in include/linux/mm.h:
> 
> int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
> 			unsigned long start, int len, int write, int force,
> 			struct page **pages, struct vm_area_struct **vmas);
> 
> len == number of pages ! How intutitive. :(
> 
> I guess Linus tripped over it as well. See:
> http://lkml.org/lkml/2009/6/21/95

heh, and then i suggested to you to change the '4' to sizeof(u32) 
;-)

	Ingo
