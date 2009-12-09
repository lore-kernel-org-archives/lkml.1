Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZLIQMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZLIQMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZLIQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:12:46 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.68]:59852 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbZLIQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:12:45 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Thu, 10 Dec 2009 01:11:42 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH] [TRIVIAL] memcg: fix memory.memsw.usage_in_bytes for
 root cgroup
Message-Id: <20091210011142.bd64a736.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
References: <1260373738-17179-1-git-send-email-kirill@shutemov.name>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added Cc: Andrew Morton <akpm@linux-foundation.org>)

On Wed,  9 Dec 2009 17:48:58 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> We really want to take MEM_CGROUP_STAT_SWAPOUT into account.
> 
Nice catch!

	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: stable@kernel.org
> ---
>  mm/memcontrol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f99f599..6314015 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2541,6 +2541,7 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
>  			val += idx_val;
>  			mem_cgroup_get_recursive_idx_stat(mem,
>  				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
> +			val += idx_val;
>  			val <<= PAGE_SHIFT;
>  		} else
>  			val = res_counter_read_u64(&mem->memsw, name);

Regards,
Daisuke Nishimura.
