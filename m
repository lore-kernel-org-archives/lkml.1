Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYE0Mpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYE0Mpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYE0Mph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:45:37 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:16631 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYE0Mpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:45:36 -0400
Message-ID: <483C026D.5060302@hp.com>
Date: Tue, 27 May 2008 08:45:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-btrace@vger.kernel.org
Subject: [PATCH 2/2] Added in elevator switch message to blktrace stream
References: <483C0216.70008@hp.com>
In-Reply-To: <483C0216.70008@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/elevator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 980f8ae..902dd13 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1110,6 +1110,8 @@ static int elevator_switch(struct request_queue
*q, struct elevator_type *new_e)
 	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
 	spin_unlock_irq(q->queue_lock);

+	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
+
 	return 1;

 fail_register:
-- 
1.5.4.3

