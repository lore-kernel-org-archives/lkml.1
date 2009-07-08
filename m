Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZGHOCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZGHOCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZGHOCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:02:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39834 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbZGHOCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:02:16 -0400
Date: Wed, 8 Jul 2009 10:00:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 11/25] io-controller: Export disk time used and nr
	sectors dipatched through cgroups
Message-ID: <20090708140025.GC24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-12-git-send-email-vgoyal@redhat.com> <4A54018C.5090804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A54018C.5090804@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 10:16:44AM +0800, Gui Jianfeng wrote:
[..]
> 
> Hi Vivek,
> 
> Let io.disk_*'s outputs conform with io.policy's.
> 

Sure. Queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 7c83d1e..29392e7 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1631,7 +1631,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev),
>  					iog->entity.total_service);
>  		}
> @@ -1661,7 +1661,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev),
>  					iog->entity.total_sector_service);
>  		}
> @@ -1692,7 +1692,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev), iog->queue,
>  					iog->queue_duration);
>  		}
> @@ -1722,7 +1722,7 @@ static int io_cgroup_disk_dequeue_read(struct cgroup *cgroup,
>  		 * waiting to be reclaimed upon cgoup deletion.
>  		 */
>  		if (iog->key) {
> -			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> +			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
>  					MINOR(iog->dev), iog->dequeue);
>  		}
>  	}
> -- 
> 1.5.4.rc3
> 
