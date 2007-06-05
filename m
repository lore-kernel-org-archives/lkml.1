Return-Path: <linux-kernel-owner+w=401wt.eu-S1764137AbXFERT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764137AbXFERT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbXFERTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:19:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXFERTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:19:21 -0400
Message-ID: <4665988A.5060902@redhat.com>
Date: Tue, 05 Jun 2007 13:08:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Masatake YAMATO <jet@gyve.org>
CC: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] never called printk statement in ide-taskfile.c::wait_drive_not_busy
References: <20070605.112124.28713903.jet@gyve.org>
In-Reply-To: <20070605.112124.28713903.jet@gyve.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2007 10:21 PM, Masatake YAMATO wrote:
> diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
> index 30175c7..5e05311 100644
> --- a/drivers/ide/ide-taskfile.c
> +++ b/drivers/ide/ide-taskfile.c
> @@ -249,7 +249,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
>  	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
>  		udelay(10);
>  
> -	if (!retries)
> +	if (retries < 0)

	if (stat & BUSY_STAT)

>  		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
>  
>  	return stat;
