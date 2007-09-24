Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbXIXRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbXIXRBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbXIXRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:01:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64038 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXIXRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:01:24 -0400
Date: Mon, 24 Sep 2007 09:56:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vatsa@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 4/5] Add fair-user scheduler
Message-Id: <20070924095641.12e595b3.randy.dunlap@oracle.com>
In-Reply-To: <20070924164059.GE10291@linux.vnet.ibm.com>
References: <20070924163326.GA10291@linux.vnet.ibm.com>
	<20070924164059.GE10291@linux.vnet.ibm.com>
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

On Mon, 24 Sep 2007 22:10:59 +0530 Srivatsa Vaddagiri wrote:

> ---
>  include/linux/sched.h |    4 +++
>  init/Kconfig          |   13 ++++++++++++
>  kernel/sched.c        |    9 ++++++++
>  kernel/sched_debug.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/user.c         |   43 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 121 insertions(+)
> 
> Index: linux-2.6.23-rc6/init/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/init/Kconfig
> +++ linux-2.6.23-rc6/init/Kconfig
> @@ -289,6 +289,19 @@ config FAIR_GROUP_SCHED
>  	  This feature lets cpu scheduler recognize task groups and control cpu
>  	  bandwidth allocation to such task groups.
>  
> +choice
> +	depends on FAIR_GROUP_SCHED
> +	prompt "Basis for grouping tasks"
> +	default FAIR_USER_SCHED
> +
> + 	config FAIR_USER_SCHED
> + 		bool "user id"
> + 		help
> + 		  This option will choose userid as the basis for grouping
> +		  tasks, thus providing equal cpu bandwidth to each user.

s/cpu/CPU/g please.

and the "bool", "help" and help text are indented by one tab too much.


> +
> +endchoice
> +
>  config SYSFS_DEPRECATED
>  	bool "Create deprecated sysfs files"
>  	default y

---
~Randy
Phaedrus says that Quality is about caring.
