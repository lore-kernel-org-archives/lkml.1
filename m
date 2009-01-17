Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbZAQTsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbZAQTsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbZAQTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:48:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932418AbZAQTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:48:33 -0500
Message-ID: <49723602.4090202@sgi.com>
Date: Sat, 17 Jan 2009 11:48:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
References: <20090113081316.GA2292@elf.ucw.cz> <20090116104455.GA3283@elf.ucw.cz> <200901171546.15987.borntraeger@de.ibm.com> <200901171648.34155.borntraeger@de.ibm.com>
In-Reply-To: <200901171648.34155.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
>> commit e39ad415ac15116df213dfa2aa2a4f1b0857af9c
>> Author: Mike Travis <travis@sgi.com>
>> Date:   Sun Jan 4 05:18:10 2009 -0800
>>
>>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
>>
>> makes cpu hotplug working again. Resume from suspend to ram is still broken
>> on my Thinkpad. Looks like there is yet another patch to find....
>>
>> Ingo, Mike: reverting e39ad415ac15116df213dfa2aa2a4f1b0857af9c fixes cpu
>> hotplug on my thinkpad. Any idea how to proceed? Should we revert that
>> patch in Linus git until we know what was wrong?
> 
> I forgot to revert the usb patch.
> Current status:
> 2.6.29-rc2 + 
> reverted e39ad415ac15116df213dfa2aa2a4f1b0857af9c (cpumask: use work_on_cpu in 
> acpi-cpufreq.c for read_measured_perf_ctrs) + 
> reverted a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 (USB: fix up suspend and 
> resume for PCI host controllers)
> 
> has a working suspend to ram on my T61p. With any of these two patches not 
> reverted resume hangs.
> 
> Christian

Could you try one more experiment?  With your working system, please cherry
pick these commits and try it again?

68564a4... work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
e1d9ec6... work_on_cpu: Use our own workqueue.
6eb714c... cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

>From git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git

If that works, then try and un-revert e39ad415ac and see if it's fixed as well?

(The underlying work_on_cpu() function was causing these problems, but the 1st two
of the above should fix it.)

Thanks!
Mike
