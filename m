Return-Path: <linux-kernel-owner+w=401wt.eu-S1161430AbXDWKys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161430AbXDWKys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161379AbXDWKym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:54:42 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:35061 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161375AbXDWKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:54:41 -0400
Message-ID: <462C9001.7060403@linux.vnet.ibm.com>
Date: Mon, 23 Apr 2007 16:22:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 2/7] Containers (V8): Cpusets hooked into containers
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.090764000@menage.corp.google.com>
In-Reply-To: <20070407001324.090764000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



menage@google.com wrote:
> This patch removes the process grouping code from the cpusets code,
> instead hooking it into the generic container system. This temporarily
> adds cpuset-specific code in kernel/container.c, which is removed by
> the next patch in the series.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

[snip]

> Index: container-2.6.20-new/init/Kconfig
> ===================================================================
> --- container-2.6.20-new.orig/init/Kconfig
> +++ container-2.6.20-new/init/Kconfig
> @@ -239,17 +239,12 @@ config IKCONFIG_PROC
>  	  through /proc/config.gz.
> 
>  config CONTAINERS
> -	bool "Container support"
> -	help
> -	  This option will let you create and manage process containers,
> -	  which can be used to aggregate multiple processes, e.g. for
> -	  the purposes of resource tracking.
> -
> -	  Say N if unsure
> +	bool

Hi Paul,

This looks like some patch generation error.  Description for
containers should not be removed after applying this patch.

--Vaidy

> 
>  config CPUSETS
>  	bool "Cpuset support"
>  	depends on SMP
> +	select CONTAINERS
>  	help
>  	  This option will let you create and manage CPUSETs which
>  	  allow dynamically partitioning a system into sets of CPUs and
> @@ -278,6 +273,11 @@ config SYSFS_DEPRECATED
>  	  If you are using a distro that was released in 2006 or later,
>  	  it should be safe to say N here.
> 
> +config PROC_PID_CPUSET
> +	bool "Include legacy /proc/<pid>/cpuset file"
> +	depends on CPUSETS
> +	default y
> +
>  config RELAY
>  	bool "Kernel->user space relay support (formerly relayfs)"
>  	help

[snip]

