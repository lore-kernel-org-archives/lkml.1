Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbZENOP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbZENOP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZENOPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:15:10 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:1101 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752741AbZENOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:15:08 -0400
Message-ID: <4A0C2769.4090508@panasas.com>
Date: Thu, 14 May 2009 17:15:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A0C2297.5040001@panasas.com> <4A0C2515.9060602@kernel.org>
In-Reply-To: <4A0C2515.9060602@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2009 14:15:08.0524 (UTC) FILETIME=[62DB72C0:01C9D49E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2009 05:05 PM, Tejun Heo wrote:
> Nice spotting.  Looks like the variable can be killed completely?
> 
> Thanks.
> 

Sorry yes, here:
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 14 May 2009 16:46:03 +0300
Subject: [PATCH] scsi_lib: remove unused variable

The last request completion cleanup in scsi_lib left an unused
this_count variable in scsi_io_completion().
(It was used before in a code segment that now uses blk_end_request_all())

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e410d66..d7c6c75 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -706,7 +706,6 @@ EXPORT_SYMBOL(scsi_release_buffers);
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -789,7 +788,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 */
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
-	this_count = blk_rq_bytes(req);
 
 	error = -EIO;
 
-- 
1.6.2.1
