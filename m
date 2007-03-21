Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXCUOUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXCUOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXCUOUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:20:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:40667 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXCUOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:20:49 -0400
Date: Wed, 21 Mar 2007 17:23:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pm@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-ID: <20070321142350.GB78@tv-sign.ru>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <46004B02.7020407@gmail.com> <200703202206.38168.rjw@sisk.pl> <200703210149.33240.rjw@sisk.pl> <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com> <1174446834.6665.3.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174446834.6665.3.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Nigel Cunningham wrote:
> 
> On Tue, 2007-03-20 at 19:23 -0600, Eric W. Biederman wrote:
> > >> > Rafael J. Wysocki napsal(a):
> > >
> > > Bisection shows that the freezing of processes has been broken by one of the
> > > patches:
> > >
> > > remove-the-likelypid-check-in-copy_process.patch
> > 
> > Grr.  Oleg's review of remove-the-likelypid-check-in-copy-process
> > showed it to be questionable (and it was just an optimization)
> > so we can get rid of that one easily. 
> > 
> > Although all it did that was really questionable was add
> > the idle process to the global process list and bump a process
> > count when we forked the idle process.  Not dramatically dangerous
> > things.
> 
> Could the freezer code be trying to freeze the idle thread as a result?

Yes. remove-the-likelypid-check-in-copy_process.patch make idle threads
visible to for_each_process/do_each_thread. Note also that idle threads
have ->mm != NULL. freezer, oom_kill, move_task_off_dead_cpu, etc, should
not see idle threads, but they do now.

Oleg.

