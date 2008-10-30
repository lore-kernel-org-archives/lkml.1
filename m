Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYJ3QVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYJ3QVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYJ3QVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:21:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10864 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYJ3QVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:21:08 -0400
Date: Thu, 30 Oct 2008 09:19:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
 documentation
Message-Id: <20081030091921.79c04ec6.randy.dunlap@oracle.com>
In-Reply-To: <20081030151712.GO771@redhat.com>
References: <20081030151712.GO771@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 11:17:14 -0400 Aristeu Rozanski wrote:

> This patch updates the /proc/sys/kernel/nmi_watchdog documentation.
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  Documentation/filesystems/proc.txt |   13 ++++++++-----
>  Documentation/nmi_watchdog.txt     |    5 +++++
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> --- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
> +++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-29 16:38:12.000000000 -0400
> @@ -69,6 +69,11 @@ to the overall system performance.
>  On x86 nmi_watchdog is disabled by default so you have to enable it with
>  a boot time parameter.
>  
> +It's possible to disable the NMI watchdog in run-time by writing "0" to
> +/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
> +the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
> +in boot time.

   at boot time.

> +
>  NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
>  on x86 SMP boxes.
>  
> --- linus-2.6.orig/Documentation/filesystems/proc.txt	2008-10-24 11:41:28.000000000 -0400
> +++ linus-2.6/Documentation/filesystems/proc.txt	2008-10-30 11:16:36.000000000 -0400
> @@ -1336,12 +1336,15 @@ panic controls already in that directory
>  nmi_watchdog
>  ------------
>  
> -Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
> +Enables/Disables the NMI watchdog on x86 systems. When the value is non-zero

Two spaces after a '.' is OK, fwiw.

>  the NMI watchdog is enabled and will continuously test all online cpus to
> -determine whether or not they are still functioning properly.
> -
> -Because the NMI watchdog shares registers with oprofile, by disabling the NMI
> -watchdog, oprofile may have more registers to utilize.
> +determine whether or not they are still functioning properly. Currently,
> +passing "nmi_watchdog=" parameter in boot time is required for this function

                                     at
> +to work.
> +
> +If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
> +NMI watchdog shares registers with oprofile, by disabling the NMI watchdog,

Run-on sentence:      change to:      oprofile;
or to:                                oprofile.  By disabling ...

> +oprofile may have more registers to utilize.


Thanks for the updates.

---
~Randy
