Return-Path: <linux-kernel-owner+w=401wt.eu-S1751426AbZG3IcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbZG3IcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZG3IcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:32:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:49842 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZG3IcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:32:12 -0400
Message-ID: <4A715A7B.3070406@windriver.com>
Date: Thu, 30 Jul 2009 03:31:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Jun Koi <junkoi2004@gmail.com>, linux-kernel@vger.kernel.org,
       Bernhard Kaindl <bk@suse.de>,
       KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: Firewire debugging tools - firedump & fireproxy?
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com> <1248932218.27010.8.camel@maxim-laptop>
In-Reply-To: <1248932218.27010.8.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 08:31:54.0522 (UTC) FILETIME=[31AEDFA0:01CA10F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> On Sun, 2009-07-05 at 14:42 +0900, Jun Koi wrote:
>   
>> Hi,
>>
>> I am doing some debugging via firewire. I found some references to
>> some tools named firedump & fireproxy, made by Bernhard Kaindl,
>> supposed put at following addresses:
>>
>> ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
>> ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
>>
>> However, these URLs are nolonger available. I am wondering if they
>> have been moved to somewhere else? Anybody know?
>>
>>     
> Me having the same question. I have just bought everything for firewire
> debugging.
>
> Jason Wessel, what the fate of kgdbom ?
> (and kgdboe btw ....)
>
>   

kgdbom ?   I had heard of it in regard to fireproxy, but I have never
received any patches specific to a kgdbom implementation.  Should you or
anyone else create patches for kgdbom, please cc:
kgdb-bugreport@lists.sourceforge.net.

As for kgdboe, I do not find it to be extremely reliable.  It does exist
however in the kgdb development tree.  You can pick a kernel from
2.6.21-> latest. 

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=heads

In order to make kgdboe reliable it must get altered in one of several
ways before it would be robust enough for mainline kernel consideration. 

1) The key problem is that preemption of irq code causes locks to be
held which prevent operation of the polled ethernet driver.  This could
be be solved at the ethernet driver level by creating a polled interface
that has no requirement on any kind of locking.  I have yet to see an
ethernet driver with such an implementation.  Most if not all the polled
ethernet implementations make use of disable_irq() which is 1/2 the
battle, the other 1/2 being the spin locks or mutexs which can deadlock.

2) A possible (but not practical or desirable) solution would be to
change the kernel mechanism for synchronizing a driver or running a
thread to free a lock so as to safely use the ethernet driver for
another purpose.  This solution is not worth the time because the
possibility for deadlock is far too high.

3) Develop a low level dedicated ethernet debug interface.  If you have
more than one ethernet, or an ethernet device that has multiple hardware
queues, it is plausible to have a dedicated way to talk to a device
which has no restrictions on getting preempted, or used by another part
of the kernel.  This lends itself to an ideal medium for kgdb
communications.


Jason.
