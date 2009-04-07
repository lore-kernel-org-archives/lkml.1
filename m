Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbZDGRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbZDGRPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZDGROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:14:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52183 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZDGROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:14:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49DB8909.3000905@s5r6.in-berlin.de>
Date: Tue, 07 Apr 2009 19:10:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: 2.6.29 on MacBook 2,1 fails to reboot (was Re: 2.6.29-git13: Reported
 regressions from 2.6.28)
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>	 <49DB7C77.1000702@s5r6.in-berlin.de> <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>
In-Reply-To: <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trenton D. Adams wrote:
> On Tue, Apr 7, 2009 at 10:16 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Linus Torvalds wrote:
>>> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13018
>>>> Subject              : 2.6.29 on MacBook 2,1 fails to reboot
...
>>> The bug _sounds_ like some deadlock due to lock problems - the shutdown 
>>> path often triggers locks that no other path really cares about. And we 
>>> had some lock problems in the sound subsystem that got fixed post-2.6.28, 
>>> for example. 
>>> 
>>> And it looks like the problem is somewhere in sound shutdown:
>>> 
>>> 12181 delete_module("snd_hda_codec", O_RDONLY|O_EXCL) = -1 EAGAIN (Resource temporarily unavailable) <0.000011>
>>> 
>>> So commits like 91054598f794fb5d8a0b1e747ff8e2e8fc2115b3 ("ALSA: pcm_oss, 
>>> fix locking typo") might explain it.
...
>> could it be the same as this one?
>> http://bugzilla.kernel.org/show_bug.cgi?id=12321
>> "System hangs when unloading alsa modules"
>> http://bugs.gentoo.org/show_bug.cgi?id=253535
>> "System hangs when unloading alsa modules on Kernel >2.6.28"
...
> The first one looks similar, if not identical.  The second one
> doesn't, because my problem happens on 2.6.29 only, not 2.6.28.

The Gentoo bug entry too is about a regression _after_ 2.6.28. :-)
I.e. 2.6.28.y. are unaffected.  It's actually just the downstream
duplicate of the kernel.org bug entry.

> Either way, the unload problem with the module didn't happen in
> 2.6.28.

Interdependencies between ALSA modules have changed.  The Gentoo init
scripts attempted to unload them in an order which deadlocked modprobe
due to dependencies.  The fix for Gentoo is to just not unload the
modules on system shutdown.  My Gentoo/amd64 Mac mini was affected by
this too; fixed by userland update.

(Added Cc to tiwai@suse.de)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
