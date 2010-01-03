Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227Ab0ACXfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0ACXfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197Ab0ACXff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:35:35 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:47794 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0ACXfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:35:34 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, awalls@radix.net, danborkmann@googlemail.com,
       linux-pm@lists.linux-foundation.org, stern@rowland.harvard.edu,
       rjw@sisk.pl
In-Reply-To: <201001040030.01256.rjw@sisk.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001032229.53221.rjw@sisk.pl> <24fb84fa.38887c91.4b411ffd.e7f1f@o2.pl> <201001040030.01256.rjw@sisk.pl>
Mime-Version: 1.0
Message-ID: <54ac764e.502c1a33.4b4129c3.9dc1b@o2.pl>
Date: Mon, 04 Jan 2010 00:35:31 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 4 stycznia 2010 0:30 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):

> On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> > Dnia 3 stycznia 2010 22:29 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> ...
> > 
> > It could be even UIO module but there are no pm events reachable there?
> > 
> > If it is not clean, we must extend pm-utils or write something new
> > (with backends dbus, ipc, scripts, ...)
> > But You see? We still have no information from kernel about events 
> > (especialy resume) or maybe i dont see this ;/
> 
> They are available to the process that tells the kernel to suspend.
> 
> Namely, to tell the kernel to suspend to RAM, the process (call it a power
> manager) needs to (for example) fprintf() "mem" to /sys/power/state.  As soon
> as this happens, the kernel will start to freeze processes (except for the
> power manager itself), so the power manager knows that everything should be
> ready for the suspend before it writes to /sys/power/state.  It doesn't need
> the kernel to tell it when the suspend is going to start, because it _knows_
> that in advance.
> 
> Now, the fprintf() used to trigger the suspend will not return until the resume
> is complete.  So, again, when the fprintf() returns, the power manager will know
> that the resume has just finished (more precisely, the kernel side of it has
> just finished).
> 
> There simply is no need for any special communication between the kernel and
> the power manager.
> 

Thx Rafael - now it clear to me.
And what do You think about sending extra signals to processes?

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/

