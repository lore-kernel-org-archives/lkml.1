Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYGVIWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYGVIWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYGVIWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:22:36 -0400
Received: from mail.suse.de ([195.135.220.2]:41070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYGVIWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:22:35 -0400
Message-ID: <488598C9.6000701@suse.de>
Date: Tue, 22 Jul 2008 10:22:33 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Miller <mike.miller@hp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Remove pointless curr_queue calculation in block/cciss.c
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000102040601090504010005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000102040601090504010005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mike,

in block/cciss.c:cciss_check_queues() curr_queue is calculated
as the last statement in a for loop, although it's being initialized
with the next round again and never been used afterwards.
So this can be removed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------000102040601090504010005
Content-Type: text/plain;
 name="cciss-remove-curr_queue-statement"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss-remove-curr_queue-statement"

Remove curr_queue calculation in block/cciss.c

curr_queue is a local variable in a for loop, and it's
being initialized at the start of each loop. So any
assignment at the end of the loop is pointless.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d81632c..0ce0c27 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1292,8 +1292,6 @@ static void cciss_check_queues(ctlr_info_t *h)
 				h->next_to_run = curr_queue;
 				break;
 			}
-		} else {
-			curr_queue = (curr_queue + 1) % (h->highest_lun + 1);
 		}
 	}
 }

--------------000102040601090504010005--
