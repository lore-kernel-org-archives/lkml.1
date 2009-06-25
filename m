Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZFYJ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZFYJ5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZFYJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:57:12 -0400
Received: from www.tglx.de ([62.245.132.106]:42125 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZFYJ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:57:11 -0400
Date: Thu, 25 Jun 2009 11:56:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [GIT pull] futex fixes for 2.6.31
In-Reply-To: <1245897826.2560.421.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0906251151400.2767@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>  <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>  <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain> <1245897826.2560.421.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1275603800-1245923799=:2767"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1275603800-1245923799=:2767
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 25 Jun 2009, Zhang, Yanmin wrote:
> On Wed, 2009-06-24 at 21:48 +0200, Thomas Gleixner wrote:
> > +static int fault_in_user_writeable(u32 __user *uaddr)
> > +{
> > +	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
> > +				 sizeof(*uaddr), 1, 0, NULL, NULL);
> The 4th parameter of get_user_pages means page number. ﻿sizeof(*uaddr) is equal to
> 4, so you want 4 pages?

Grrr. I looked up the prototype of it in include/linux/mm.h:

int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
			unsigned long start, int len, int write, int force,
			struct page **pages, struct vm_area_struct **vmas);

len == number of pages ! How intutitive. :(

I guess Linus tripped over it as well. See:
http://lkml.org/lkml/2009/6/21/95

> > > In fact, since you're not actually interested in the page, you _could_ 
> > > just do
> > >
> > >  get_user_pages(tsk, mm, uaddr, 4, 1, 0, NULL, NULL);

Will fix, thanks for noticing!

     tglx
--8323328-1275603800-1245923799=:2767--
