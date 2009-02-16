Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZBPUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZBPUnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZBPUnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:43:05 -0500
Received: from ns2.mvista.com ([63.81.120.155]:1786 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881AbZBPUnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:43:03 -0500
Message-ID: <4999CFEB.3030204@ru.mvista.com>
Date: Mon, 16 Feb 2009 23:43:23 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <liml@rtr.ca>,
       =?UTF-8?B?SGFubm8=?= =?UTF-8?B?IELDtmNr?= <hanno@hboeck.de>
Subject: Re: [PATCH] libata: Don't trust current capacity values in identify
 words 57-58
References: <4999CA54.1060306@gmail.com>
In-Reply-To: <4999CA54.1060306@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> Hanno Böck reported a problem where an old Conner CP30254 240MB hard drive
> was reported as 1.1TB in capacity by libata:

> http://lkml.org/lkml/2009/2/13/134

> This was caused by libata trusting the drive's reported current capacity in 
> sectors in identify words 57 and 58 if the drive does not support LBA and the
> current CHS translation values appear valid. Unfortunately it seems older
> ATA specs were vague about what this field should contain and a number of drives
> used values with wrong byte order or that were totally bogus. There's no
> unique information that it conveys and so we can just calculate the number
> of sectors from the reported current CHS values.

> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

> ---

> Should likely go into -next for testing for a while. Of course, the fact that
> this problem showed up in the first place shows that the number of people
> that test libata with such boat anchors is fairly small :-)

    It's been tested well enough for years in the IDE core I think.

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 9fbf059..5389cbc 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1327,7 +1327,7 @@ static u64 ata_id_n_sectors(const u16 *id)
>  			return ata_id_u32(id, 60);
>  	} else {
>  		if (ata_id_current_chs_valid(id))
> -			return ata_id_u32(id, 57);
> +			return id[54] * id[55] * id[56];

    We have mnemonics for these 3 words in <linux/ata.h>...

MBR, Sergei
