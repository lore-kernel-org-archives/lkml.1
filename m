Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187Ab0ACXSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0ACXSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135Ab0ACXSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:18:03 -0500
Received: from rekin23.go2.pl ([193.17.41.16]:34458 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0ACXSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:18:01 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org
Mime-Version: 1.0
Message-ID: <2d484a86.2379951a.4b4125a6.e3e58@o2.pl>
Date: Mon, 04 Jan 2010 00:17:58 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 3 stycznia 2010 22:29 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > > To put it in a different way, you apparently want the kernel to notify the user
> > > space of an event originating from the user space and my question is why not
> > > to set up the user space to generate the notification without relying on the
> > > kernel to do that.
> > 
> > Because now kernel know better what is going on.
> 
> That's because it's just been told by the user space about that.
> 
> Basically, you want something like this to happen:
> 
> process A ->(suspend) kernel
> kernel ->(suspending) process B
> 

Yes.

> where the kernel won't wait for process B to do whatever it has to do before
> suspending.  In my opinion it'd be better to do something like this
> 
> process A ->(suspending) process B
> process B ->(ack) process A
> process A ->(suspend) kernel
> 
> ... 

Please forget for a moment about pm-utils.

I was thinking about sf like this:
pm-notify is registered in pm_notifier_chain or called before pm_notifiers_chain
pm-notify -> (suspending) all registerd processes
some processes ->(ack) pm-notify
to consider - after timeout ( 1s. could be ok) pm-notify will send NOTIFY_OK, kernel will cont. suspending

It could be even UIO module but there are no pm events reachable there?

I cant understand why kernel cant be simple power manager.

Consider this: add one more signal (SIGPREFREEZ, SIGPOSTFREEZ) and send this before/after suspend to processes.
It could be simplest way and we have notified processes.

If pm-notify idea is not clean, we must extend pm-utils or write something new
(with backends dbus, ipc, scripts, ...)
But You see? We still have no information from kernel about events 
(especialy resume) or maybe i dont see this ;/

Thanks for your understanding Rafael :)

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/


