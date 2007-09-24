Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXIXQzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXIXQzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbXIXQzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:55:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63486 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXIXQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:55:33 -0400
Date: Mon, 24 Sep 2007 09:53:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vatsa@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 3/5] Cleanup code under CONFIG_FAIR_GROUP_SCHED
Message-Id: <20070924095344.ee9ab10e.randy.dunlap@oracle.com>
In-Reply-To: <20070924163937.GD10291@linux.vnet.ibm.com>
References: <20070924163326.GA10291@linux.vnet.ibm.com>
	<20070924163937.GD10291@linux.vnet.ibm.com>
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

On Mon, 24 Sep 2007 22:09:37 +0530 Srivatsa Vaddagiri wrote:

> With the view of supporting user-id based fair scheduling (and not just
> container-based fair scheduling), this patch renames several functions
> and makes them independent of whether they are being used for container
> or user-id based fair scheduling.
> 
> Also fix a problem reported by KAMEZAWA Hiroyuki (wrt allocating
> less-sized array for tg->cfs_rq[] and tf->se[]).
> 
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by : Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> 
> ---
>  include/linux/sched.h |   12 +++
>  init/Kconfig          |   11 +--
>  kernel/sched.c        |  172 ++++++++++++++++++--------------------------------
>  kernel/sched_fair.c   |    5 +
>  4 files changed, 83 insertions(+), 117 deletions(-)
> 
> Index: current/init/Kconfig
> ===================================================================
> --- current.orig/init/Kconfig
> +++ current/init/Kconfig
> @@ -282,13 +282,12 @@ config CPUSETS
>  	  Say N if unsure.
>  
>  config FAIR_GROUP_SCHED
> -	bool "Fair group scheduler"
> -	depends on EXPERIMENTAL && CONTAINERS
> +	bool "Fair group cpu scheduler"

Can we have "CPU" instead of "cpu" ?


> +	default n
> +	depends on EXPERIMENTAL
>  	help
> -	  This option enables you to group tasks and control CPU resource
> -	  allocation to such groups.
> -
> -	  Say N if unsure.
> +	  This feature lets cpu scheduler recognize task groups and control cpu
> +	  bandwidth allocation to such task groups.
>  
>  config SYSFS_DEPRECATED
>  	bool "Create deprecated sysfs files"


---
~Randy
Phaedrus says that Quality is about caring.
