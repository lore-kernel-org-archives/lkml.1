Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYIUTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYIUTXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIUTXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:23:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:58026 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbYIUTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:23:14 -0400
Message-ID: <48D69F5A.9010201@ru.mvista.com>
Date: Sun, 21 Sep 2008 23:24:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost>
In-Reply-To: <20080921185138.GA16310@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark de Wever wrote:

> After updating my kernel to 2.6.26 the output for the ide-tape drive
> during booting is garbled eg
> ide-tape: hdd <-> ht0: Seagate <98>ß8A51|1À<81>Üº<98>ß STT20000A rev 8A51|1À<81>Üº<98>ß

> This patch fixes the problem by NULL terminating the strings.

> Regards,
> Mark de Wever

> PS: please CC me since I'm not subscribed.
> PPS: there are more problems with my tapestreamer in 2.6.26 but I'll
> post a separate message for that.

> Signed-off-by: Mark de Wever <koraq@xs4all.nl>

> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 1bce84b..fd87b43 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2354,6 +2354,10 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  	ide_fixstring(product_id, 18, 0);
>  	ide_fixstring(fw_rev, 6, 0);
>  
> +	fw_rev[4] = '\0';
> +	vendor_id[8] = '\0';
> +	product_id[16] = '\0';
> +
>  	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
>  			drive->name, tape->name, vendor_id, product_id, fw_rev);

    This is not quite correct way to tackle this.  More correct would be to 
fix the format specifiers in this printk() to only print no more than N string 
characters like this:

  	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
  		drive->name, tape->name, vendor_id, product_id, fw_rev);

MBR, Sergei
