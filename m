Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZFVRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZFVRcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbZFVRbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:31:55 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56553 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbZFVRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:31:52 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz154dM1432R1417L98dR1805Mzz1202hzzz2fh6bh17ch62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
Message-ID: <4A3FBFF0.40006@am.sony.com>
Date: Mon, 22 Jun 2009 10:31:28 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marco Stornelli <marco.stornelli@gmail.com>,
       Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz>
In-Reply-To: <20090622172003.GB21149@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 17:31:29.0514 (UTC) FILETIME=[46FC1CA0:01C9F35F]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>> How do you handle hard-links, then?
>> Indeed hard-links are not supported :) Due to the design of this fs
>> there are some limitations explained in the documentation as not
>> hard-link, only private memory mapping and so on. However this
>> limitations don't limit the fs itself because you must consider the
>> special goal of this fs.
> 
> I did not see that in the changelog. If it is not general purpose
> filesystem, it is lot less interesting.

PRAMFS is not a general purpose filesystem. Please read
the introductory post to this thread, or look at
http://pramfs.sourceforge.net/ for more information.

Since the purpose of PRAMFS is to provide a filesystem
that is persistent across kernel instantions, it is not
designed for high speed.  Robustness in the face of
kernel crashes or bugs is the highest priority, so
PRAMFS has significant overhead to make the window
of writability to the filesystem RAM as small as possible.

This is not a file system one would do kernel compiles on.
This is where someone would keep a small amount of sensitive
data, or crash logs that one needed to preserve over kernel
invocations.

> 
>>>> >From performance point of view:
>>>>
>>>> Sometimes ago I uploaded here (http://elinux.org/Pram_Fs) some benchmark
>>>> results to compare the performance with and without XIP in a real
>>>> embedded environment with bonnie++. You could use it as reference point.
>>> Well, so XIP helps. ext2 can do XIP too, IIRC. Is your performance
>>> better than ext2?
>>>
>>> Wait... those numbers you pointed me... claim to be as slow as
>>> 13MB/sec. That's very very bad. My harddrive is faster than that.
>> As I said I did the test in a real embedded environment so to have
>> comparable result you should use the same environmente with the same
>> tools, with the same workload and so on.
> 
> Even on real embedded hardware you should get better than 13MB/sec
> writing to _RAM_. I guess something is seriously wrong with pramfs.

See above.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

