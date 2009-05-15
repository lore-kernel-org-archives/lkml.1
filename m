Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZEOS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZEOS4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZEOS4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:56:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43464 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZEOS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:56:01 -0400
Date: Fri, 15 May 2009 13:56:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, David Rientjes <rientjes@google.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/11] mm: Convert #ifdef DEBUG printk(KERN_DEBUG to
	pr_debug(
Message-ID: <20090515185602.GA28604@us.ibm.com>
References: <cover.1242407227.git.joe@perches.com> <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches (joe@perches.com):
> From: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Seems reasonable - apart from my woes with dynamic_printk :)

Can you also remove the commented-out '#define DEBUG' line on
line 35 if you haven't already?

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  mm/oom_kill.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 92bcf1d..8f7fb51 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -159,10 +159,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  			points >>= -(p->oomkilladj);
>  	}
> 
> -#ifdef DEBUG
> -	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
> -	p->pid, p->comm, points);
> -#endif
> +	pr_debug("OOMkill: task %d (%s) got %lu points\n",
> +		 p->pid, p->comm, points);
>  	return points;
>  }
> 
> -- 
> 1.6.3.1.9.g95405b.dirty
