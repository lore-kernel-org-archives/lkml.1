Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYGZQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYGZQTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYGZQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:19:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26645 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYGZQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:19:31 -0400
Date: Sat, 26 Jul 2008 09:18:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] ide: sanitize struct ide_port_ops documentation
Message-Id: <20080726091854.a6ce1268.randy.dunlap@oracle.com>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 15:40:10 +0200 Bartlomiej Zolnierkiewicz wrote:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> some easy/trivial changes just to keep the ball rolling...
> 
>  include/linux/ide.h |   27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -508,24 +508,33 @@ struct ide_tp_ops {
>  
>  extern const struct ide_tp_ops default_tp_ops;
>  
> +/**
> + * struct ide_port_ops - IDE port operations
> + *
> + * init_dev:		host specific initialization of a device

Good idea, Bart, but please put an '@' in front of each field name, e.g.,

 * @init_dev:		host specific ...

See Documentation/kernel-doc-nano-HOWTO.txt for details (or ask).

> + * set_pio_mode:	routine to program host for PIO mode
> + * set_dma_mode:	routine to program host for DMA mode
> + * selectproc:		tweaks hardware to select drive
> + * reset_poll:		chipset polling based on hba specifics
> + * pre_reset:		chipset specific changes to default for device-hba resets
> + * resetproc:		routine to reset controller after a disk reset
> + * maskproc:		special host masking for drive selection
> + * quirkproc:		check host's drive quirk list
> + *
> + * mdma_filter:		filter MDMA modes
> + * udma_filter:		filter UDMA modes
> + *
> + * cable_detect:	detect cable type
> + */
>  struct ide_port_ops {
> -	/* host specific initialization of a device */
>  	void	(*init_dev)(ide_drive_t *);
> -	/* routine to program host for PIO mode */
>  	void	(*set_pio_mode)(ide_drive_t *, const u8);
> -	/* routine to program host for DMA mode */
>  	void	(*set_dma_mode)(ide_drive_t *, const u8);
> -	/* tweaks hardware to select drive */
>  	void	(*selectproc)(ide_drive_t *);
> -	/* chipset polling based on hba specifics */
>  	int	(*reset_poll)(ide_drive_t *);
> -	/* chipset specific changes to default for device-hba resets */
>  	void	(*pre_reset)(ide_drive_t *);
> -	/* routine to reset controller after a disk reset */
>  	void	(*resetproc)(ide_drive_t *);
> -	/* special host masking for drive selection */
>  	void	(*maskproc)(ide_drive_t *, int);
> -	/* check host's drive quirk list */
>  	void	(*quirkproc)(ide_drive_t *);
>  
>  	u8	(*mdma_filter)(ide_drive_t *);
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
