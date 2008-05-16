Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYEPPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYEPPta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYEPPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:49:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46994 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYEPPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:49:21 -0400
Date: Fri, 16 May 2008 08:48:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bsdacct: stir up comments around acct_process.
Message-Id: <20080516084840.dfb4cd8d.randy.dunlap@oracle.com>
In-Reply-To: <482D6803.60205@openvz.org>
References: <482D6803.60205@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Fri, 16 May 2008 14:54:59 +0400 Pavel Emelyanov wrote:

> Fix the one describing what this function is and add one
> more - about locking absence around pid namespaces loop.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 0feba97..d7b670c 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -657,7 +657,8 @@ static void acct_process_in_ns(struct pid_namespace *ns)
>  }
>  
>  /**
> - * acct_process - now just a wrapper around do_acct_process
> + * acct_process - now just a wrapper around acct_process_in_ns,
> + * which int turn is a wrapper around do_acct_process.

            in

>   *
>   * handles process accounting for an exiting task
>   */
> @@ -665,6 +666,11 @@ void acct_process(void)
>  {
>  	struct pid_namespace *ns;
>  
> +	/*
> +	 * This loop is safe lockless, since current it still

                                                     is still

> +	 * alive and holds its namespace, which in turn holds
> +	 * its parent.
> +	 */
>  	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
>  		acct_process_in_ns(ns);
>  }

---
~Randy
