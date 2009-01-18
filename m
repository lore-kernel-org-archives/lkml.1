Return-Path: <linux-kernel-owner+w=401wt.eu-S1764732AbZARIV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764732AbZARIV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZARIVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:21:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54464 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZARIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:21:47 -0500
Date: Sun, 18 Jan 2009 09:11:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: Carsten Schlote <c.schlote@konzeptpark.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ATA] Add ide-disk led-trigger to ATA subsystem
Message-ID: <20090118081140.GA1944@ucw.cz>
References: <1231600107.10065.4.camel@kplaws107lx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231600107.10065.4.camel@kplaws107lx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-10 16:08:27, Carsten Schlote wrote:
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

()s might be nice?

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

Is there a more generic place so that we won't have to modify all the
libata drivers?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
