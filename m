Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYCMQOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYCMQOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYCMQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:13:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYCMQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:13:57 -0400
Date: Thu, 13 Mar 2008 09:12:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-mm1 shutdown crash
Message-Id: <20080313091250.33faaa59.akpm@linux-foundation.org>
In-Reply-To: <47D93435.1080402@aitel.hist.no>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<47D93435.1080402@aitel.hist.no>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 15:03:33 +0100 Helge Hafting <helge.hafting@aitel.hist.no> wrote:

> This kernel hangs during shutdown, and that prevents automatic poweroff.
> I have one small patch that improves the iwl3945 wireless driver a little.
> Dell D830 laptop, 64-bit smp
> 
> 
> It looks like this:
> *** Last service has quit. ***
> Your system will now POWER OFF!
> Goodbye
> Bug: unable to handle kernel paging request at ffffffff8020a7ad
> IP: [<ffffffff80211b5a>] text_poke+0xe/0x15
> PGD 203067 PUD 2+7+63 PMD 7f3ba163 PTE 20a161
> Oops: 0003 [1] SMP
> last sysfs file: 
> /sys/devices/LNXSYSTM:00/device:00/ACPI0003:00/power_supply/AC/online
> CPU 0
> Modules linked in: tun pcmcia dock piix iTCO_wdt ata_piix watchdog_core 
> watchdog_dev intel_agp ata_generic hci_usb
> 
> Pid: 7606, comm: initng Not tainted 2.6.25-rc5-mm1
> 
> RIP: 0010:[<ffffffff80211b5a>] [<ffffffff80211b5a>]text_poke+0xe/0x15
> RSP: 0000:ffff81007e559cb8 EFLAGS: 00010083
> 
> (register dump omitted, but I can reproduce anytime if it matters)
> Process initng (pid 7606, threadinfo...)
> call trace:
> alternatives_smp_unlock
> alternatives_smp_switch
> ? schedule_timeout
> __cpu_die
> _cpu_down
> disable_nonboot_cpus
> kernel_power_off
> sys_reboot
> ? handle_mm_fault
> ? __up_read
> ? do_page_fault
> ? __put_user
> ? error_exit
> system_call_after_swapgs

Yes, I was hitting the text_poke() oops with 2.6.25-rc3-mm1 but not with
2.6.25-rc5-mm1.

This _might_ have been due to a snafu in git-x86: it had a [patch 2/2] from
Mathieu but was missing the needed [patch 1/2].  But I don't know if this
was the cause and I don't know whether 2.6.25-rc3-mm1's git-x86 had the
same problem.

