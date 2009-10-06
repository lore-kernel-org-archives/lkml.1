Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbZJFSRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbZJFSRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZJFSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:17:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39903 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbZJFSRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:17:50 -0400
Date: Tue, 6 Oct 2009 20:17:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH linux-2.6-block#for-linus]  Seperate read and
	write statistics of in_flight requests v2
Message-ID: <20091006181713.GC5216@kernel.dk>
References: <200910061855.48502.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910061855.48502.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Nikanth Karthikesan wrote:
> [Sorry, resending as the previous mail was word-wrapped]
> 
> Commit a9327cac440be4d8333bba975cbbf76045096275 added seperate read
> and write statistics of in_flight requests. And exported the number
> of read and write requests in progress seperately through sysfs.
> 
> But  Corrado Zoccolo <czoccolo@gmail.com> reported getting strange
> output from "iostat -kx 2". Global values for service time and
> utilization were garbage. For interval values, utilization was always
> 100%, and service time is higher than normal.
> 
> So this was reverted by commit 0f78ab9899e9d6acb09d5465def618704255963b
> 
> The problem was in part_round_stats_single(), I missed the following:
>         if (now == part->stamp)
>                 return;
> 
> -       if (part->in_flight) {
> +       if (part_in_flight(part)) {
>                 __part_stat_add(cpu, part, time_in_queue,
>                                 part_in_flight(part) * (now - part->stamp));
>                 __part_stat_add(cpu, part, io_ticks, (now - part->stamp));
> 
> With this chunk included, the reported regression gets fixed.

Thanks, applied.

-- 
Jens Axboe

