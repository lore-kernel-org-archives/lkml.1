Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXEQVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXEQVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXEQVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:15:45 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50909 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbXEQVPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:15:44 -0400
Date: Thu, 17 May 2007 23:11:17 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peer Chen <pchen@nvidia.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
In-Reply-To: <20070517131742.029e9fd0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705172308410.3231@yvahk01.tjqt.qr>
References: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com>
 <464A94D7.30300@garzik.org> <15F501D1A78BD343BE8F4D8DB854566B13F197C0@hkemmail01.nvidia.com>
 <20070517131235.8f9445cc.akpm@linux-foundation.org>
 <20070517131742.029e9fd0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 13:17, Andrew Morton wrote:
>> @@ -2115,7 +2115,7 @@ static void nv_fill_sg(struct ata_queued
>>  	WARN_ON(qc->__sg == NULL);
>>  	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
>>  
>> -	prd = (struct ata_prd*)((u64)pp->prd + ATA_PRD_TBL_SZ*qc->tag);
>> +	prd = pp->prd + ATA_PRD_TBL_SZ*qc->tag;
>>  
>>  	idx = 0;
>>  	ata_for_each_sg(sg, qc) {
>
>hm, no.
>
>ugh, I dunno what's going on here and I think I'd prefer not to.  Can't
>we come up with some typesafe way of doing this without casting?
>
>Meanwhile, I'll switch the cast from u64 to long.

Maybe this?

	prd = (void *)pp->prd + ATA_PRD_TBL_SZ * qc->tag

Or...

	prd = pp->prd + (ATA_PRD_TBL_SZ * qc->tag) / sizeof(typeof(pp->prd));


	Jan
-- 
