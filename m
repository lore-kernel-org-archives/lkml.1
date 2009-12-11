Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbZLKOou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbZLKOou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZLKOoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:44:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60733 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbZLKOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:44:45 -0500
Date: Fri, 11 Dec 2009 08:44:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [Patch] ipc: HARD_MSGMAX should be higher not lower on 64bit
Message-ID: <20091211144433.GA23731@us.ibm.com>
References: <20091211061316.3969.99500.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211061316.3969.99500.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Amerigo Wang (amwang@redhat.com):
> It looks weird that we have HARD_MSGMAX lower on 64bit than on 32bit,
> since usually 64bit machines have more memory than 32bit machines.

It does look like this may have been an accident.

> Making it higher on 64bit seems reasonable, and keep the original
> number on 32bit.
> 
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index e408722..07baa38 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -87,7 +87,7 @@ extern int mq_init_ns(struct ipc_namespace *ns);
>  /* default values */
>  #define DFLT_QUEUESMAX 256     /* max number of message queues */
>  #define DFLT_MSGMAX    10      /* max number of messages in each queue */
> -#define HARD_MSGMAX    (131072/sizeof(void *))
> +#define HARD_MSGMAX    (32768*sizeof(void *)/4)

why /4 ?  You're now making it much smaller for 32-bit than it
used to be?

>  #define DFLT_MSGSIZEMAX 8192   /* max message size */
>  #else
>  static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
