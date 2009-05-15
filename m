Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZEOTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZEOTkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZEOTki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:40:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40191 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZEOTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:40:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=eXh2+M7q8hZWhED7LQQDOrSZO6l1EtCdhOL5au3vwCNR6bYEexBgye8ZU+S8+2Nbc
	hqG86+NC1pl6mdoey79uA==
Date: Fri, 15 May 2009 12:40:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/11] mm: Convert #ifdef DEBUG printk(KERN_DEBUG to
 pr_debug(
In-Reply-To: <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
Message-ID: <alpine.DEB.2.00.0905151240080.925@chino.kir.corp.google.com>
References: <cover.1242407227.git.joe@perches.com> <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Joe Perches wrote:

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

You can just remove the entire printk() since this information is now 
exported via /proc/pid/oom_score.
