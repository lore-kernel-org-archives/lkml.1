Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYBSMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYBSMcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYBSMcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:32:00 -0500
Received: from homer.mvista.com ([63.81.120.155]:4257 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773AbYBSMb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:31:59 -0500
Message-ID: <47BACC7C.6030305@ru.mvista.com>
Date: Tue, 19 Feb 2008 15:33:00 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ide-generic: use ide_find_port()
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain> <20080217185133.16210.73293.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185133.16210.73293.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-generic.c
> ===================================================================
> --- a/drivers/ide/ide-generic.c
> +++ b/drivers/ide/ide-generic.c
> @@ -90,18 +90,27 @@ static int __init ide_generic_init(void)
>  	int i;
>  
>  	for (i = 0; i < MAX_HWIFS; i++) {
> -		ide_hwif_t *hwif = &ide_hwifs[i];
> +		ide_hwif_t *hwif;
>  		unsigned long io_addr = ide_default_io_base(i);
>  		hw_regs_t hw;
>  
> -		if (hwif->chipset == ide_unknown && io_addr) {
> -			u8 oldnoprobe = hwif->noprobe;
> +		if (io_addr) {
> +			u8 oldnoprobe;
> +
> +			/*
> +			 * Skip probing if the corresponding
> +			 * slot entry is already occupied.

    IMHO, it's either "slot" or "entry", else it sounds superfluous. :-)

MBR, Sergei
