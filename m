Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZFDL5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZFDL5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZFDL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:56:57 -0400
Received: from www84.your-server.de ([213.133.104.84]:35431 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbZFDL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:56:57 -0400
Subject: Re: [patch] procfs: provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>, Joerg Engel <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090604043750.e1031e01.akpm@linux-foundation.org>
References: <1238511505.364.61.camel@matrix>
	 <20090401193135.GA12316@elte.hu> <1244114628.31230.3.camel@wall-e>
	 <20090604043750.e1031e01.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 13:56:29 +0200
Message-Id: <1244116589.32392.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Donnerstag, den 04.06.2009, 04:37 -0700 schrieb Andrew Morton:
> On Thu, 04 Jun 2009 13:23:48 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> >  - slime done
> 
> What's "slime"?
> 

Sorry, that was a typo, should be "slim down".

> > +	for (i = vma->vm_start; i+PAGE_SIZE <= stkpage; i += PAGE_SIZE) {
> > +
> > +		page = follow_page(vma, i, 0);
> > +
> > +		if (!IS_ERR(page) && page)
> 
> Shouldn't this be !page?
> 

No, this is correct... I walk through the top of vma to the first mapped
page, this is the high water mark of the stack.

> > +					unsigned long stack_start;
> > +
> > +					stack_start =
> > +						((struct proc_maps_private *)
> > +						m->private)->task->stack_start;
> 
> I'd suggested a clearer/cleaner way of implementing this.
> 

Sorry, i can not see a problem here. In your last posting you wrote
thats okay! And i have no idea how to make this expression
clearer/cleaner.

> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> This should be positioned at the end of the changelog, ahead of the
> patch itself.
> 

Next time i will do this, okay?


