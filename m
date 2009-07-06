Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZGFNje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZGFNje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZGFNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:39:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30091 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZGFNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:39:24 -0400
Message-ID: <4A51FE33.3070702@gmail.com>
Date: Mon, 06 Jul 2009 16:37:55 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-6-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1245926523-21959-6-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jul 2009 13:38:02.0991 (UTC) FILETIME=[FC3ACFF0:01C9FE3E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
> +{
> +	if (work) {
> +		work->seen = bdi->wb_mask;
> +		BUG_ON(!work->seen);
> +		atomic_set(&work->pending, bdi->wb_cnt);
> +		BUG_ON(!bdi->wb_cnt);
> +
> +		/*
> +		 * Make sure stores are seen before it appears on the list
> +		 */
> +		smp_mb();
> +
> +		spin_lock(&bdi->wb_lock);
> +		list_add_tail_rcu(&work->list, &bdi->work_list);
> +		spin_unlock(&bdi->wb_lock);
> +	}

Doesn't spin_lock() include an implicit memory barrier?
After &bdi->wb_lock is acquired, it is guaranteed that all
memory operations are finished.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
