Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXKZPTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXKZPTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXKZPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:19:23 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54669 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXKZPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:19:22 -0500
Date: Mon, 26 Nov 2007 09:19:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsns: Restore proper namespace handling.
Message-ID: <20071126151917.GF547@sergelap.austin.ibm.com>
References: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> When CONFIG_UTS_NS was removed it seems that we also deleted
> the code for handling sysctls in the other then the initial
> uts namespace.   This patch restores that code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Thanks, Eric.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/utsname_sysctl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
> index c76c064..71f58c3 100644
> --- a/kernel/utsname_sysctl.c
> +++ b/kernel/utsname_sysctl.c
> @@ -18,6 +18,8 @@
>  static void *get_uts(ctl_table *table, int write)
>  {
>  	char *which = table->data;
> +	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
> +	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
> 
>  	if (!write)
>  		down_read(&uts_sem);
> -- 
> 1.5.3.rc6.17.g1911
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
