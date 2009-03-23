Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZCWJl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZCWJl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZCWJk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:40:59 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:58992 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbZCWJk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:40:59 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 05:40:58 EDT
Date: Mon, 23 Mar 2009 10:28:02 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: MMC layer regression with single-block controllers
Message-ID: <20090323092802.GA30122@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre,

Since about 2.6.28-rc1, I hit the following BUG_ON() in mmc/core.c
(line 155):

        if (mrq->data) {
                BUG_ON(mrq->data->blksz > host->max_blk_size);
>>>>>>>>>       BUG_ON(mrq->data->blocks > host->max_blk_count);  <<<<<<
                BUG_ON(mrq->data->blocks * mrq->data->blksz >
                        host->max_req_size);

It's easy to reproduce; just set your favorite host controllers'
mmc->max_blk_cnt to 1 (or anything smaller than 4).  As far as I can
tell it was introduced with some block layer changes before 2.6.28-rc1
was released.

Thanks,
	Manuel Lauss
