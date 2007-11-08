Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbXKHJJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbXKHJJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbXKHJJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:09:06 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:45035 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbXKHJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:09:01 -0500
Subject: Re: *SPAM* Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Roland Dreier <roland@digitalvampire.org>
Cc: Willy Tarreau <w@1wt.eu>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	 <1194259886.6927.9.camel@localhost>
	 <20071105132218.495f244e@poseidon.drzeus.cx>
	 <1194270393.27789.2.camel@localhost>
	 <20071105162633.09e54290@poseidon.drzeus.cx>
	 <1194343121.6953.6.camel@rukbat> <20071106195148.GD1045@1wt.eu>
	 <1194385693.12938.5.camel@rukbat> <1194387459.5205.2.camel@rukbat>
	 <1194472374.7176.4.camel@rukbat>
	 <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 08 Nov 2007 09:46:07 +0100
Message-Id: <1194511567.7115.1.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-07 at 15:37 -0800, Roland Dreier wrote:
> .
> 
> Pierre, assuming Romano tests this patch successfully, please apply!
> 

Hi, the patch below solves the problem with my SD card. 

Tested-by: Romano Giannetti <romano.giannetti@gmail.com>

Thanks!

	Romano

> <-- patch below -->
> 
> mmc: Fix sg helper copy-and-paste error
> 
> Commit 45711f1a ("[SG] Update drivers to use sg helpers") had the
> following bogus change in drivers/mmc/card/queue.c:
> 
>     > -			src_buf = page_address(src->page) + src->offset;
>     > +			src_buf = sg_virt(dst);
> 
> (Notice that "src" is converted to "dst").  Turn this "dst" back into
> the intended "src".
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> ---
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 9203a0b..1b9c9b6 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -310,7 +310,7 @@ static void copy_sg(struct scatterlist *dst, unsigned int dst_len,
>  		}
>  
>  		if (src_size == 0) {
> -			src_buf = sg_virt(dst);
> +			src_buf = sg_virt(src);
>  			src_size = src->length;
>  		}
>  
-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
