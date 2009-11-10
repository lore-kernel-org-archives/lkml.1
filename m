Return-Path: <linux-kernel-owner+w=401wt.eu-S1750876AbZKJFAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbZKJFAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZKJFAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:00:16 -0500
Received: from rtr.ca ([76.10.145.34]:34341 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZKJFAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:00:15 -0500
Message-ID: <4AF8F363.3010806@rtr.ca>
Date: Tue, 10 Nov 2009 00:00:19 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
Cc: jgarzik@pobox.com, mlord@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
In-Reply-To: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> Use ARRAY_SIZE macro of kernel api instead.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/ata/sata_mv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 6f5093b..a8a7be0 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
>  	int err = 0;
>  
>  	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
> -	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
> +	err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
>  	if (err)
>  		return err;
>  
..

What's the point of this ?

There is no "hardcoded array size" there to begin with,
and using that silly macro obscures the actual calculation.

So now, instead of being able to verify correctness at a glance,
I have to go off and research some silly macro and verify that
it does the right thing.

Kind of like all of those "typedef structs" that are abhored around here.

-ml
