Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbYDWGxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbYDWGxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYDWGw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:52:59 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51409 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYDWGw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:52:58 -0400
Message-ID: <480EDBD2.2060709@linux.vnet.ibm.com>
Date: Wed, 23 Apr 2008 12:18:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: use read lock to guard find_existing_css_set()
References: <480EA744.2050300@cn.fujitsu.com>
In-Reply-To: <480EA744.2050300@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> The function does not modify anything (except the temporary
> css template), so it's sufficient to hold read lock.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2727f92..e9eb5da 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -406,11 +406,11 @@ static struct css_set *find_css_set(
> 
>  	/* First see if we already have a cgroup group that matches
>  	 * the desired set */
> -	write_lock(&css_set_lock);
> +	read_lock(&css_set_lock);
>  	res = find_existing_css_set(oldcg, cgrp, template);
>  	if (res)
>  		get_css_set(res);
> -	write_unlock(&css_set_lock);
> +	read_unlock(&css_set_lock);
> 
>  	if (res)
>  		return res;

Looks good to me. Did you run lockdep?



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
