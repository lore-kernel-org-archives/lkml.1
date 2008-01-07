Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYAGPx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYAGPx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYAGPxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:53:21 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:41732 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYAGPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NGhvm3o4v3sObk3Si91gfeCQ5J7qwfVmeCnkPnGs6IXxSqDn3C31Lg029EMEHD1hrzx5GFfPW1fv0GDO/gruruU81YndaCJvnTNC3Pk1zeFSaz7/7BjvMTx1Js34hxEV4OjwI8zDHQaFsyPItRNOkpxsIZl7UIaTluepSCOX748=
Message-ID: <3efb10970801070753n63964527occ4756a8763eb060@mail.gmail.com>
Date: Mon, 7 Jan 2008 16:53:18 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Michal Schmidt" <mschmidt@redhat.com>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal priority
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jon Masters" <jcm@redhat.com>,
       "Satoru Takeuchi" <takeuchi_satoru@jp.fujitsu.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20080107141014.3815fcca@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <20080107110603.09b72450@brian.englab.brq.redhat.com>
	 <3efb10970801070322w38cf53acy75b352c44ad049b8@mail.gmail.com>
	 <20080107141014.3815fcca@brian.englab.brq.redhat.com>
X-Google-Sender-Auth: 8cda5bc684462da0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

> > Maybe we can find a way to use a similar mechanism as I used in my
> > patchset for the priorities of the remaining kthreads.
> > I do not like the way of forcing userland to change the priorities,
> > because that would require a userland with the chrt tool installed,
> > and that is not that practical for embedded systems (in which there
> > could be cases that there is no userland at all, or the init-process
> > is the whole embedded application). In that case an option to do it on
> > the kernel commandline is more practical.
> >
> > I propose this kernel cmd-line option:
> > kthread_pmap=somethread:50,otherthread:12,34
>
> I see. kthreadd would look up the priority for itself and
> kthread_create would consult the map for all other kernel threads.
> That should work.
> Your sirq_pmap would not be needed anymore, as kthread_pmap could be
> used for softirq threads too, right?

That is correct. The soft-irqs are just ordinary kernel-threads, but
irq_pmap is still needed, to set the priority of a certain interrupt
handler.
In this case it also possible to set the prio of the IRQ-kthreads as
well as the prio of a certain interrupt handler. This might give some
conflicts, and I have to check how to resolve these.

Kind Regards,

Remy


2008/1/7, Michal Schmidt <mschmidt@redhat.com>:
> On Mon, 7 Jan 2008 12:22:51 +0100
> "Remy Bohmer" <linux@bohmer.net> wrote:
>
> > Hello Michal and Andrew,
> >
> > > Let's not make the decision for the user. Just allow the
> > > administrator to change kthreadd's priority safely if he chooses to
> > > do it. Ensure that the kernel threads are created with the usual
> > > nice level even if kthreadd's priority is changed from the default.
> >
> > Last year, I posted a patchset (that was meant for Preempt-RT at that
> > time) to be able to prioritise the interrupt-handler-threads (which
> > are kthreads) and softirq-threads from the kernel commandline. See
> > http://lkml.org/lkml/2007/12/19/208
> >
> > Maybe we can find a way to use a similar mechanism as I used in my
> > patchset for the priorities of the remaining kthreads.
> > I do not like the way of forcing userland to change the priorities,
> > because that would require a userland with the chrt tool installed,
> > and that is not that practical for embedded systems (in which there
> > could be cases that there is no userland at all, or the init-process
> > is the whole embedded application). In that case an option to do it on
> > the kernel commandline is more practical.
> >
> > I propose this kernel cmd-line option:
> > kthread_pmap=somethread:50,otherthread:12,34
>
> I see. kthreadd would look up the priority for itself and
> kthread_create would consult the map for all other kernel threads.
> That should work.
> Your sirq_pmap would not be needed anymore, as kthread_pmap could be
> used for softirq threads too, right?
>
> Michal
>
