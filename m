Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854Ab0ACIbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0ACIbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 03:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438Ab0ACIbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 03:31:06 -0500
Received: from rekin23.go2.pl ([193.17.41.16]:41179 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0ACIbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 03:31:05 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <1f57f1eb.184e5693.4b4055c5.e0fe0@o2.pl>
Date: Sun, 03 Jan 2010 09:31:01 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 3 stycznia 2010 0:29 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > Thanks for Your answare.
> > Some points of my idea:
> > - don't think everyone want to use pm-utils (didn't say it is bad)
> 
> That certainly is true, but I think these people won't have a problem setting
> up their suspend scripts to trigger the notification anyway. :-)
> 

But it means almoust always create dbus interface and send message by script.
For what? only to know if system going resume or suspend?

> Point is, suspend hooks are used anyway by almost everyone (due to graphics,
> networking, faulty drivers), so I think you could just use this mechanism, be it
> pm-utils or something else.
> 
> To put it in a different way, you apparently want the kernel to notify the user
> space of an event originating from the user space and my question is why not
> to set up the user space to generate the notification without relying on the
> kernel to do that.

Because now kernel know better what is going on.

> 
> > - this code is standard for all implementation of suspend/hibernate/resume
> 
> I guess you mean the existing kernel-side suspend/hibernate code.
> 
> Sure, it is, but your module is going to export the kernel's internal interface
> outside the kernel, turning it into a real API and that is a _big_ _deal_.  The
> reason why it is a big deal is that while we often change the kernel's internal
> interfaces, we don't change APIs.  Once created, an API (I mean a real
> userland-kernel interface) is very difficult to change, because that most often
> leads to regressions which are quite nasty from the user's point of view.
> 
> So, basically, you want us to declare that the kernel's internal
> suspend/hibernate notification mechanism won't change in the future, which is
> not something I'm going to do at this point.  Moreover, it hasn't been designed
> as an API and I don't think it's really suitable for this purpose.

Abosulutly no!
It's so primitive module and even with different api it could be easy to adept.
Next if it can't be in kernel source tree for someone could be very usefull.

This module could only sends bool/ioctl - system resumed.

> 
> At least, that requires some more discussion, so please tell us why you need
> the kernel to notify the user space about suspend/hibernation.  IOW, what's the
> final purpose of this?  [Added some CCs.]

Yes, it is only first step.
Have created different point of view, not all linux boxes are desktops/laptops.
What about embedeed solutions?
Why app must implement all other to know about resume/suspend?
Why not open file and know this easily?

> 
> > - it is small
> > - it have less overhead, dont need dbus and all rest services.
> 
> That could have been a good argument if those services had not been used
> already, but that's not the case.

Yes it is.
For every other case it was pm-utils created.

> 
> > - could be even used partialy by pm-utils
> > - it is perfect just to notify about event
> 
> OK, but why exactly do _you_ need that to happen?
> 
> There's one important drawback of making the kernel generate the notification.
> Namely, even if your userspace task is notified by the kernel of a PM event,
> that doesn't mean it'll have the time to act upon that, because the kernel will
> attempt to freeze it right after the notification has been sent.  This means
> you'd need a way to make the kernel wait for your user space process to finish
> it's job before continuing the suspend/hibernate process.  Otherwise it's not
> going to be very useful.
> 

First of all i want to start discussion about this topic and looks like started :)

So what was in my mind? There are lots of small devices today with linux.
Lots of them has got unstandardized suspend/resume detection.
It could be too much info exposed from kernel by this module/propose i understand
for program info about pm_post_resume event could be anought.

We have now 3types of suspend implementation and 1 kernel API inside.
App typicaly need just 2-3 event types - suspending, resumming, idle.
I dont want to slow down kernel suspend, block or something, just perform 
some actions in apps - typicaly try to reconnect.
It could be new kernel standard to easy adept some actions.

Why not pm-utils connect to such module and gather data?
Then It could work as hal service.
But hook on kernel like /sbin/init but for suspend and resume, looks like other solution.
IOW sending event to kernel to perform action and launch userspace once 
more just before pm-event chain ... check return_val, sounds like other 
solution/ other kind of module.

What about this discusion:
http://lists.freedesktop.org/archives/devkit-devel/2009-December/000617.html

I will perform some tests to know what amount of time is usualy needed to disconnect
nicely client or something.

Next what about fuse filesystems, there are some network based.

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/

