Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZESGrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZESGrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZESGq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:46:59 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:59366 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZESGq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:46:58 -0400
Message-ID: <4A1255E1.1060301@linux.vnet.ibm.com>
Date: Tue, 19 May 2009 08:46:57 +0200
From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-btrace@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [Patch] blktrace: remove debugfs entries on bad path
References: <4A115BA5.6090905@linux.vnet.ibm.com> <4A1207DE.4000409@cn.fujitsu.com>
In-Reply-To: <4A1207DE.4000409@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> A better title:
> 	[Patch] blktrace: remove debugfs entries on bad path
> 
> Stefan Raspl wrote:
>> debugfs directory entries for devices are not removed on bad path.
> 
> Can you be more elaborate on how to reproduce this issue?

It can happen for most bad pathes within do_blk_trace_setup(). One
way to trigger is to set the Vmalloc space via the respective kernel
parameter to a value that is so small that it will not suffice for
the 2MB per device and cpu that is required. For instance, set
vmalloc=10M and start blktrace on a system with 2 cpus on 7 devices.
Depending on how much Vmalloc space is still free, the final 2 or 3
devices will fail with a message like this:

	BLKTRACESETUP(2) /dev/sdu failed: 5/Input/output error

Best regards,
Stefan Raspl
