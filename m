Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYKPEsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYKPEsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYKPErz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:47:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:1736 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKPEry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ql/C0K8KAMEddyGoOczwM20CeBxalMCSbLuonENJhhr8o4VI9yoROi1kxioNlQrOJC
         LlYl6b1AVrJ9YfSI6E5qPjfvOV9xJsrxO1MmDhVeSBRFNdOlLDAFJ8dMI8EEa/SQXiBF
         omKGra+EgyPT1AlT9Waqy0C0uOf2x5I0M0uDg=
Date: Sun, 16 Nov 2008 07:51:28 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] memcontrol: use simple_malloc()/simple_free()
Message-ID: <20081116045128.GB24624@x200.localdomain>
References: <491FA2AA.6060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FA2AA.6060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 12:33:46PM +0800, Lai Jiangshan wrote:
> use simple_malloc()/simple_free() instead of current codes.

struct mem_cgroup can't reach the size when kmalloc starts failing.

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1062,11 +1062,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  {
>  	struct mem_cgroup *mem;
>  
> -	if (sizeof(*mem) < PAGE_SIZE)
> -		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
> -	else
> -		mem = vmalloc(sizeof(*mem));
> -
> +	mem = simple_malloc(sizeof(*mem));
>  	if (mem)
>  		memset(mem, 0, sizeof(*mem));
>  	return mem;
> @@ -1074,10 +1070,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  
>  static void mem_cgroup_free(struct mem_cgroup *mem)
>  {
> -	if (sizeof(*mem) < PAGE_SIZE)
> -		kfree(mem);
> -	else
> -		vfree(mem);
> +	simple_free(mem);
>  }
