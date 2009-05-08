Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbZEHDFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbZEHDFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbZEHDAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:00:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50442 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763496AbZEHDA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:00:28 -0400
Message-ID: <4A03A013.9000405@cn.fujitsu.com>
Date: Fri, 08 May 2009 10:59:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 17/18] io-controller: IO group refcounting support
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-18-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-18-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  
> -		BUG_ON(!RB_EMPTY_ROOT(&st->active));
> -		BUG_ON(!RB_EMPTY_ROOT(&st->idle));
>  	}
>  
> -	BUG_ON(iog->sched_data.next_active != NULL);
> -	BUG_ON(iog->sched_data.active_entity != NULL);
> -	BUG_ON(entity->tree != NULL);
> +	/* Drop iocg reference on io group */

  We'd better to reset iog->iocg_id here since the cgroup is going to destroy.

> +	elv_put_iog(iog);
>  }
>  
> -/**


-- 
Regards
Gui Jianfeng


