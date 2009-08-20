Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZHTLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZHTLjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZHTLjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:39:19 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43638 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZHTLjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:39:19 -0400
Message-ID: <4A8D35E1.2070707@s5r6.in-berlin.de>
Date: Thu, 20 Aug 2009 13:39:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>, Mark Lord <liml@rtr.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk>	<4A8BE932.5090300@garzik.org>	<20090819120458.GZ12579@kernel.dk>	<4A8BECC2.2060607@rtr.ca>	<20090819122320.GA12579@kernel.dk>	<4A8BFC79.1000004@garzik.org>	<4A8BFDE2.1010904@garzik.org>	<4A8C0820.8060200@gmail.com> <20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
In-Reply-To: <20090819162147.16aeb2db@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Somewhat simpler for the general case would be to implement
> 
> create_workqueue(min_threads,max_threads, max_thread_idle_time);
> queue_work_within();
> 
> at which point you can queue work to the workqueue but with a per
> workqueue timing running so you know when you might need to create a new
> thread if the current work hasn't finished. Idle threads would then sleep
> and either expire or pick up new work
[...]

Sounds a lot like kernel/slow-work.c / include/linux/slow-work.h to me
(as Ben already pointed out).
-- 
Stefan Richter
-=====-==--= =--- =-=--
http://arcgraph.de/sr/
