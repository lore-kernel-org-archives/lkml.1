Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYEGMQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYEGMQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYEGMQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:16:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbYEGMQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:16:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFC][PATCH 1/2] Freezer: Introduce PF_FREEZER_NOSIG
Date: Wed, 7 May 2008 14:16:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200805070003.56387.rjw@sisk.pl> <200805070005.20403.rjw@sisk.pl> <20080507093621.GF13858@elf.ucw.cz>
In-Reply-To: <20080507093621.GF13858@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071416.48180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Pavel Machek wrote:
> Hi!

Hi,

> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The freezer currently attempts to distinguish kernel threads from
> > user space tasks by checking if their mm pointer is unset and it
> > does not send fake signals to kernel threads.  However, there are
> > kernel threads, mostly related to networking, that behave like
> > user space tasks and may want to be sent a fake signal to be frozen.
> > 
> > Introduce the new process flag PF_FREEZER_NOSIG that will be set
> > by default for all kernel threads and make the freezer only send
> > fake signals to the tasks having PF_FREEZER_NOSIG unset.  Provide
> > the set_freezable_with_signal() function to be called by the kernel
> > threads that want to be sent a fake signal for freezing.
> > 
> > This patch should not change the freezer's observable behavior.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACK.

Thanks!

> > -static int has_mm(struct task_struct *p)
> > +static inline bool should_send_signal(struct task_struct *p)
> >  {
> > -	return (p->mm && !(p->flags & PF_BORROWED_MM));
> > +	return !(current->flags & PF_FREEZER_NOSIG);
> >  }
> >
> 
> Note that we used to tell kernel threads by ->mm, and now you assume
> that anything created by ktrheadd is kernel thread, ->mm or not.
> 
> I'm not sure if those can differ (->mm = NULL somewhere? Or ->mm =
> something somewhere else?).

It's done in analogy with PF_NOFREEZE, ie. everything that has
set PF_NOFREEZE by default also has PF_FREEZER_NOSIG set by default, so I
really don't expect any problems here.

> I guess this should go to -mm for a long test...

Yes, it should.

Thanks,
Rafael
