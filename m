Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbYA3TSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbYA3TSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYA3TSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:18:43 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21959 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbYA3TSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:18:42 -0500
Message-ID: <47A0CD90.5080208@msgid.tls.msk.ru>
Date: Wed, 30 Jan 2008 22:18:40 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hibernate/suspend-to-disk: to turn power or not?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to "glue" hibernation and UPS control
together, and have a question.

When the system power comes off an UPS (Uninterruptable
Power Supply I mean), it's probably a good idea to turn
the UPS off when shutting the system down or hibernating.

Even with shutdown (not related to hibernating) there's
an interesting twist: modern systems can remember the
previous on/off status when the power gets cut and
restores - BIOS-controlled option that allows the
system to automatically start when the input power
returns.  Now, when we shutting down a system, we
need to turn the UPS *before* powering down the
system but *after* the shutdown procedure has been
completed.  This is done by replacing poweroff with
halt, and ordering the UPS to turn itself off after
a small delay (needed for the poweroff command to
complete) - this way, system will be on but in a
safe-to-powercut mode, and in order to turn it
back on only the UPS has to be turned on.

But the question comes as how to control the UPS when
we replace shutdown with hibernation.  Ideally I want
to send some commands to the UPS after hibernation has
been completed (since I don't know how much time it
will require to hibernate), but before the machine
will be turned off by the kernel.  Or at the very least,
to be able to stop the kernel turning the machine off
after hibernation process is complete - this way,
I can order the UPS to turn the power off after some
delay and hope hibernation process will finish when
the UPS will finally cut the power (not all UPSes
are able to do timely shutdown like this).

What's my way here?

Thanks!

/mjt

P.S.  Surprisingly, there's NO software that works
with UPSes and implements even the basic shutdown
process completely (not even mentioning hibernation).
Most common is just to turn the system off without
touching the UPS.  Yes it will work (till the UPS
will run out of battery), but how about servers which
should be up-n-running, ie. which should restart
automatically?..  Oh well.
