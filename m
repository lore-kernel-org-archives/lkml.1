Return-Path: <linux-kernel-owner+w=401wt.eu-S1764781AbXGaV5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764781AbXGaV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763261AbXGaV5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:57:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481AbXGaV47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:56:59 -0400
Date: Tue, 31 Jul 2007 17:56:09 -0400
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pm_trace displays the wrong time from the RTC
Message-ID: <20070731215609.GB31045@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <46AFA78A.9010904@redhat.com> <20070731143939.774eb9db.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731143939.774eb9db.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 02:39:39PM -0700, Randy Dunlap wrote:
 > On Tue, 31 Jul 2007 17:20:10 -0400 Chuck Ebbert wrote:

 > > include/asm-generic/rtc.h:
 > > 102         /*
 > > 103          * Account for differences between how the RTC uses the values
 > > 104          * and how they are defined in a struct rtc_time;
 > > 105          */
 > > 106         if (time->tm_year <= 69)
 > > 107                 time->tm_year += 100;
 > > 108 
 > > 109         time->tm_mon--;
 > 
 > 
 > That's this config option (read all of it):
 > 
 > config PM_TRACE
 > 	bool "Suspend/resume event tracing"
 > 	depends on PM_DEBUG && X86 && EXPERIMENTAL
 > 	default n
 > 	---help---
 > 	This enables some cheesy code to save the last PM event point in the
 > 	RTC across reboots, so that you can debug a machine that just hangs
 > 	during suspend (or more commonly, during resume).
 > 
 > 	To use this debugging feature you should attempt to suspend the machine,
 > 	then reboot it, then run
 > 
 > 		dmesg -s 1000000 | grep 'hash matches'
 > 
 > 	CAUTION: this option will cause your machine's real-time clock to be
 > 	set to an invalid time after a resume.

Doesn't this only take effect if you've been poking /sys/power/pm_trace though ?
Also, look at the date in the output from Chuck. It looks like only the
year is wrong.  I'd have expected more than just the century byte to have been
corrupted.

That +100 heuristic seems really odd to me.  Possibly it needs to be
checking if the century byte is set/unset, or it needs additional
clamping to make sure it doesn't overflow.

	Dave

-- 
http://www.codemonkey.org.uk
