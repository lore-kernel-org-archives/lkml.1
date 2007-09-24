Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbXIXRAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbXIXRAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbXIXRAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:00:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62773 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXIXRAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:00:15 -0400
Date: Mon, 24 Sep 2007 09:58:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vatsa@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 5/5] Add fair "control groups" scheduler
Message-Id: <20070924095815.9d5f7f32.randy.dunlap@oracle.com>
In-Reply-To: <20070924164159.GF10291@linux.vnet.ibm.com>
References: <20070924163326.GA10291@linux.vnet.ibm.com>
	<20070924164159.GF10291@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 22:11:59 +0530 Srivatsa Vaddagiri wrote:

>  include/linux/cgroup_subsys.h |    6 ++
>  init/Kconfig                  |   24 +++++---
>  kernel/sched.c                |  122 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+), 7 deletions(-)
> 
> Index: current/init/Kconfig
> ===================================================================
> --- current.orig/init/Kconfig
> +++ current/init/Kconfig
> @@ -327,13 +327,6 @@ config FAIR_GROUP_SCHED
>  	  This feature lets cpu scheduler recognize task groups and control cpu
>  	  bandwidth allocation to such task groups.
>  
> -config RESOURCE_COUNTERS
> -	bool "Resource counters"
> -	help
> -	  This option enables controller independent resource accounting
> -          infrastructure that works with cgroups
> -	depends on CGROUPS
> -
>  choice
>  	depends on FAIR_GROUP_SCHED
>  	prompt "Basis for grouping tasks"
> @@ -345,8 +338,25 @@ choice
>   		  This option will choose userid as the basis for grouping
>  		  tasks, thus providing equal cpu bandwidth to each user.
>  
> +	config FAIR_CGROUP_SCHED
> +		bool "Control groups"
> +		depends on CGROUPS
> +		help
> +		   This option allows you to create arbitrary task groups
> +		   using the "cgroup" psuedo filesystem and control
> +		   the cpu bandwidth allocated to each such task group.
> +		   Refer to Documentation/cgroups.txt for more information
> +		   on "cgroup" psuedo filesystem.

Too much indentation.

s/cpu/CPU/g please.

> +
>  endchoice
>  
> +config RESOURCE_COUNTERS
> +	bool "Resource counters"
> +	help
> +	  This option enables controller independent resource accounting
> +          infrastructure that works with cgroups

Use tab + 2 spaces to indent help text.


> +	depends on CGROUPS
> +
>  config SYSFS_DEPRECATED
>  	bool "Create deprecated sysfs files"
>  	default y


---
~Randy
Phaedrus says that Quality is about caring.
