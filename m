Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXHYAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXHYAIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXHYAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:08:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522AbXHYAIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:08:20 -0400
Date: Fri, 24 Aug 2007 17:07:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070824170702.a2c51084.akpm@linux-foundation.org>
In-Reply-To: <46CF695D.1020008@imap.cc>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CF695D.1020008@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 01:27:25 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 22.08.2007 11:06 schrieb Andrew Morton:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> After applying Matthew Wilcox' patch to include/linux/isa.h

which patch is that?

> this compiles
> and boots on my Intel/openSUSE 10.2 test machine but throws out the
> following messages I don't remember ever seeing with other kernels:
> 
> - on console early during boot, also in SuSE's /var/log/boot.msg:
> 
> your system time is not correct:
> Wed Jul 13 13:15:31 UTC 1910
> setting system time to:
> Tue Jul 24 00:00:00 UTC 2007

What architecture?

if x86_64 then perhaps something went wrong with the old x86_64 dynticks
leftovers which were in rc3-mm1.  I've just merged a shiny fresh new series
so perhaps things there got fixed.  Please retest next -mm.

Suitable cc's added.

> - later, dto. on console and in /var/log/boot.msg:
> 
> FATAL: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/processor.ko): Input/output error
> WARNING: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/processor.ko): Input/output error
> FATAL: Error inserting thermal (/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/thermal.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> 
> - apparently corresponding to that, in dmesg:
> 
> <4>[    7.691865] thermal: Unknown symbol acpi_processor_set_thermal_limit

acpi cc's added

> - from fsck during boot:
> 
> /dev/system/root: Superblock last mount time is in the future.  FIXED.
> /dev/system/root: Superblock last write time is in the future.  FIXED.

Presumably related to the time problem.

> - in /var/log/warn:
> 
> Aug 25 00:44:00 xenon powersaved[5356]: WARNING (CpufreqManagement:51) No capability cpufreq_control
> Aug 25 00:44:00 xenon powersaved[5356]: WARNING (CpufreqManagement:51) No capability cpufreq_control

Dunno, there're some significant-looking cpufreq changes in there, such as
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch.
Maybe we went and chose a different governor for you?

Perhaps it would be helpful if you could do a 

	diff -u dmesg-2.6.23-rc3 dmesg-2.6.26-rc3-mm1

?


> And the SUSE startup sequence displays "failed" for the acpid daemon.
> So it seems there is some strangeness wrt to system time and power
> management. I don't have the time to bisect this right now, but
> wanted to let you know anyway.
> 
> Apart from that, the kernel seems to work fine.

OK, thanks.
