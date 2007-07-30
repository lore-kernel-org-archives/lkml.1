Return-Path: <linux-kernel-owner+w=401wt.eu-S939970AbXG3X54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939970AbXG3X54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765676AbXG3X5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:57:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932826AbXG3X5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:57:46 -0400
Date: Mon, 30 Jul 2007 16:57:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] CPU online file permission
Message-Id: <20070730165720.37780cc6.akpm@linux-foundation.org>
In-Reply-To: <200707300056.l6U0ukUe021931@devserv.devel.redhat.com>
References: <200707300056.l6U0ukUe021931@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 20:56:46 -0400
Ulrich Drepper <drepper@redhat.com> wrote:

> Is there a reason why the "online" file in the subdirectories for the CPUs
> in /sys/devices/system isn't world-readable?

No sane one which I can think of.  It seems that it originally sprang forth
from Rusty's keyboard in that form.

>  I cannot imagine it to be
> security relevant especially now that a getcpu() syscall can be used to
> determine what CPUa  thread runs on.
> 
> The file is useful to correctly implement the sysconf() function to return
> the number of online CPUs.  In the presence of hotplug we currently cannot
> provide this information.  The patch below should to it.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> 
> --- drivers/base/cpu.c	2007-02-20 12:01:31.000000000 -0800
> +++ drivers/base/cpu.c-new	2007-07-29 17:52:58.000000000 -0700
> @@ -53,7 +53,7 @@
>  		ret = count;
>  	return ret;
>  }
> -static SYSDEV_ATTR(online, 0600, show_online, store_online);
> +static SYSDEV_ATTR(online, 0644, show_online, store_online);
>  
>  static void __devinit register_cpu_control(struct cpu *cpu)
>  {

I'll pass this by the -stable guys too - I assume we'd like it fixed in
2.6.22 (or earlier) as well..

