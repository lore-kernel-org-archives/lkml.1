Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZHXQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZHXQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZHXQcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:32:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53253 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZHXQcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:32:05 -0400
Message-ID: <4A92C081.50207@garzik.org>
Date: Mon, 24 Aug 2009 12:32:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] libata: use lazy workqueues for the pio task
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com> <1251100616-28604-5-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1251100616-28604-5-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 03:56 AM, Jens Axboe wrote:
> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
> ---
>   drivers/ata/libata-core.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 072ba5e..35f74c9 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>   {
>   	ata_parse_force_param();
>
> -	ata_wq = create_workqueue("ata");
> +	ata_wq = create_lazy_workqueue("ata");
>   	if (!ata_wq)
>   		goto free_force_tbl;

No objections to the code, operationally...

But it is disappointing that the "1 thread on UP" problem is not solved 
while changing this libata area.  Is there no way to specify a minimum 
lazy-thread count?

A key problem continues to be tying to the number of CPUs, which is 
quite inappropriate for libata.

	Jeff



