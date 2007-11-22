Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbXKVAtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbXKVAtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXKVAtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:49:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:1249 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXKVAtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Vg5PUZUWpU4W2eBLoppCZvYQratJU9sWyxw8qsxnZVKzqFl3AAYsrHJM6hDbKoCmpPnV26IoD+FgTsZzvHzQije9wEkHrxKbfeZglOPsBJhol/1NML6P+cZsJvrmqQ4rxY6vdsmTmfGangddjkVJOS2hZTrZBDqCWzmAqgPCnYQ=
Message-ID: <4744D1EF.5010406@gmail.com>
Date: Thu, 22 Nov 2007 09:48:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] sata_nv: don't use legacy DMA in ADMA mode
References: <473A7628.3010907@shaw.ca> <473BA447.6090909@gmail.com> <473BA4D8.508@gmail.com> <474382D8.1050507@shaw.ca>
In-Reply-To: <474382D8.1050507@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> Tejun Heo wrote:
>>> If so, can you please add that switching into register mode is okay as
>>> long as there's no other ADMA commands in flight and add
>>> WARN_ON((qc->flags & ATA_QCFLAG_RESULT_TF) && link->sactive)?
>>
>> More accurately, link->sactive test can be substituted with
>> (ap->qc_allocated & ~(1 << qc->tag)).
> 
> Unfortunately we only get the ata_port and ata_taskfile in the tf_read
> callback, so I'm not sure if we can do the equivalent of the qc->flags &
> ATA_QCFLAG_RESULT_TF test (i.e. distinguishing between the
> error-handling case where we care if we abort outstanding commands and
> the normal case with a RESULT_TF command where we do)..

You can test it in ->qc_issue(), no?

-- 
tejun
