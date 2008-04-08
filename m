Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbYDHK3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbYDHK3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDHK3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:29:25 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:53621 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYDHK3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:29:24 -0400
Message-ID: <47FB48AE.3030207@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2008 15:57:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom_kill: remove unused parameter in badness()
References: <47FB24CF.40704@cn.fujitsu.com>
In-Reply-To: <47FB24CF.40704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> In commit 4c4a22148909e4c003562ea7ffe0a06e26919e3c, we moved the
> memcontroller-related code from badness() to select_bad_process(),
> so the parameter 'mem' in badness() is unused now.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  mm/oom_kill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index f255eda..8be1baf 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -53,8 +53,7 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
>   *    of least surprise ... (be careful when you change it)
>   */
> 
> -unsigned long badness(struct task_struct *p, unsigned long uptime,
> -			struct mem_cgroup *mem)
> +unsigned long badness(struct task_struct *p, unsigned long uptime)
>  {
>  	unsigned long points, cpu_time, run_time, s;
>  	struct mm_struct *mm;
> @@ -254,7 +253,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  		if (p->oomkilladj == OOM_DISABLE)
>  			continue;
> 
> -		points = badness(p, uptime.tv_sec, mem);
> +		points = badness(p, uptime.tv_sec);
>  		if (points > *ppoints || !chosen) {
>  			chosen = p;
>  			*ppoints = points;

Looks good to be

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
