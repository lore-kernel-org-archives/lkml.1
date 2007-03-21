Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXCUOm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXCUOm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXCUOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:42:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbXCUOmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:42:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Date: Wed, 21 Mar 2007 15:45:16 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174446834.6665.3.camel@nigel.suspend2.net> <20070321142350.GB78@tv-sign.ru>
In-Reply-To: <20070321142350.GB78@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211545.17919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 15:23, Oleg Nesterov wrote:
> On 03/21, Nigel Cunningham wrote:
> > 
> > On Tue, 2007-03-20 at 19:23 -0600, Eric W. Biederman wrote:
> > > >> > Rafael J. Wysocki napsal(a):
> > > >
> > > > Bisection shows that the freezing of processes has been broken by one of the
> > > > patches:
> > > >
> > > > remove-the-likelypid-check-in-copy_process.patch
> > > 
> > > Grr.  Oleg's review of remove-the-likelypid-check-in-copy-process
> > > showed it to be questionable (and it was just an optimization)
> > > so we can get rid of that one easily. 
> > > 
> > > Although all it did that was really questionable was add
> > > the idle process to the global process list and bump a process
> > > count when we forked the idle process.  Not dramatically dangerous
> > > things.
> > 
> > Could the freezer code be trying to freeze the idle thread as a result?
> 
> Yes. remove-the-likelypid-check-in-copy_process.patch make idle threads
> visible to for_each_process/do_each_thread. Note also that idle threads
> have ->mm != NULL. freezer, oom_kill, move_task_off_dead_cpu, etc, should
> not see idle threads, but they do now.

Well, I think this is a good enough reason for asking Andrew to drop this
patch.

Greetings,
Rafael
