Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXDACZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXDACZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 22:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXDACZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 22:25:26 -0400
Received: from raven.upol.cz ([158.194.120.4]:34522 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXDACZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 22:25:25 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eduard Bloch <edi@gmx.de>, linux-kernel@vger.kernel.org,
       debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
In-Reply-To: <20070401011452.7c0cbce9@the-village.bc.nu>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu> <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de> <20070331232002.7b478f37@the-village.bc.nu> <20070331224021.GA6488@rotes76.wohnheim.uni-kl.de> <20070401011452.7c0cbce9@the-village.bc.nu>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed + slrn/0.9.8.1pl1 (x86_64-pc-linux-gnu-debian)
Date: Sun, 1 Apr 2007 04:34:16 +0200
Message-Id: <E1HXptY-00017P-FP@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alan Cox
> Newsgroups: gmane.linux.kernel
> Subject: Re: broken device locking, sg vs. sg_io on block devices
> Date: Sun, 1 Apr 2007 01:14:52 +0100
>
[]
>> Again, it doesn't have to. It can pass the locking operations to the
>> related block device driver.
>
> No it can't. The driver has no idea what the locking rules are for
> arbitary command blocks send to arbitary devices. /dev/sg is a *raw*
> interface. You can send anything to anyone, and the locking rules for
> that are far too complex for a giant morass of kernel code to get added.
>
> The mess begins because you use /dev/sg and put it in a cdrom group
> instead of using SG_IO on the /dev/sr device.

(offtop: 'cdrom' is as ugly as 'floppy' for anything like usb,
firewire connected storage, why not use 'optics' and 'external' or
something?)

> The mess continues because of the user of O_EXCL locking thus forcing
> re-open/close by HAL

Manpage states something bad about it also...

> instead of fcntl based co-operative locking.

> > > getty/modem/uucp/terminal emulator/slip/ppp/..

Programs you've mentioned may have co-operative locking, but 'dd' or
'cat' have no knowledge of it for sure. Yet nothing prevents allowed user
program to use this tools on /dev/tty*.

AFAIK kernel developers are always ready for very broken userspace, yet
co-operative locking is a job of the userspace programmers of very
different tools.

> The job of the kernel is not and never has been to anticipate and correct
> everything stupid someone tries to do in user space.


> As I said before the people wanting to arbitrate serial ports got this
> right in the mid 1970's your situation is not much more complicated,

Do you mean co-operative locking or carrier detection as a pre-hotplug
thing (:?

Tell me, please, somebody, why non-exclusive co-operative locking (if it
was implemented anyways), racy and already used in userspace applications
O_EXCL are better than _mandatory locking_? I've found this helpful against
any broken userspace, trying hijack my device and read or write bytes
to it.
____
