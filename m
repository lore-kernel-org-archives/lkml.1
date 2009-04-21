Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZDUMQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZDUMQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZDUMQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:16:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDUMQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:16:31 -0400
Message-ID: <49EDB8EF.7040503@vlnb.net>
Date: Tue, 21 Apr 2009 16:15:43 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org> <49EB036B.8090607@panasas.com>
In-Reply-To: <49EB036B.8090607@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX184VTthQa12I7upGE2tN83hJ2M95/JpetgHneY
 Kw764sGfppxmJo6DK12Pe3SQogjvfGXZzP2qFJgS6NpBLukXLb
 jq9A/yOkf9PUJYcIYy8/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh, on 04/19/2009 02:56 PM wrote:
> On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:

[..]

> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
> 
> I'm not sure what would be the best alternative for you. I would say
> a bio, but it is still being debated. Your current options are:
> 
> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>    (Which block people don't like)
> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>    struct rq_map_data mode. (not possible with all kind of sglists)
> 2. sglist => iovec translation and blk_rq_map_user_iov()
>    (Very very ugly mapping of pages to virtual pointers)
> 
> I have a similar situation with my OSD code.

Do you have somewhere in it a need to run an arbitrary CDB with data 
pages stored in an sglist? Is that code accepted in the mainline?

If yes, why not to resurrect the necessary bits of scsi_execute_async() 
(option (1) above)? It was deleted, because in 2.6.30 there are no users 
of it left, but if there are users (OSD), then why not to return it? 
Seems nothing better for the sg->bio case can be invented.

Vlad
