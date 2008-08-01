Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYHALqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYHALqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYHALqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:46:11 -0400
Received: from mail.crca.org.au ([67.207.131.56]:43933 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYHALqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:46:10 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 4/6] Container Freezer: Skip frozen cgroups during
	power management resume
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20080801050701.070484831@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
	 <20080801050701.070484831@us.ibm.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 01 Aug 2008 20:24:40 +1000
Message-Id: <1217586280.27551.18.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-07-31 at 22:07 -0700, Matt Helsley wrote:
> When a system is resumed after a suspend, it will also unfreeze
> frozen cgroups.
> 
> This patchs modifies the resume sequence to skip the tasks which
> are part of a frozen control group.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

I understand the freezer pretty well, so maybe I can help a little.

Acked-by: Nigel Cunningham <nigel@tuxonice.net>

> ---
>  kernel/power/process.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 444cea8..ce9e280 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/syscalls.h>
>  #include <linux/freezer.h>
> +#include <linux/cgroup_freezer.h>
>  
>  /* 
>   * Timeout for stopping processes
> @@ -135,6 +136,9 @@ static void thaw_tasks(bool nosig_only)
>  		if (nosig_only && should_send_signal(p))
>  			continue;
>  
> +		if (cgroup_frozen(p))
> +			continue;
> +
>  		thaw_process(p);
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
> -- 
> 1.5.3.7
> 

