Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZFZP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZFZP2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbZFZP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:28:29 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36705 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFZP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:28:28 -0400
Date: Fri, 26 Jun 2009 10:28:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Sanchin Sant <sanchinp@in.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: ima mq_open imbalance msg fix
Message-ID: <20090626152827.GA23046@us.ibm.com>
References: <1246029845-6810-1-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246029845-6810-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> This patch fixes an imbalance message as reported by Sanchin Sant.
> As we don't need to measure the message queue, just increment the
> counters.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks, Mimi and Sanchin.

-serge

> ---
>  ipc/mqueue.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index e35ba2c..c5e68ad 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -32,6 +32,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/pid.h>
>  #include <linux/ipc_namespace.h>
> +#include <linux/ima.h>
> 
>  #include <net/sock.h>
>  #include "util.h"
> @@ -733,6 +734,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
>  		error = PTR_ERR(filp);
>  		goto out_putfd;
>  	}
> +	ima_counts_get(filp);
> 
>  	fd_install(fd, filp);
>  	goto out_upsem;
> -- 
> 1.6.0.6
