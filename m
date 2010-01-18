Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008Ab0ARTHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0ARTHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985Ab0ARTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:07:14 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:15570 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755902Ab0ARTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:07:12 -0500
Message-ID: <4B54B0F5.1040405@ru.mvista.com>
Date: Mon, 18 Jan 2010 22:05:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/64] pata_cypress: fix PIO timings underclocking
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171547.14623.54536.sendpatchset@localhost>
In-Reply-To: <20100118171547.14623.54536.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_cypress: fix PIO timings underclocking
>
> Timing registers should be programmed with the desired number of clocks
> minus one clock.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_cypress.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> Index: b/drivers/ata/pata_cypress.c
> ===================================================================
> --- a/drivers/ata/pata_cypress.c
> +++ b/drivers/ata/pata_cypress.c
>   
[...]
> @@ -79,7 +81,7 @@ static void cy82c693_set_piomode(struct
>  		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
>  
>  		addr &= ~0xF0;	/* Mask bits */
> -		addr |= (clamp_val(t.setup, 0, 15) << 4);
> +		addr |= (clamp_val(t.setup - 1, 0, 15) << 4);
>   

   You could drop the unneeded parens while at it...

MBR, Sergei

