Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbZGQGq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbZGQGq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933303AbZGQGq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:46:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:52500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbZGQGq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:46:57 -0400
Message-ID: <4A601ED2.50800@kernel.org>
Date: Fri, 17 Jul 2009 15:48:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: sysfs fix mismatched queue_var_{store,show}
 in 64bit kernel
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com> <1247580906-24762-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1247580906-24762-1-git-send-email-dfeng@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 06:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Xiaotian.

Xiaotian Feng wrote:
>  static ssize_t queue_ra_show(struct request_queue *q, char *page)
>  {
> -	int ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
> +	unsigned long ra_kb = q->backing_dev_info.ra_pages <<
> +					(PAGE_CACHE_SHIFT - 10);
>  
>  	return queue_var_show(ra_kb, (page));
>  }

Nice.

> @@ -95,7 +96,7 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
>  
>  static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
>  {
> -	int max_sectors_kb = queue_max_sectors(q) >> 1;
> +	unsigned long max_sectors_kb = queue_max_sectors(q) >> 1;
>  
>  	return queue_var_show(max_sectors_kb, (page));
>  }
> @@ -140,7 +141,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
>  
>  static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
>  {
> -	int max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
> +	unsigned long max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
>  
>  	return queue_var_show(max_hw_sectors_kb, (page));
>  }

The above two aren't necessary but well why not.

> @@ -189,7 +190,7 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
>  
>  static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
>  {
> -	unsigned int set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
> +	unsigned long set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
>  
>  	return queue_var_show(set != 0, page);
>  }

Wouldn't it be better to make it "bool set = " and then remove the
"!= 0"?

Thanks.

-- 
tejun
