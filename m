Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZHaWXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZHaWXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZHaWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:23:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:52121 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZHaWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:23:23 -0400
Date: Tue, 1 Sep 2009 08:22:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/6] SECURITY: selinux, fix update_rlimit_cpu parameter
In-Reply-To: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LRH.2.00.0909010811320.22374@tundra.namei.org>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Jiri Slaby wrote:

[added lsm list]

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index cf41988..496e626 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2360,7 +2360,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
>  			initrlim = init_task.signal->rlim + i;
>  			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
>  		}
> -		update_rlimit_cpu(rlim->rlim_cur);
> +		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);

This doesn't look correct to me: the original code determines 
rlim->rlim_cur and then updates current to that.  With your change, this 
value is not used.

-- 
James Morris
<jmorris@namei.org>
