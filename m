Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZGFMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZGFMT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZGFMTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:19:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47202 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZGFMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:19:50 -0400
Message-ID: <4A51EB8D.1070300@gmail.com>
Date: Mon, 06 Jul 2009 15:18:21 +0300
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
X-OriginalArrivalTime: 06 Jul 2009 12:18:29.0281 (UTC) FILETIME=[DEE07910:01C9FE33]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> +static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
> +				       enum writeback_sync_modes sync_mode)
> +{
> +	struct bdi_work *work;
> +
> +	work = kmalloc(sizeof(*work), GFP_ATOMIC);
> +	if (work)
> +		bdi_work_init(work, sb, nr_pages, sync_mode);
>  
> -	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
> +	return work;
> +}

Since the caller of this function handles kmalloc failure gracefully,
should we also pass __GFP_NOWARN flag to kmalloc() here, in order to
avoid large and scary no-memory complaints?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
