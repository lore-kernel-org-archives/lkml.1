Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYEFHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYEFHN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYEFHNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:13:19 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:59517 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYEFHNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:13:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Greg KH <gregkh@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi_cpu_freq_init warning...
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com>
	<87k5i8hrmk.fsf@duaron.myhome.or.jp> <20080506064741.GA6062@suse.de>
Date: Tue, 06 May 2008 16:13:11 +0900
In-Reply-To: <20080506064741.GA6062@suse.de> (Greg KH's message of "Mon, 5 May
	2008 23:47:41 -0700")
Message-ID: <87prrzdhx4.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, May 06, 2008 at 03:29:55PM +0900, OGAWA Hirofumi wrote:
>> > calling  acpi_cpufreq_init+0x0/0x68()
>> > sysdev: class cpu: driver (ffffffff80da0110) has already been
>> > registered to a class, something is wrong, but will forge on!
>> > ------------[ cut here ]------------
>> > WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x82/0x150()
>> > Modules linked in:
>> > Pid: 1, comm: swapper Not tainted
>> > 2.6.26-rc1-sched-devel.git-x86-latest.git-00485-g253148c-dirty #333
>> 
>> I've seen this too. The following patch seems to work for me.
>> -- 
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> 
>> 
>> [PATCH] Fix bogus warning in sysdev_driver_register()
>> 
>> 	if ((drv->entry.next != drv->entry.prev) ||
>> 	    (drv->entry.next != NULL)) {
>> 
>> warns list_empty(&drv->entry).
>
> should we just call list_empty() here to make sure it is correct?

Unfortunately we can't. drv->entry is initialized by NULL like following.

static struct sysdev_driver cpufreq_sysdev_driver = {
	.add		= cpufreq_add_dev,
	.remove		= cpufreq_remove_dev,
	.suspend	= cpufreq_suspend,
	.resume		= cpufreq_resume,
};

I assumed this (for compatible) is an intent.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
