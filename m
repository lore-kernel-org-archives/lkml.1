Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYBUO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYBUO5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYBUO5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:57:04 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59711 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYBUO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:57:01 -0500
Message-ID: <47BD9028.3080103@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 20:22:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: Pavel Machek <pavel@ucw.cz>, Jan Engelhardt <jengelh@computergmbh.de>,
       John Stoffel <john@stoffel.org>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com> <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr> <20080220181911.GA4760@ucw.cz> <Pine.LNX.4.64.0802201927440.26109@fbirervta.pbzchgretzou.qr> <20080220185104.GA30416@elf.ucw.cz> <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com>
In-Reply-To: <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>>  > >> For ordinary desktop people, memory controller is what developers
>>  > >> know as MMU or sometimes even some other mysterious piece of silicon
>>  > >> inside the heavy box.
>>  > >
>>  > >Actually I'd guess 'memory controller' == 'DRAM controller' == part of
>>  > >northbridge that talks to DRAM.
>>  >
>>  > Yeah that must have been it when Windows says it found a new controller
>>  > after changing the mainboard underneath.
>>
>>  Just for fun... this option really has to be renamed:
> 
> I think one reason of many people easy confusion is caused by bad menu
> hierarchy.
> I popose mem-cgroup move to child of cgroup and resource counter
> (= obey denend on).
> 
> if you don't mind, please try to following patch.
> may be, looks good than before.
> 

Sure makes sense

> ---
>  init/Kconfig |   52 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> Index: b/init/Kconfig
> ===================================================================
> --- a/init/Kconfig	2008-02-17 16:44:46.000000000 +0900
> +++ b/init/Kconfig	2008-02-21 23:33:51.000000000 +0900
> @@ -311,6 +311,32 @@ config CPUSETS
> 
>  	  Say N if unsure.
> 
> +config PROC_PID_CPUSET
> +	bool "Include legacy /proc/<pid>/cpuset file"
> +	depends on CPUSETS
> +	default y
> +
> +config CGROUP_CPUACCT
> +	bool "Simple CPU accounting cgroup subsystem"
> +	depends on CGROUPS
> +	help
> +	  Provides a simple Resource Controller for monitoring the
> +	  total CPU consumed by the tasks in a cgroup
> +
> +config RESOURCE_COUNTERS
> +	bool "Resource counters"
> +	help
> +	  This option enables controller independent resource accounting
> +          infrastructure that works with cgroups
> +	depends on CGROUPS
> +
> +config CGROUP_MEM_CONT
> +	bool "Memory controller for cgroups"
> +	depends on CGROUPS && RESOURCE_COUNTERS
> +	help
> +	  Provides a memory controller that manages both page cache and
> +	  RSS memory.
> +

We have some more changes planned for the text and renames planned, including
calling the component as a memory resource controller. The menu changes make
sense, so feel free to push them

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

>  config GROUP_SCHED
>  	bool "Group CPU scheduler"
>  	default y
> @@ -352,20 +378,6 @@ config CGROUP_SCHED
> 
>  endchoice
> 
> -config CGROUP_CPUACCT
> -	bool "Simple CPU accounting cgroup subsystem"
> -	depends on CGROUPS
> -	help
> -	  Provides a simple Resource Controller for monitoring the
> -	  total CPU consumed by the tasks in a cgroup
> -
> -config RESOURCE_COUNTERS
> -	bool "Resource counters"
> -	help
> -	  This option enables controller independent resource accounting
> -          infrastructure that works with cgroups
> -	depends on CGROUPS
> -
>  config SYSFS_DEPRECATED
>  	bool "Create deprecated sysfs files"
>  	depends on SYSFS
> @@ -387,18 +399,6 @@ config SYSFS_DEPRECATED
>  	  If you are using a distro that was released in 2006 or later,
>  	  it should be safe to say N here.
> 
> -config CGROUP_MEM_CONT
> -	bool "Memory controller for cgroups"
> -	depends on CGROUPS && RESOURCE_COUNTERS
> -	help
> -	  Provides a memory controller that manages both page cache and
> -	  RSS memory.
> -
> -config PROC_PID_CPUSET
> -	bool "Include legacy /proc/<pid>/cpuset file"
> -	depends on CPUSETS
> -	default y
> -
>  config RELAY
>  	bool "Kernel->user space relay support (formerly relayfs)"
>  	help


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
