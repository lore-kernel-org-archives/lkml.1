Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbXCUMFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbXCUMFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXCUMFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:05:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXCUMFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:05:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Date: Wed, 21 Mar 2007 13:08:32 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <200703210149.33240.rjw@sisk.pl> <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211308.33295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 02:23, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Tuesday, 20 March 2007 22:06, Rafael J. Wysocki wrote:
> >> On Tuesday, 20 March 2007 21:58, Jiri Slaby wrote:
> >> > Rafael J. Wysocki napsal(a):
> >> > > Actually, the problem is 100% reproducible on my system too and I doubt
> > it's
> >> > > caused by the recent freezer patches.
> >> > 
> >> > I don't know what exactly do you mean by recent, but 2.6.21-rc3-mm2 works
> >> > for me.
> >> 
> >> Thanks for the confirmation.
> >> 
> >> The patches I was talking about had already been in 2.6.21-rc3-mm2, so the
> >> reason of this failure must be different.
> >
> > Bisection shows that the freezing of processes has been broken by one of the
> > patches:
> >
> > remove-the-likelypid-check-in-copy_process.patch
> 
> Grr.  Oleg's review of remove-the-likelypid-check-in-copy-process
> showed it to be questionable (and it was just an optimization)
> so we can get rid of that one easily. 
> 
> Although all it did that was really questionable was add
> the idle process to the global process list and bump a process
> count when we forked the idle process.  Not dramatically dangerous
> things.

I think this patch is the culprit, though, as it seems that the freezer tries
to freeze the idle process and fails.  Yesterday I didn't have the time to
figure out the exact reason, I'll try to look at it later today.

> > use-task_pgrp-task_session-in-copy_process.patch
> 
> As I recall that patch was pretty trivial, and shouldn't have
> anything to do with the freezer.   The process freezer doesn't care
> about pids does it?

No, it doesn't, at least not directly.  I'll try to run the kernel with this
change and without remove-the-likelypid-check-in-copy_process.patch .

Greetings,
Rafael
