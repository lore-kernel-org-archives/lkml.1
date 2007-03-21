Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXCUDOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXCUDOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCUDOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:14:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34357 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbXCUDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:13:59 -0400
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pm@lists.osdl.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <46004B02.7020407@gmail.com> <200703202206.38168.rjw@sisk.pl>
	 <200703210149.33240.rjw@sisk.pl> <m1lkhre6f5.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 14:13:54 +1100
Message-Id: <1174446834.6665.3.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-03-20 at 19:23 -0600, Eric W. Biederman wrote:
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
> 
> > use-task_pgrp-task_session-in-copy_process.patch
> 
> As I recall that patch was pretty trivial, and shouldn't have
> anything to do with the freezer.   The process freezer doesn't care
> about pids does it?

Could the freezer code be trying to freeze the idle thread as a result?

Regards,

Nigel

