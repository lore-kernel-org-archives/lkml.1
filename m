Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0CGRrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 12:47:47 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:53036 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab0CGRrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 12:47:46 -0500
Subject: block: blk-timeout.c possible mishandling of jiffies wrap?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Mar 2010 17:47:44 +0000
Message-ID: <1267984064.2115.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

In blk_rq_timed_out_timer() in blk-timeout.c the comment at line 129
says that the request deadline can never be zero as that gets fixed in
blk_add_timer.

However commit 7838c15b8dd18e78a523513749e5b54bda07b0cb
removed the line that bumped deadline if zero.

So now AFAICT there's nothing to prevent deadline being zero, and
blk_rq_timed_out_timer may not always do the right thing when jiffies is
about to wrap.

There was a next_set flag in blk_rq_timed_out_timer but that's been
removed too.

Do you have any preferred fix? A next_set flag or a deadline bump or
something else?

regards
Richard


