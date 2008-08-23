Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYHWVqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYHWVqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 17:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYHWVp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 17:45:57 -0400
Received: from h155.mvista.com ([63.81.120.155]:35064 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbYHWVp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 17:45:56 -0400
Message-ID: <48B0850D.4000105@ru.mvista.com>
Date: Sun, 24 Aug 2008 01:45:49 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ide-disk: set_addressing() fixes
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain> <20080817171501.27943.57473.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171501.27943.57473.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Return -EIO if arg > 0 and LBA48 is unsupported.
>
> * No need to reset ->addressing.
>
> * Make ->addressing a single bit flag.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   
[...]
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -507,7 +507,7 @@ struct ide_drive_s {
>  	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
>  	unsigned post_reset	: 1;
>  	unsigned udma33_warned	: 1;
> -	unsigned addressing	: 2;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
> +	unsigned addressing	: 1;	/* 0=28-bit, 1=48-bit */
>  	unsigned wcache		: 1;	/* status of write cache */
>  	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
>   

   Don't you want to get rid of things like:

        u8 lba48 = (drive->addressing == 1) ? 1 : 0;

MBR, Sergei


