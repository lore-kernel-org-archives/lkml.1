Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYGUVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYGUVC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYGUVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:02:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60628 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbYGUVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:02:49 -0400
Date: Mon, 21 Jul 2008 21:45:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: use proper printk() KERN_* levels in ide-probe.c
Message-ID: <20080721214535.6de8c6a0@lxorguk.ukuu.org.uk>
In-Reply-To: <200807212108.15505.bzolnier@gmail.com>
References: <200807212108.15505.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 21:08:15 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> While at it:
> 
> - fixup printk() messages in save_match() and hwif_init().
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-probe.c |   54 ++++++++++++++++++++++++++----------------------
>  1 file changed, 30 insertions(+), 24 deletions(-)
> 
> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -141,7 +141,8 @@ static inline void do_identify (ide_driv
>  	 */
>  	if ((id->model[0] == 'P' && id->model[1] == 'M') ||
>  	    (id->model[0] == 'S' && id->model[1] == 'K')) {
> -		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
> +		printk(KERN_ERR "%s: EATA SCSI HBA %.10s\n",
> +			drive->name, id->model);

That isn't an error. It occurs normally using legacy IDE with an EATA HBA
present in ATA emulating mode.

