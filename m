Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYJ3Pp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYJ3Pp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJ3Ppo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:45:44 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:31334 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYJ3Ppn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9V3Vt1fQHe8WIOWJ3UuKtVFln5XLAGdWRyUaJGZmVqFZFEB7cmSKRvaiiwU0JIb4w
         BEuhHaYt6zKt470xjFuuMuT5kw/9aRmUV+5jJ19t7AJzqLpynDSZ6nRMQ0p1OLDQ2EiE
         fSJmSRTfLBu7MMvC1nye14Ziihtv0bhMxHH0M=
Date: Thu, 30 Oct 2008 18:45:34 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
	documentation
Message-ID: <20081030154534.GA19888@localhost>
References: <20081030151712.GO771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030151712.GO771@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Aristeu Rozanski - Thu, Oct 30, 2008 at 11:17:14AM -0400]
| This patch updates the /proc/sys/kernel/nmi_watchdog documentation.
| 
| Signed-off-by: Aristeu Rozanski <aris@redhat.com>
| 
| ---
|  Documentation/filesystems/proc.txt |   13 ++++++++-----
|  Documentation/nmi_watchdog.txt     |    5 +++++
|  2 files changed, 13 insertions(+), 5 deletions(-)
| 
| --- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
| +++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-29 16:38:12.000000000 -0400
| @@ -69,6 +69,11 @@ to the overall system performance.
|  On x86 nmi_watchdog is disabled by default so you have to enable it with
|  a boot time parameter.
|  
| +It's possible to disable the NMI watchdog in run-time by writing "0" to
| +/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
| +the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
| +in boot time.
| +
|  NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
|  on x86 SMP boxes.
|  
| --- linus-2.6.orig/Documentation/filesystems/proc.txt	2008-10-24 11:41:28.000000000 -0400
| +++ linus-2.6/Documentation/filesystems/proc.txt	2008-10-30 11:16:36.000000000 -0400
| @@ -1336,12 +1336,15 @@ panic controls already in that directory
|  nmi_watchdog
|  ------------
|  
| -Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
| +Enables/Disables the NMI watchdog on x86 systems. When the value is non-zero
|  the NMI watchdog is enabled and will continuously test all online cpus to
| -determine whether or not they are still functioning properly.
| -
| -Because the NMI watchdog shares registers with oprofile, by disabling the NMI
| -watchdog, oprofile may have more registers to utilize.
| +determine whether or not they are still functioning properly. Currently,
| +passing "nmi_watchdog=" parameter in boot time is required for this function
| +to work.
| +
| +If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
| +NMI watchdog shares registers with oprofile, by disabling the NMI watchdog,
| +oprofile may have more registers to utilize.
|  
|  msgmni
|  ------
| 

Hi Aristeu,

by reading this patch I found that maybe it's time to start
using nmi_watchdog=[lapic,ioapic] instead of 1 and 2? We could make
them as alases to existing numbers. Thoughts?

		- Cyrill -
