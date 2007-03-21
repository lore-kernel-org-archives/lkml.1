Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbXCURL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbXCURL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXCURLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:11:55 -0400
Received: from mail.screens.ru ([213.234.233.54]:49463 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbXCURLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:11:55 -0400
Date: Wed, 21 Mar 2007 20:15:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-ID: <20070321171538.GA550@tv-sign.ru>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174446834.6665.3.camel@nigel.suspend2.net> <20070321142350.GB78@tv-sign.ru> <200703211545.17919.rjw@sisk.pl> <20070321082029.2a38e09f.akpm@linux-foundation.org> <20070321165534.GA476@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321165534.GA476@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Oleg Nesterov wrote:
>
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

Just in case, this is not the only problem with this patch. The things like
attach_pid(PIDTYPE_PGID/PIDTYPE_SID) or add_parent() are wrong for the idle
threads unless the parent is "swapper". But this is not always so.

Oleg.

