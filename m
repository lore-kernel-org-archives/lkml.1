Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYJ3ROz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYJ3ROz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYJ3ROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:14:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47327 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYJ3ROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:14:46 -0400
Message-ID: <4909EB4B.3090300@oracle.com>
Date: Thu, 30 Oct 2008 10:13:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file documentation
 v2
References: <20081030151712.GO771@redhat.com> <20081030091921.79c04ec6.randy.dunlap@oracle.com> <20081030170850.GQ771@redhat.com>
In-Reply-To: <20081030170850.GQ771@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski wrote:
> This patch updates the /proc/sys/kernel/nmi_watchdog documentation.
> Updated: included Randy Dunlap's corrections.
>  
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  Documentation/filesystems/proc.txt |   11 +++++++----
>  Documentation/nmi_watchdog.txt     |    5 +++++
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> --- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
> +++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-30 13:05:46.000000000 -0400
> @@ -69,6 +69,11 @@ to the overall system performance.
>  On x86 nmi_watchdog is disabled by default so you have to enable it with
>  a boot time parameter.
>  
> +It's possible to disable the NMI watchdog in run-time by writing "0" to
> +/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
> +the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
> +at boot time.
> +
>  NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
>  on x86 SMP boxes.
>  
> --- linus-2.6.orig/Documentation/filesystems/proc.txt	2008-10-24 11:41:28.000000000 -0400
> +++ linus-2.6/Documentation/filesystems/proc.txt	2008-10-30 13:05:31.000000000 -0400
> @@ -1338,10 +1338,13 @@ nmi_watchdog
>  
>  Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
>  the NMI watchdog is enabled and will continuously test all online cpus to
> -determine whether or not they are still functioning properly.
> -
> -Because the NMI watchdog shares registers with oprofile, by disabling the NMI
> -watchdog, oprofile may have more registers to utilize.
> +determine whether or not they are still functioning properly. Currently,
> +passing "nmi_watchdog=" parameter at boot time is required for this function
> +to work.
> +
> +If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
> +NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
> +oprofile may have more registers to utilize.
>  
>  msgmni
>  ------

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

-- 
~Randy
