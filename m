Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359Ab0AEXDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0AEXDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709Ab0AEXDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:03:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0AEXDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:03:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from module
Date: Wed, 6 Jan 2010 00:03:23 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Anders Eriksson <aeriksson@fastmail.fm>,
       linux-pm@lists.linux-foundation.org, awalls@radix.net,
       danborkmann@googlemail.com
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001052223.21964.rjw@sisk.pl> <16a1b165.2fdc37c6.4b43b943.c6733@o2.pl>
In-Reply-To: <16a1b165.2fdc37c6.4b43b943.c6733@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001060003.23419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Bartłomiej Zimoń wrote:
> Dnia 5 stycznia 2010 22:23 	"Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > On Tuesday 05 January 2010, Bartłomiej Zimoń wrote:
> > > Dnia 5 stycznia 2010 10:07 	Anders Eriksson <aeriksson@fastmail.fm> napisał(a):
> > > > 
> > > > rjw@sisk.pl said:
> > > > >> > I don't see a problem with this in principle, although I don't think signals
> > > > >> > are very suitable for this particular purpose, because you need two-way
> > > > >> > communication between the power manager and the processes it's going to
> > > > >> > notify (because it has to wait for the processes to finish their preparations
> > > > >> > and to tell it that they are ready). 
> > > > 
> > > > Wouldn't there need to be dependecy tracking for the userspace processes? A 
> > > > process couldn't signal "done" until it know there's no more work to do, which 
> > > > requires all other processes to finish up first.
> > > > 
> > > 
> > > Not all processes will need pm notification.
> > > 
> > > Just in case, could this "power manager" be provided as userspace
> > > driver for kernel (for example compiled as UIO)?
> > 
> > I don't really understand why you want to do that in the kernel.  Is there
> > any particular reason why this cannot be done in the user space?
> > 
> 
> Problem is with notification from pm-utils. Dbus for session is only 
> user session waid and it is almost imposible to send something 
> from systembus or it needs lots of magic.

Don't use dbus, then.

> Even if i'll use pm-utils, must provide way to notify my app.
> Looks like no standard way here, that's bad, every app has it's own?

Isn't there a possibility to introduce a standard way of doing that without
involving the kernel directly?

> I think this way - if kernel is processes manager and if it sends
> "some unknown" signal to every process before kernel suspend so why
> not send sepcific and known signal instread.

We _can_ do that, but what would a process be supposed to do after receiving
such a signal?

> But now we have DeviceKit-power/upower whatever but it doesn't provide
> this feature or something simmilar to relay on.

You're still not saying what you really need.  So, what's the application you
have in mind that needs a notification from the _kernel_ so badly?

Rafael
