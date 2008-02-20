Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYBTM0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYBTM0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYBTM0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:26:18 -0500
Received: from sacred.ru ([62.205.161.221]:48512 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYBTM0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:26:17 -0500
Message-ID: <47BC1BA9.5040009@openvz.org>
Date: Wed, 20 Feb 2008 15:23:05 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 2.6.25-rc2 3/9] config: Improve init/Kconfig help	descriptions
 - namespaces
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org> <20080219151028.GA28294@tull.net> <47BAF2E5.8050001@openvz.org> <20080219084420.f3104e3f.randy.dunlap@oracle.com> <20080220121915.GA2169@tull.net>
In-Reply-To: <20080220121915.GA2169@tull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 20 Feb 2008 15:22:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> Rewrite the help descriptions for clarity, accuracy and consistency.
> 
> Kernel config options affected:
> 
>   - NAMESPACES
>   - UTS_NS
>   - IPC_NS
>   - USER_NS
>   - PID_NS
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> ---
> Here's try #2 at the 3rd patch in the series, for namespace
> descriptions. Patching against Linus' git tree now, and trying
> to comply with the standards for submitting patches. Each of
> the UTS/IPC/USER/PID descriptions is subtly different, but I
> hope they all are clear and accurate.
> 
> 
> --- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
> +++ b/init/Kconfig	2008-02-20 22:55:41.000000000 +1100
> @@ -414,31 +414,71 @@
>  	bool "Namespaces support" if EMBEDDED
>  	default !EMBEDDED
>  	help
> -	  Provides the way to make tasks work with different objects using
> -	  the same id. For example same IPC id may refer to different objects
> -	  or same user id or pid may refer to different tasks when used in
> -	  different namespaces.
> +	  Select various namespace options.
> +
> +	  Namespaces allow different kernel objects (such as processes
> +	  or sockets) to have the same ID in different namespaces.
> +	  Identifiers like process IDs, which historically were globally
> +	  unique, will now be unique only within each PID namespace.
> +	  Each task can refer only to PIDs within the same namespace
> +	  as the task itself.
> +
> +	  Namespaces are used by container systems (i.e. vservers)
> +	  to provide isolation between the containers.
> +
> +	  This option does not affect any kernel code directly; it merely
> +	  allows you to select namespace options below.
> +
> +	  Answer Y if you will be using a container system, and you
> +	  will probably want to enable all the namespace options
> +	  below.
>  
>  config UTS_NS
>  	bool "UTS namespace"
>  	depends on NAMESPACES
>  	help
> -	  In this namespace tasks see different info provided with the
> -	  uname() system call
> +	  Enable support for multiple UTS system attributes.
> +
> +	  Each UTS namespace provides an individual view of the
> +	  information returned by the uname() system call including
> +	  hostname, kernel version and domain name.
> +
> +	  This is used by container systems (i.e. vservers) so that
> +	  each container has its own hostname and other attributes.
> +	  Tasks in the container are placed in the UTS namespace
> +	  corresponding to the container.
> +
> +	  Answer Y if you will be using a container system.
>  
>  config IPC_NS
>  	bool "IPC namespace"
>  	depends on NAMESPACES && SYSVIPC
>  	help
> -	  In this namespace tasks work with IPC ids which correspond to
> -	  different IPC objects in different namespaces
> +	  Enable support for namespace-specific IPC IDs.
> +
> +	  IPC IDs will be unique only within each IPC namespace.
> +
> +	  This is used by container systems (i.e. vservers).
> +	  Tasks in the container are placed in the IPC namespace
> +	  corresponding to the container.
> +
> +	  Answer Y if you will be using a container system.
>  
>  config USER_NS
>  	bool "User namespace (EXPERIMENTAL)"
>  	depends on NAMESPACES && EXPERIMENTAL
>  	help
> -	  This allows containers, i.e. vservers, to use user namespaces
> -	  to provide different user info for different servers.
> +	  Enable experimental support for user namespaces.
> +
> +	  This is a function used by container-based virtualisation systems
> +	  (e.g. vservers). User namespaces are intended to ensure that
> +	  processes with the same uid which are in different containers are
> +	  isolated from each other.
> +
> +	  Currently user namespaces provide separate accounting, while
> +	  isolation must be provided using SELinux or a custom security
> +	  module.
> +
>  	  If unsure, say N.
>  
>  config PID_NS
> @@ -446,12 +486,20 @@
>  	default n
>  	depends on NAMESPACES && EXPERIMENTAL
>  	help
> -	  Suport process id namespaces.  This allows having multiple
> -	  process with the same pid as long as they are in different
> -	  pid namespaces.  This is a building block of containers.
> +	  Enable experimental support for hierarchical process id namespaces.
>  
> -	  Unless you want to work with an experimental feature
> -	  say N here.
> +	  Process IDs will be unique only within each PID namespace.
> +	  This allows multiple processes to have the same PID
> +	  so long as they are in different PID namespaces. Furthermore,
> +	  each process will have a distinct PID in each namespace
> +	  the process is in.
> +
> +	  This is used by container systems (i.e. vservers).
> +	  Tasks in the container are placed in the PID namespace
> +	  corresponding to the container, and can only see or
> +	  affect processes in the same PID namespace.

same of one of child namespaces. In other words when you create
a new pid namespace, you still see the tasks from this new one,
but the tasks from this one, doesn't see yours :)

> +
> +	  If unsure, say N.
>  
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
> 

