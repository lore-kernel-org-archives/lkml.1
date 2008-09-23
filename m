Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYIWRD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYIWRD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYIWRDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:03:49 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2518 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYIWRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:03:48 -0400
Date: Tue, 23 Sep 2008 18:59:14 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: petkovbb@gmail.com, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080923165914.GA7803@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923074845.GB5656@gollum.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 09:48:45AM +0200, Borislav Petkov wrote:
> ---
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 1bce84b..3833189 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
>  	struct ide_atapi_pc pc;
> -	char fw_rev[6], vendor_id[10], product_id[18];
> +	char fw_rev[4], vendor_id[8], product_id[16];
>  
>  	idetape_create_inquiry_cmd(&pc);
>  	if (idetape_queue_pc_tail(drive, &pc)) {
> @@ -2350,11 +2350,11 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  	memcpy(product_id, &pc.buf[16], 16);
>  	memcpy(fw_rev, &pc.buf[32], 4);
>  
> -	ide_fixstring(vendor_id, 10, 0);
> -	ide_fixstring(product_id, 18, 0);
> -	ide_fixstring(fw_rev, 6, 0);
> +	ide_fixstring(vendor_id, 8, 0);
> +	ide_fixstring(product_id, 16, 0);
> +	ide_fixstring(fw_rev, 4, 0);
>  
> -	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
> +	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
>  			drive->name, tape->name, vendor_id, product_id, fw_rev);
>  }
>  
>

I think this patch looks good, better as all previous versions
(including my initial version). I just tested it and it solves the
problem. Feel free to add my tested-by.

Regards,
Mark de Wever

PS I was not able to test earlier ;-)
