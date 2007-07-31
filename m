Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbXGaVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbXGaVfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXGaVez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:34:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44616 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbXGaVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:34:53 -0400
Date: Tue, 31 Jul 2007 14:39:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pm_trace displays the wrong time from the RTC
Message-Id: <20070731143939.774eb9db.randy.dunlap@oracle.com>
In-Reply-To: <46AFA78A.9010904@redhat.com>
References: <46AFA78A.9010904@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 17:20:10 -0400 Chuck Ebbert wrote:

> When resuming, systems print this when booted on 07/31/07:
> 
> Date: 06/31/107
> 
> /drivers/base/power/trace.c::read_magic_time():
> 114	get_rtc_time(&time);
> 115	printk("Time: %2d:%02d:%02d Date: %02d/%02d/%02d\n",
> 116		time.tm_hour, time.tm_min, time.tm_sec,
> 117		time.tm_mon, time.tm_mday, time.tm_year);
> 
> include/asm-generic/rtc.h:
> 102         /*
> 103          * Account for differences between how the RTC uses the values
> 104          * and how they are defined in a struct rtc_time;
> 105          */
> 106         if (time->tm_year <= 69)
> 107                 time->tm_year += 100;
> 108 
> 109         time->tm_mon--;


That's this config option (read all of it):

config PM_TRACE
	bool "Suspend/resume event tracing"
	depends on PM_DEBUG && X86 && EXPERIMENTAL
	default n
	---help---
	This enables some cheesy code to save the last PM event point in the
	RTC across reboots, so that you can debug a machine that just hangs
	during suspend (or more commonly, during resume).

	To use this debugging feature you should attempt to suspend the machine,
	then reboot it, then run

		dmesg -s 1000000 | grep 'hash matches'

	CAUTION: this option will cause your machine's real-time clock to be
	set to an invalid time after a resume.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
