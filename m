Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab0BLARz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:17:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33039 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0BLARy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:17:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Feb 2010 09:14:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH mmotm] memcg: check if first threshold crossed
Message-Id: <20100212091429.d1115b17.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1265846123-2244-1-git-send-email-kirill@shutemov.name>
References: <1265846123-2244-1-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 01:55:23 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> There is a bug in memory thresholds code. We don't check if first
> threshold (array index 0) was crossed down. This patch fixes it.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 41e00c2..a443c30 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3252,7 +3252,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
>  	 * If none of thresholds below usage is crossed, we read
>  	 * only one element of the array here.
>  	 */
> -	for (; i > 0 && unlikely(t->entries[i].threshold > usage); i--)
> +	for (; i >= 0 && unlikely(t->entries[i].threshold > usage); i--)
>  		eventfd_signal(t->entries[i].eventfd, 1);
>  
>  	/* i = current_threshold + 1 */
> -- 
> 1.6.5.8
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

