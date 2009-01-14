Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbZANIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbZANIZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZANIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:25:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbZANIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:25:37 -0500
Date: Wed, 14 Jan 2009 00:25:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Carsten Schlote <c.schlote@konzeptpark.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH][ATA] Add ide-disk led-trigger to ATA subsystem
Message-Id: <20090114002522.d2388f7a.akpm@linux-foundation.org>
In-Reply-To: <1231600107.10065.4.camel@kplaws107lx>
References: <1231600107.10065.4.camel@kplaws107lx>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

On Sat, 10 Jan 2009 16:08:27 +0100 Carsten Schlote <c.schlote@konzeptpark.de> wrote:

> - Adds a call to ide-disk LED trigger to libata-sff.c
> - Changed Kconfig to allow for ide-disk LED trigger when ATA drivers
>   are enabled.
> 
> Open Issue:
> - There might be more suitable place to call the trigger function.
>   Only devices using libata-sff.c trigger LEDs right now.
> 
> Signed-off-by: Carsten Schlote <c.schlote@konzeptpark.de>
> ---
>  drivers/ata/libata-sff.c |    3 +++
>  drivers/leds/Kconfig     |    2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: .kernel/drivers/leds/Kconfig
> ===================================================================
> --- .kernel.orig/drivers/leds/Kconfig	2009-01-07 22:13:40.000000000
> +0100
> +++ .kernel/drivers/leds/Kconfig	2009-01-07 22:14:46.000000000 +0100
> @@ -185,7 +185,7 @@
>  
>  config LEDS_TRIGGER_IDE_DISK
>  	bool "LED IDE Disk Trigger"
> -	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK
> +	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK || ATA
>  	help
>  	  This allows LEDs to be controlled by IDE disk activity.
>  	  If unsure, say Y.
> Index: .kernel/drivers/ata/libata-sff.c
> ===================================================================
> --- .kernel.orig/drivers/ata/libata-sff.c	2009-01-07 22:14:09.000000000
> +0100
> +++ .kernel/drivers/ata/libata-sff.c	2009-01-07 22:14:46.000000000 +0100
> @@ -36,6 +36,7 @@
>  #include <linux/pci.h>
>  #include <linux/libata.h>
>  #include <linux/highmem.h>
> +#include <linux/leds.h>
>  
>  #include "libata.h"
>  
> @@ -647,6 +648,8 @@
>   */
>  void ata_sff_exec_command(struct ata_port *ap, const struct
> ata_taskfile *tf)
>  {
> +	ledtrig_ide_activity();
> +
>  	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
>  
>  	iowrite8(tf->command, ap->ioaddr.command_addr);
> 

