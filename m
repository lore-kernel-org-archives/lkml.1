Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZDGQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZDGQTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZDGQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:18:49 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44942 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZDGQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:18:47 -0400
Message-ID: <49DB7C77.1000702@s5r6.in-berlin.de>
Date: Tue, 07 Apr 2009 18:16:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Trenton Adams <trenton.d.adams@gmail.com>
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
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13018
>> Subject		: 2.6.29 on MacBook 2,1 fails to reboot
>> Submitter	: Trenton Adams <trenton.d.adams@gmail.com>
>> Date		: 2009-03-30 2:04 (8 days old)
>> References	: http://marc.info/?l=linux-kernel&m=123837870307249&w=4
>> Handled-By	: "Morten P.D. Stevens" <mstevens@win-professional.com>
> 
> This went through bisection, but looking at the email log, I tend to 
> suspect that maybe Trenton marked some versions good even though they 
> weren't (because they got versions numbers from v2.6.27), and didn't 
> realize that that messes up bisection in a big way.
> 
> The bug _sounds_ like some deadlock due to lock problems - the shutdown 
> path often triggers locks that no other path really cares about. And we 
> had some lock problems in the sound subsystem that got fixed post-2.6.28, 
> for example. 
> 
> And it looks like the problem is somewhere in sound shutdown:
> 
> 12181 delete_module("snd_hda_codec", O_RDONLY|O_EXCL) = -1 EAGAIN (Resource temporarily unavailable) <0.000011>
> 
> So commits like 91054598f794fb5d8a0b1e747ff8e2e8fc2115b3 ("ALSA: pcm_oss, 
> fix locking typo") might explain it.

Trenton,
could it be the same as this one?
http://bugzilla.kernel.org/show_bug.cgi?id=12321
"System hangs when unloading alsa modules"
http://bugs.gentoo.org/show_bug.cgi?id=253535
"System hangs when unloading alsa modules on Kernel >2.6.28"
-- 
Stefan Richter
-=====-==--= -=-- --===
http://arcgraph.de/sr/
