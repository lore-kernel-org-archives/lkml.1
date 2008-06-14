Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYFNEvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYFNEvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 00:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYFNEvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 00:51:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33898 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYFNEvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 00:51:23 -0400
Date: Fri, 13 Jun 2008 21:46:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] introduce task cgroup v2
Message-Id: <20080613214626.9afc892f.randy.dunlap@oracle.com>
In-Reply-To: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Sat, 07 Jun 2008 20:00:00 +0900 KOSAKI Motohiro wrote:

> ---
>  Documentation/controllers/task.txt |   18 +++
>  include/linux/cgroup_subsys.h      |    4 
>  include/linux/cgroup_task.h        |   33 +++++
>  init/Kconfig                       |   10 +
>  kernel/Makefile                    |    1 
>  kernel/cgroup_task.c               |  213 +++++++++++++++++++++++++++++++++++++
>  kernel/fork.c                      |    4 
>  7 files changed, 283 insertions(+)
> 
> Index: b/init/Kconfig
> ===================================================================
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -289,6 +289,16 @@ config CGROUP_DEBUG
>  
>  	  Say N if unsure
>  
> +config CGROUP_TASK
> +	bool "Simple number of task accounting cgroup subsystem"
> +	depends on CGROUPS && EXPERIMENTAL
> +	default n
> +	help
> +          Provides a simple number of task accounting cgroup subsystem for

Indent help test one tab + 2 spaces, please.
s/for/to/

> +	  prevent fork bomb.

s/bomb/bombs/

> +
> +	  Say N if unsure

end with period (".").

> +
>  config CGROUP_NS
>          bool "Namespace cgroup subsystem"
>          depends on CGROUPS

> Index: b/Documentation/controllers/task.txt
> ===================================================================
> --- /dev/null
> +++ b/Documentation/controllers/task.txt
> @@ -0,0 +1,18 @@
> +Task limit Controller
> +
> +1. Description
> +
> +Implement a cgroup to track number of tasks (process and thread).
> +this feature is useful for prevent fork bomb attack.

s/this/This/
s/for/to/
s/attack/attacks/ or s/prevent fork/prevent a fork/

> +
> +
> +2. User Interface
> +
> +ristrict number of tasks to 100.

   Restrict

> +
> +	# echo 100 > /cgroups/foo/task.max_tasks
> +
> +
> +display current number of tasks.

   Display

> +
> +        # cat > /cgroups/foo/task.nr_tasks
> 
> 
> --


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
