Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXA1ToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXA1ToW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbXA1ToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:44:22 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22114 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbXA1ToV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:44:21 -0500
Message-ID: <45BCFD10.4070302@tls.msk.ru>
Date: Sun, 28 Jan 2007 22:44:16 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
References: <593246.19408.qm@web52505.mail.yahoo.com> <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr> <45BC6740.1000606@tls.msk.ru> <Pine.LNX.4.61.0701281327180.22295@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701281327180.22295@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 28 2007 12:05, Michael Tokarev wrote:
[]
>> Mdadm creates those nodes automa[tg]ically - man mdadm, search for --auto.
> 
> Note that `mdadm -As` _is_ run on FC6 boot.

See above -- man mdadm, search for --auto.  -A = --assemble, -s = --scan.

>> In order for an md array to be started up on boot, it has to be specified
>> in /etc/mdadm.conf.  With proper DEVICE line in there.  That's all.
> 
> That's how it is, and it does not work.

Sure.  Because of this missing --auto flag.

> openSUSE 10.2:
> no mdadm.conf _at all_, /etc/init.d/boot.d/boot.md is chkconfig'ed _out_,
> _no_ md kernel module is loaded, and I still have all the /dev/md nodes.

And no udev.  Or, alternatively, *all* md devices are created by some other
script or somesuch.  There's No Magic (tm).

[]
> # mdadm -C /dev/md1 -e 1.0 -l 1 -n 2 /dev/sdb2 /dev/sdc2
> mdadm: error opening /dev/md1: No such file or directory
> 
> Showstopper.

Nonsense.  See above again, man mdadm, search for --auto.

[]
> You see, I have all the reason to be confused.

Yeah, this is quite... confusing.

It's all due to the way how mdadm iteracts with the kernel and how
udev works - all together.  The thing is - in order to assemble an
array, proper device node has to be in place.  But udev wont create
it until array is assembled.  Chicken&eggs problem.

Exactly due to this, the node(s) can be created with mdadm (with --auto
option, whicih can be specified in mdadm.conf too), AND/OR with some
startup script before invoking mdadm, AND/OR when the system isn't
broken by udevd (with ol'good static /dev).

>> But in any case, this has exactly nothing to do with kernel.
>> It's 100% userspace issues, I'd say distribution-specific issues.

..And each distribution uses its own kludge/workaround/solution for
this stuff - which you demonstrated... ;)

/mjt
