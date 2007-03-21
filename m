Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXCURJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXCURJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXCURJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:09:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44318 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbXCURJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:09:35 -0400
Date: Wed, 21 Mar 2007 09:08:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>, David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-Id: <20070321090824.38d67ce3.akpm@linux-foundation.org>
In-Reply-To: <20070321165534.GA476@tv-sign.ru>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174446834.6665.3.camel@nigel.suspend2.net>
	<20070321142350.GB78@tv-sign.ru>
	<200703211545.17919.rjw@sisk.pl>
	<20070321082029.2a38e09f.akpm@linux-foundation.org>
	<20070321165534.GA476@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 19:55:34 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 03/21, Andrew Morton wrote:
> >
> > On Wed, 21 Mar 2007 15:45:16 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Wednesday, 21 March 2007 15:23, Oleg Nesterov wrote:
> > > > > 
> > > > > Could the freezer code be trying to freeze the idle thread as a result?
> > > > 
> > > > Yes. remove-the-likelypid-check-in-copy_process.patch make idle threads
> > > > visible to for_each_process/do_each_thread. Note also that idle threads
> > > > have ->mm != NULL. freezer, oom_kill, move_task_off_dead_cpu, etc, should
> > > > not see idle threads, but they do now.
> > > 
> > > Well, I think this is a good enough reason for asking Andrew to drop this
> > > patch.
> > 
> > Or we change the freezer to skip pid==0 tasks.
> 
> I strongly disagree. In that case we should audit all users of for_each_process.
> Imho, this change is too dangerous. Actually, I personally think it is very good
> that idle threads are special and not visible, imho we should not change this.

OK, I'll tentatively drop remove-the-likelypid-check-in-copy_process.patch

> Btw. Rafael, Andrew, what about
> 
> 	[PATCH] Make XFS workqueues nonfreezable
> 	http://marc.info/?l=linux-kernel&m=117270675922229
> 
> , don't you think this should go to 2.6.21 ?
> 

I've sent it to the XFS guys a couple of times, but their black hole is one
of the deeper ones.

David?
