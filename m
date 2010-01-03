Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191Ab0ACX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0ACX3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141Ab0ACX3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:29:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0ACX3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:29:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Mon, 4 Jan 2010 00:30:01 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001032229.53221.rjw@sisk.pl> <24fb84fa.38887c91.4b411ffd.e7f1f@o2.pl>
In-Reply-To: <24fb84fa.38887c91.4b411ffd.e7f1f@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001040030.01256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> Dnia 3 stycznia 2010 22:29 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
...
> 
> It could be even UIO module but there are no pm events reachable there?
> 
> If it is not clean, we must extend pm-utils or write something new
> (with backends dbus, ipc, scripts, ...)
> But You see? We still have no information from kernel about events 
> (especialy resume) or maybe i dont see this ;/

They are available to the process that tells the kernel to suspend.

Namely, to tell the kernel to suspend to RAM, the process (call it a power
manager) needs to (for example) fprintf() "mem" to /sys/power/state.  As soon
as this happens, the kernel will start to freeze processes (except for the
power manager itself), so the power manager knows that everything should be
ready for the suspend before it writes to /sys/power/state.  It doesn't need
the kernel to tell it when the suspend is going to start, because it _knows_
that in advance.

Now, the fprintf() used to trigger the suspend will not return until the resume
is complete.  So, again, when the fprintf() returns, the power manager will know
that the resume has just finished (more precisely, the kernel side of it has
just finished).

There simply is no need for any special communication between the kernel and
the power manager.

Rafael
