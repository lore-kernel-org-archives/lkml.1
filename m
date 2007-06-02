Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbXFBV2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbXFBV2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbXFBV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:27:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbXFBV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:27:51 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
To: Tejun Heo <htejun@gmail.com>, David Greaves <david@dgreaves.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Reply-To: 7eggert@gmx.de
Date: Sat, 02 Jun 2007 23:27:40 +0200
References: <8rnax-6XX-11@gated-at.bofh.it> <8rA7H-1B4-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hub8O-0000rF-Hb@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+ccNj9Gbj6IsEmMUUAogogFb9hdyacWBb9pc4
 FrYpsvstiusTq7GKqYSUW2K91MOSm2ya4mQFGeMwLMe3m9WqNl
 Xr4sMmYUXNNDMyQNnpg6w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> David Greaves wrote:

>> I have 2 ide disks. If I enable SMART and hibernate/suspend2disk, SMART is
>> disabled when I resume.

<snip>

Maybe it's disabled by the BIOS?

> According to the ATA standard, the device (drive) itself is responsible
> for preserving SMART enabled status over power cycles.  It seems your
> drive doesn't wanna do that.  I don't think mangling with SMART setup in
> the kernel is wise thing to do.  Bruce, any ideas?  Maybe hook smartd
> such that it gets suspend/resume events?

1) Enabling smart is a single command
2) The command should not fail, and if it fails, it's probably because
   it's not supported. There is nothing userspace can do better or worse.
3) There should be no bad effect from enabling smart, except if the BIOS
   insists on not booting because of a bad RAID disk. (That's why I like
   to disable it in the BIOS)
4) Not enabling smart is a common failure in many setups. Usurally the admin
   will have to enumerate the attached disks and patch the smartctl startup
   scripts.
5) Sometimes there is no smartd (or udev) running, and you'll still not want
   to re-enable smart each time you suspend.
6) A simple udev rule or smartd hook should be bigger than the code required
   in-kernel.

Therefore I suggest setting the smart-enabled-bit in the kernel, in spite of
not being the kernel's duty. It would be a 99,99% DTRT.

OTOH: What would happen if the drive's command queue is full?
What happens for DMA handling (can we hitch-hike)?
Is it possible to just enqueue "enable_smart($DEV)"?

-- 
Top 100 things you don't want the sysadmin to say:
48. Tell me again what that '-r' option to rm does

Friﬂ, Spammer: VmngZze7@fc.7eggert.dyndns.org EPlKiav@7eggert.dyndns.org
