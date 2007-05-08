Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbXEHWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbXEHWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXEHWER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:04:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53543 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXEHWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:04:16 -0400
Date: Tue, 8 May 2007 15:06:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Len Brown <lenb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 4/4] Add common orderly_poweroff()
Message-Id: <20070508150623.d8a0a240.randy.dunlap@oracle.com>
In-Reply-To: <20070508205517.358968475@goop.org>
References: <20070508205129.064843364@goop.org>
	<20070508205517.358968475@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 13:51:33 -0700 Jeremy Fitzhardinge wrote:

> diff -r 9eea40ea89b7 kernel/sys.c
> --- a/kernel/sys.c	Tue May 08 12:59:41 2007 -0700
> +++ b/kernel/sys.c	Tue May 08 13:42:22 2007 -0700
> @@ -2208,3 +2208,58 @@ asmlinkage long sys_getcpu(unsigned __us
>  	}
>  	return err ? -EFAULT : 0;
>  }
> +
> +char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
> +
> +static void argv_cleanup(char **argv, char **envp)
> +{
> +	argv_free(argv);
> +}
> +
> +/**

   /*
would be OK since this isn't kernel-doc.... (or make it kernel-doc)

> + * Trigger an orderly system poweroff
> + *
> + * This may be called from any context to trigger a system shutdown.
> + * If the orderly shutdown fails, it will force an immediate shutdown.
> + */
> +int orderly_poweroff(bool force)
> +{


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
