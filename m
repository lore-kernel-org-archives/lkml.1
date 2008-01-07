Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbYAGNM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbYAGNM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbYAGNKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:10:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbYAGNKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:10:30 -0500
Date: Mon, 7 Jan 2008 14:10:14 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jon Masters" <jcm@redhat.com>,
       "Satoru Takeuchi" <takeuchi_satoru@jp.fujitsu.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
 priority
Message-ID: <20080107141014.3815fcca@brian.englab.brq.redhat.com>
In-Reply-To: <3efb10970801070322w38cf53acy75b352c44ad049b8@mail.gmail.com>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<20080107110603.09b72450@brian.englab.brq.redhat.com>
	<3efb10970801070322w38cf53acy75b352c44ad049b8@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 12:22:51 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Michal and Andrew,
> 
> > Let's not make the decision for the user. Just allow the
> > administrator to change kthreadd's priority safely if he chooses to
> > do it. Ensure that the kernel threads are created with the usual
> > nice level even if kthreadd's priority is changed from the default.
> 
> Last year, I posted a patchset (that was meant for Preempt-RT at that
> time) to be able to prioritise the interrupt-handler-threads (which
> are kthreads) and softirq-threads from the kernel commandline. See
> http://lkml.org/lkml/2007/12/19/208
> 
> Maybe we can find a way to use a similar mechanism as I used in my
> patchset for the priorities of the remaining kthreads.
> I do not like the way of forcing userland to change the priorities,
> because that would require a userland with the chrt tool installed,
> and that is not that practical for embedded systems (in which there
> could be cases that there is no userland at all, or the init-process
> is the whole embedded application). In that case an option to do it on
> the kernel commandline is more practical.
> 
> I propose this kernel cmd-line option:
> kthread_pmap=somethread:50,otherthread:12,34

I see. kthreadd would look up the priority for itself and
kthread_create would consult the map for all other kernel threads.
That should work.
Your sirq_pmap would not be needed anymore, as kthread_pmap could be
used for softirq threads too, right?

Michal
