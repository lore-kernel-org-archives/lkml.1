Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbZLKAxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbZLKAxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbZLKAxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:53:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbZLKAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:53:21 -0500
Message-ID: <4B219704.7080508@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 08:49:08 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Fix a CFQ crash in "for-2.6.33" branch of block tree
References: <20091210170845.GA8327@redhat.com>
In-Reply-To: <20091210170845.GA8327@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> I think I have hit following BUG_ON() in cfq_dispatch_request().
> 
> BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
> 
> Please find attached the patch to fix it. I have done some stress testing
> with it and have not seen it happening again.
> 
> 
> o We should wait on a queue even after slice expiry only if it is empty. If
>   queue is not empty then continue to expire it.
> 
> o If we decide to keep the queue then make cfqq=NULL. Otherwise select_queue()
>   will return a valid cfqq and cfq_dispatch_request() can hit following
>   BUG_ON().
> 
>   BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list))
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Vivek,

I saw this oops also. This patch seems good to me, and works fine on my box.

