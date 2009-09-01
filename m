Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbZIATQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbZIATQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIATQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:16:07 -0400
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:42303 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715AbZIATQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:16:06 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 1 Sep 2009 15:15:20 -0400
To: bonbons@linux-vserver.org, ecashin@coraid.com, apw@canonical.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Message-ID: <6309cc7d77486e24aca5130ec5802dfb@coraid.com>
In-Reply-To: <20090829154305.723fd86c@neptune.home>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
	<20090829154305.723fd86c@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat Aug 29 09:43:54 EDT 2009, bonbons@linux-vserver.org wrote:
...
> I finished bisecting the NULL object and ended up at this commit:
>   cd43e26f071524647e660706b784ebcbefbd2e44
> 
>   block: Expose stacked device queues in sysfs
> 
>   Currently stacking devices do not have a queue directory in sysfs.
>   However, many of the I/O characteristics like sector size, maximum
>   request size, etc. are queue properties.
> 
>   This patch enables the queue directory for MD/DM devices.  The elevator
>   code has been modified to deal with queues that do not have an I/O
>   scheduler.
> 
>   Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>   Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> 
> This seems to generate /sys/block/$device/queue and its contents for
> everyone who is using queues, not just for those queues that have a
> non-NULL queue->request_fn.

Thanks much for doing that.  It makes sense that this change would
have caused it to suddenly matter whether the unused queue is
initialized.

The patch looks fine to me.

I don't think it should go in my aoe tree for linux-next, since the
patch addresses a regression.

Based on the series file in mmotm, I don't think this patch is in mm
at the moment.  Andrew Morton, do you think this patch should go
through your mm tree?

-- 
  Ed
