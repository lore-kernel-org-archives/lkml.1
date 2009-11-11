Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbZKKXKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbZKKXKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZKKXKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:10:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54418 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759529AbZKKXKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:10:17 -0500
Message-ID: <4AFB4455.3040407@pobox.com>
Date: Wed, 11 Nov 2009 18:10:13 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Thiago Farina <tfransosi@gmail.com>, mlord@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com> <4AF8F363.3010806@rtr.ca>
In-Reply-To: <4AF8F363.3010806@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 12:00 AM, Mark Lord wrote:
> Thiago Farina wrote:
>> Use ARRAY_SIZE macro of kernel api instead.
>>
>> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
>> ---
>> drivers/ata/sata_mv.c | 2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index 6f5093b..a8a7be0 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct
>> ata_queued_cmd *qc)
>> int err = 0;
>>
>> ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
>> - err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
>> + err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
>> if (err)
>> return err;
>>
> ..
>
> What's the point of this ?
>
> There is no "hardcoded array size" there to begin with,
> and using that silly macro obscures the actual calculation.
>
> So now, instead of being able to verify correctness at a glance,
> I have to go off and research some silly macro and verify that
> it does the right thing.

It is a standard cleanup for all kernel code, and it does make the code 
more readable to the casual reader / quick skimmer.

	Jeff




