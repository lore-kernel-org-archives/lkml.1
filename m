Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbYBCRP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbYBCRP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbYBCRPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:15:50 -0500
Received: from h155.mvista.com ([63.81.120.155]:54974 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757588AbYBCRPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:15:49 -0500
Message-ID: <47A5F6FA.3000107@ru.mvista.com>
Date: Sun, 03 Feb 2008 20:16:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH] ide-tape: dump gcw fields on error in idetape_identify_device()
References: <200802021922.56703.bzolnier@gmail.com>
In-Reply-To: <200802021922.56703.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-tape.c
> ===================================================================
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -3852,16 +3852,17 @@ static int idetape_identify_device (ide_
>  
>  	/* Check that we can support this device */
>  
> -	if (gcw.protocol !=2 )
> -		printk(KERN_ERR "ide-tape: Protocol is not ATAPI\n");
> +	if (gcw.protocol != 2)
> +		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
> +				gcw.protocol);
>  	else if (gcw.device_type != 1)
> -		printk(KERN_ERR "ide-tape: Device type is not set to tape\n");
> +		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
> +				"to tape\n", gcw.device_type);
>  	else if (!gcw.removable)
>  		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
>  	else if (gcw.packet_size != 0) {
> -		printk(KERN_ERR "ide-tape: Packet size is not 12 bytes long\n");
> -		if (gcw.packet_size == 1)
> -			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes is still not supported\n");
> +		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
> +				"bytes long\n", gcw.packet_size);

    Shouldn't it be either "packet size is not 12 byted" or "packet is not 12 
bytes long"?

MBR, Sergei
