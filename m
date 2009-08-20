Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZHTMmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZHTMmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZHTMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:42:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55681 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZHTMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:42:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A8D4458.5060206@s5r6.in-berlin.de>
Date: Thu, 20 Aug 2009 14:40:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 4/6] libata: use lazy workqueues for the pio task
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <1250763604-24355-5-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1250763604-24355-5-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/ata/libata-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 072ba5e..35f74c9 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>  {
>  	ata_parse_force_param();
>  
> -	ata_wq = create_workqueue("ata");
> +	ata_wq = create_lazy_workqueue("ata");
>  	if (!ata_wq)
>  		goto free_force_tbl;
>  

However, this does not solve the issue of lacking parallelism on UP 
machines, does it?
-- 
Stefan Richter
-=====-==--= =--- =-=--
http://arcgraph.de/sr/
