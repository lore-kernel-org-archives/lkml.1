Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXBRKs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXBRKs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXBRKs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:48:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbXBRKs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:48:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sun, 18 Feb 2007 11:32:39 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702172324.44892.rjw@sisk.pl> <20070217234201.GA591@tv-sign.ru>
In-Reply-To: <20070217234201.GA591@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181132.41264.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 00:42, Oleg Nesterov wrote:
> On 02/17, Rafael J. Wysocki wrote:
> >
> > On Saturday, 17 February 2007 22:34, Oleg Nesterov wrote:
> > > 
> > > 	static inline int is_user_space(struct task_struct *p)
> > > 	{
> > > 		return p->mm && !(p->flags & PF_BORROWED_MM);
> > > 	}
> > > 
> > > This doesn't look right. First, an exiting task has ->mm == NULL after
> > > do_exit()->exit_mm(). Probably not a problem. However, PF_BORROWED_MM
> > > check is racy without task_lock(), so we can have a false positive as
> > > well. Is it ok? We can freeze aio_wq prematurely.
> > 
> > Right now aio_wq is not freezeable (PF_NOFREEZE).
> 
> Right now yes, but we are going to change this?

Well, is there any more reliable (and not racy) method of differentiating
between kernel threads and user space processes?

> > > 				cancel_freezing(p);
> > > 				continue;
> > > 
> > > Is it right? Shouldn't we increment "todo" counter?
> > 
> > No.  It would be wrong to do that, because TASK_TRACED tasks with frozen
> > parents cannot be frozen any further.
> 
> TASK_TRACED task could be woken by SIGKILL. cancel_freezing() clears TIF_FREEZE.
> The task may start do_exit() when try_to_freeze_tasks() returns "success".
> Probably not a problem.

Yup.

Greetings,
Rafael
