Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXIZChu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXIZChu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXIZChl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:37:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38943 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbXIZChk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:37:40 -0400
Message-ID: <46F9C5ED.6050505@garzik.org>
Date: Tue, 25 Sep 2007 22:37:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com
CC: akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
References: <1190768402.8707.20.camel@localhost.localdomain>	<20070925065233Q.tomof@acm.org>	<1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org>
In-Reply-To: <20070925073735U.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index adc9559..694015d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -342,6 +342,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> +
> +	if (!sht->supported_mode)
> +		sht->supported_mode = MODE_INITIATOR;
> +
>  	shost->active_mode = sht->supported_mode;


I almost hesitate to speak up, after making the original suggestion, but:

Are there any const-ness worries for scsi_host_template, or plans for 
the future?  I do not see any other examples of the host template 
members getting modified.

Perhaps this value should instead be mirrored in scsi_host, like many 
others?

	Jeff


