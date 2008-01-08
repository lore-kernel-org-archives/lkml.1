Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYAHSVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYAHSVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYAHSVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:21:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYAHSU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:20:59 -0500
Date: Tue, 8 Jan 2008 19:20:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tuomo Valkonen <tuomov@iki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo7drr.c37.tuomov@jolt.modeemi.cs.tut.fi>
Message-ID: <Pine.LNX.4.64.0801081912230.3032@fbirervta.pbzchgretzou.qr>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
 <Pine.LNX.4.64.0801081725480.3032@fbirervta.pbzchgretzou.qr>
 <slrnfo7aiq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
 <Pine.LNX.4.64.0801081801300.3032@fbirervta.pbzchgretzou.qr>
 <slrnfo7drr.c37.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8 2008 17:48, Tuomo Valkonen wrote:
>
>> You can guess my answer: udev will fix it. 
>
>And break everything else, such as my symlinks, permissions, etc. 
>I'm not going to learn its cryptic special-case config files for 
>such trivial tasks as creating a fucking symlink or change the 
>permissions of a file, for which exist general purpose methods:
>chmod, chown, ln -s.

So create /sdev and fill it with all the device nodes that you deem
static and worthy of chowning. As far as sound goes, /dev/dsp and
/dev/snd/* is made writable by something called resmgr+hal+hal_resmgr
(yes, more clutter!). I have not worried about device permissions
in a long time. The only exception is vmware, but that is its very
own problem.

>> Mine plays very well.
>
>I was not talking of encrypted disks but cryptic udev config files,
>that the distros are going to break on every upgrade.

If yours does, then that is bad luck. Mine (again) does not.
That is what a distro is supposed to bring: a system that does not
break ("as much", if you like the extra) on an upgrade as if you
did upgrade software and such by hand.

>> May I remind you that the kernel also "loses" all your network interface 
>> configuration, routes, firewalling rules and all sysctl settings at 
>> boot (sic: reboot & powerdown).
>
>But traditional /dev does not lose permissions and symlinks. udev 
>tmpfs shadow brain damage does. You have to illogically and
>inconveniently edit udev's cryptic config files instead, and yet
>it in no way stops /dev from being modified.

If you dislike udev so much, why don't you just add

	chmod 666 /dev/*

to /etc/init.d/boot.local...

>> Distros have to decide whether to
>>
>> - not autoload a zillion of modules, potentially generating lots of 
>> crying "idiot" users
>>
>> - autoload a zillion of modules, potentially firing you up.
>
>And they most of them cater for idiot users, and the rest for
>develors what want to do it all from scratch. Mere power users
>who want to tune the system to their needs, but easily and without
>WIMPshit (through _simple_ self-documenting configuration files),
>are forgotten these days.

ISTR that most Windows programs do not even have a configuration
file, but store their bits and pieces in the *even more cryptic*
thing they call Registry. Do you prefer _that_?

>> Nonsense. The kernel notices udev about all available hardware and udev 
>> will load modules. It has nothing to do with initrd, in fact, this very 
>> step of loading a gazillion of modules is done after initrd has passed 
>> control on to /sbin/init. At least, in opensuse.
>
>I've never seen a system that would do so.

You just did not use the right distribution yet.
