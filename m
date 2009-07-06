Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZGFMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZGFMWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZGFMWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:22:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZGFMWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:22:09 -0400
Date: Mon, 6 Jul 2009 14:22:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
Message-ID: <20090706122211.GO23611@kernel.dk>
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-6-git-send-email-jens.axboe@oracle.com> <4A51EB8D.1070300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A51EB8D.1070300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> +static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
>> +				       enum writeback_sync_modes sync_mode)
>> +{
>> +	struct bdi_work *work;
>> +
>> +	work = kmalloc(sizeof(*work), GFP_ATOMIC);
>> +	if (work)
>> +		bdi_work_init(work, sb, nr_pages, sync_mode);
>>  -	wb_start_writeback(&bdi->wb, sb, nr_pages, sync_mode);
>> +	return work;
>> +}
>
> Since the caller of this function handles kmalloc failure gracefully,
> should we also pass __GFP_NOWARN flag to kmalloc() here, in order to
> avoid large and scary no-memory complaints?

Sure, it can't hurt.

-- 
Jens Axboe

