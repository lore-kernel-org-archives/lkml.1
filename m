Return-Path: <linux-kernel-owner+w=401wt.eu-S935908AbZFPGRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935908AbZFPGRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZFPGR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:17:26 -0400
Received: from www84.your-server.de ([213.133.104.84]:38562 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbZFPGRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:17:25 -0400
Subject: Re: + procfs-provide-stack-information-for-threads-v08.patch added
 to -mm tree
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, ebiederm@xmission.com, mingo@elte.hu
In-Reply-To: <20090615223333.GA8734@x200.localdomain>
References: <200906152202.n5FM25VD021536@imap1.linux-foundation.org>
	 <20090615223333.GA8734@x200.localdomain>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 08:17:06 +0200
Message-Id: <1245133026.17989.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 16.06.2009, 02:33 +0400 schrieb Alexey Dobriyan:
> On Mon, Jun 15, 2009 at 03:02:05PM -0700, akpm@linux-foundation.org wrote:
> >      procfs-provide-stack-information-for-threads-v08.patch
> > --- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08
> 
> > +++ a/fs/proc/array.c
> > @@ -321,6 +321,54 @@ static inline void task_context_switch_c
> >  			p->nivcsw);
> >  }
> >  
> > +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> > +					struct task_struct *p)
> > +{
> > +	unsigned long	i;
> > +	struct page	*page;
> > +	unsigned long	stkpage;
> > +
> > +	stkpage = KSTK_ESP(p) & PAGE_MASK;
> > +
> > +#ifdef CONFIG_STACK_GROWSUP
> > +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
> > +
> > +		page = follow_page(vma, i-PAGE_SIZE, 0);
> 
> How can this work?
> 
> If stack page got swapped out, you'll get smaller than actual result.
> 

If you tell me how to do it in the right way, i can fix it!


