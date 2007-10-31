Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXJaIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXJaIRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXJaIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:17:28 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1746 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXJaIR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:17:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH]: exit_ivtv_i2c() cannot be __devexit
Date: Wed, 31 Oct 2007 09:17:12 +0100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20071030.212348.210855016.davem@davemloft.net>
In-Reply-To: <20071030.212348.210855016.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710310917.12832.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 05:23, David Miller wrote:
> Please apply, thanks!
>
> [MEDIA] IVTV: exit_ivtv_i2c() cannot be __devexit
>
> It is referenced both from __devinit code (ivtv_probe) and
> normal .text (ivtv_process_eeprom), and therefore cannot
> be discarded via __devexit.

Good catch!

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks,

	Hans

>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/media/video/ivtv/ivtv-i2c.c |    2 +-
>  drivers/media/video/ivtv/ivtv-i2c.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c
> b/drivers/media/video/ivtv/ivtv-i2c.c index 285fca6..623eea2 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -741,7 +741,7 @@ int __devinit init_ivtv_i2c(struct ivtv *itv)
>  		return i2c_bit_add_bus(&itv->i2c_adap);
>  }
>
> -void __devexit exit_ivtv_i2c(struct ivtv *itv)
> +void exit_ivtv_i2c(struct ivtv *itv)
>  {
>  	IVTV_DEBUG_I2C("i2c exit\n");
>
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.h
> b/drivers/media/video/ivtv/ivtv-i2c.h index 677c329..de6a074 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.h
> +++ b/drivers/media/video/ivtv/ivtv-i2c.h
> @@ -36,6 +36,6 @@ void ivtv_call_i2c_clients(struct ivtv *itv,
> unsigned int cmd, void *arg);
>
>  /* init + register i2c algo-bit adapter */
>  int __devinit init_ivtv_i2c(struct ivtv *itv);
> -void __devexit exit_ivtv_i2c(struct ivtv *itv);
> +void exit_ivtv_i2c(struct ivtv *itv);
>
>  #endif
