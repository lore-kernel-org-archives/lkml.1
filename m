Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXCUQWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXCUQWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCUQWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:22:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbXCUQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:22:50 -0400
Date: Wed, 21 Mar 2007 08:20:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-Id: <20070321082029.2a38e09f.akpm@linux-foundation.org>
In-Reply-To: <200703211545.17919.rjw@sisk.pl>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174446834.6665.3.camel@nigel.suspend2.net>
	<20070321142350.GB78@tv-sign.ru>
	<200703211545.17919.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 15:45:16 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 21 March 2007 15:23, Oleg Nesterov wrote:
> > On 03/21, Nigel Cunningham wrote:
> > > 
> > > On Tue, 2007-03-20 at 19:23 -0600, Eric W. Biederman wrote:
> > > > >> > Rafael J. Wysocki napsal(a):
> > > > >
> > > > > Bisection shows that the freezing of processes has been broken by one of the
> > > > > patches:
> > > > >
> > > > > remove-the-likelypid-check-in-copy_process.patch
> > > > 
> > > > Grr.  Oleg's review of remove-the-likelypid-check-in-copy-process
> > > > showed it to be questionable (and it was just an optimization)
> > > > so we can get rid of that one easily. 
> > > > 
> > > > Although all it did that was really questionable was add
> > > > the idle process to the global process list and bump a process
> > > > count when we forked the idle process.  Not dramatically dangerous
> > > > things.
> > > 
> > > Could the freezer code be trying to freeze the idle thread as a result?
> > 
> > Yes. remove-the-likelypid-check-in-copy_process.patch make idle threads
> > visible to for_each_process/do_each_thread. Note also that idle threads
> > have ->mm != NULL. freezer, oom_kill, move_task_off_dead_cpu, etc, should
> > not see idle threads, but they do now.
> 
> Well, I think this is a good enough reason for asking Andrew to drop this
> patch.

Or we change the freezer to skip pid==0 tasks.
