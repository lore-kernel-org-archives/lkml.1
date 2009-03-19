Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZCSDE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZCSDE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 23:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZCSDEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 23:04:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:53362 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZCSDEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 23:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pmWIstGZdtKJGHwHeaDnMv3SiVhQ8/TBxoR6hpmZwbG76n826Wucgco38bQ0WHjYPM
         WJ6Yby4titgoLiX0slRykVVsryAoFelszDN+/8Kv6E13DX4kCnwsApxdG98sfCNIRiIr
         7a1YzPratSBhPTcXTjAmqH+gbV0acbVk4DGxo=
MIME-Version: 1.0
Date: Thu, 19 Mar 2009 11:04:13 +0800
Message-ID: <d364733c0903182004p56aefff7ybb2786fc0dc4d40@mail.gmail.com>
Subject: The meaning of new_batch in Linux AS I/O scheduler
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm little confused about the semantic of new_batch in Linux AS I/O scheduler.
As the comments mentioned, if it's 1, then it stands for that AS will
wait for the first read to complete. There is comments in defination:
/* 1: waiting on first read complete */

But there is another comments in as_completed_request:
/*
        * Start counting the batch from when a request of that direction is
        * actually serviced. This should help devices with big TCQ windows
        * and writeback caches
        */
       if (ad->new_batch && ad->batch_data_dir == rq_is_sync(rq)) {
               update_write_batch(ad);
               ad->current_batch_expires = jiffies +
                               ad->batch_expire[REQ_SYNC];
               ad->new_batch = 0;
       }

>From this comments and code, it seems that, new_batch does not only
work for read batch but also work for write batch, which conflicts
with the comments in defination. If it's only used when read batching,
why do we need to check the batch dir: ad->batch_data_dir ==
rq_is_sync(rq) (now, we are definitely in read batching ).

Thanks



-- 
Xie Gang
