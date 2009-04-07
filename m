Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbZDGT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbZDGT1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZDGT1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:27:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZDGT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:27:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49DBA821.1070408@s5r6.in-berlin.de>
Date: Tue, 07 Apr 2009 21:23:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot (was Re: 2.6.29-git13:
 	Reported regressions from 2.6.28)
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>	 <49DB7C77.1000702@s5r6.in-berlin.de>	 <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>	 <49DB8909.3000905@s5r6.in-berlin.de> <9b1675090904071122k6a53295fwfffc336011edee8e@mail.gmail.com>
In-Reply-To: <9b1675090904071122k6a53295fwfffc336011edee8e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trenton D. Adams wrote:
> On Tue, Apr 7, 2009 at 11:10 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>>>> http://bugs.gentoo.org/show_bug.cgi?id=253535
>> Interdependencies between ALSA modules have changed.  The Gentoo init
>> scripts attempted to unload them in an order which deadlocked modprobe
>> due to dependencies.  The fix for Gentoo is to just not unload the
>> modules on system shutdown.  My Gentoo/amd64 Mac mini was affected by
>> this too; fixed by userland update.
>>
> 
> While that is interesting, I am not seeing that problem on my Gentoo
> box (the macbook), which is completely up-to-date.  2.6.28 works, and
> 2.6.29 doesn't.  Same init scripts, different kernels.

Note that the respective update changed /etc/conf.d/alsasound (a local
configuration file) to include
UNLOAD_ON_STOP="no"
KILLPROC_ON_STOP="no"
This change by update is not activated by a mere emerge; one needs to
incorporate that change with dispatch-conf or an equivalent method.
(Or simply edit the file to have these variables set to "no".)

> And sure, I could put a comment on the rmmod, in the init script, but
> IMO that would be a hack around a _bug_.  Which is fine for me.  But,
> is it worth leaving the issue in the kernel?

Is it a kernel issue if a script attempts to unload a busy module, then
fails to proceed?  I wouldn't think so.

But more importantly, is this init scripts related bug really what's
happening at your system?  Or do you actually experience an entirely
different bug?
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
