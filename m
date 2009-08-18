Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZHRITz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZHRITz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZHRITy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:19:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbZHRITx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:19:53 -0400
Date: Tue, 18 Aug 2009 01:19:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-mtd@lists.infradead.org,
       davinci-linux-open-source@linux.davincidsp.com, david-b@pacbell.net,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MTD] driver/Makefile: Initialize "mtd" and "spi"
 before "net"
Message-Id: <20090818011930.765d4895.akpm@linux-foundation.org>
In-Reply-To: <1250613244-25447-1-git-send-email-sudhakar.raj@ti.com>
References: <1250613244-25447-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 12:34:04 -0400 Sudhakar Rajashekhara <sudhakar.raj@ti.com> wrote:

> On TI's da850/omap-l138 EVM, MAC address is stored in SPI flash.
> 
> This patch changes the initialization sequence of the drivers
> by moving mtd and spi ahead of net in drivers/Makefile thereby
> enabling da850/omap-l138 ethernet driver to read the MAC address
> while booting.
> 
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> ---
>  drivers/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index bc4205d..2a1d41f 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -42,6 +42,8 @@ obj-y				+= macintosh/
>  obj-$(CONFIG_IDE)		+= ide/
>  obj-$(CONFIG_SCSI)		+= scsi/
>  obj-$(CONFIG_ATA)		+= ata/
> +obj-$(CONFIG_MTD)		+= mtd/
> +obj-$(CONFIG_SPI)		+= spi/
>  obj-y				+= net/
>  obj-$(CONFIG_ATM)		+= atm/
>  obj-$(CONFIG_FUSION)		+= message/
> @@ -50,8 +52,6 @@ obj-y				+= ieee1394/
>  obj-$(CONFIG_UIO)		+= uio/
>  obj-y				+= cdrom/
>  obj-y				+= auxdisplay/
> -obj-$(CONFIG_MTD)		+= mtd/
> -obj-$(CONFIG_SPI)		+= spi/
>  obj-$(CONFIG_PCCARD)		+= pcmcia/
>  obj-$(CONFIG_DIO)		+= dio/
>  obj-$(CONFIG_SBUS)		+= sbus/

That isn't a particularly maintainable way of fixing this, especially
as there are no comments in that Makefile to prevent someone from
rebreaking it in the future.

A better fix would be to use suitably prioritised initcalls - see
include/linux/init.h around line 187.

