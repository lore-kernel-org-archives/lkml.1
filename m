Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZGHEsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZGHEsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZGHEsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:48:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32953 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZGHEsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:48:21 -0400
Message-ID: <4A5424E8.1070201@gmail.com>
Date: Wed, 08 Jul 2009 07:47:36 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, richard@rsk.demon.co.uk, damien.wyart@free.fr,
       fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 02/10] writeback: switch to per-bdi threads for flushing
 data
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com>	 <1245926523-21959-3-git-send-email-jens.axboe@oracle.com>	 <4A53694D.2010905@gmail.com> <1247014636.2560.539.camel@ymzhang>
In-Reply-To: <1247014636.2560.539.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2009 04:47:39.0691 (UTC) FILETIME=[38E417B0:01C9FF87]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
>>> +		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
>>> +			if (bdi->task || !bdi_has_dirty_io(bdi))
>>> +				continue;
>>> +
>>> +			bdi_add_default_flusher_task(bdi);
>>> +		}
>>> +
>>> +		set_current_state(TASK_INTERRUPTIBLE);
>>> +
>> What happens if we are preempted here? Since we have TASK_INTERRUPTIBLE
>> state, we will not come back unless some other task wakes us up. Who
>> would wake us up in this case?
> If it's preempted (CONFIG_PREEMPT=y), it will stay in runqueue. Only when
> it calls schedule initiatively or calls schedule when exiting to user space,
> it will be moved out of runqueue if its state isn't TASK_RUNNING.
> 
> See flag PREEMPT_ACTIVE.

OK, thanks for the hint!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
