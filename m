Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZKESt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZKESt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZKESt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:49:28 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45574 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbZKESt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=R8TYwpYoRLP88QlWb0iPe5iypDoea+Vxfu6R9t/w86QMIOI1HfMpuhUSjWyRSs0cDp
         lhdjxbtZOHzaz46eZ9781gq60wPuD2w8TB2OPudveHz3/ZGsGBVOaoc++YhwnfKAnOwF
         IUMwGdoXln7HaA7WZ5KQPhj2L3ZBjSbOEkIJI=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 13/41] rt2800usb: add rt2800_regbusy_read() wrapper
Date: Thu, 5 Nov 2009 19:49:28 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173334.28463.13649.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173334.28463.13649.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051949.28617.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add rt2800_regbusy_read() wrapper
> 
> Part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

The macros are the same for rt2800pci and rt2800usb.
So it might be better to move the entire define set into rt2800lib.h

If you haven't done so already in a subsequent patch, please fix it,
otherwise:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Ivo

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++-----
>  drivers/net/wireless/rt2x00/rt2800usb.h |    8 ++++++++
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -58,14 +58,14 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>   * The _lock versions must be used if you already hold the csr_mutex
>   */
>  #define WAIT_FOR_BBP(__dev, __reg) \
> -	rt2x00usb_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
>  #define WAIT_FOR_RFCSR(__dev, __reg) \
> -	rt2x00usb_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
>  #define WAIT_FOR_RF(__dev, __reg) \
> -	rt2x00usb_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
>  #define WAIT_FOR_MCU(__dev, __reg) \
> -	rt2x00usb_regbusy_read((__dev), H2M_MAILBOX_CSR, \
> -			       H2M_MAILBOX_CSR_OWNER, (__reg))
> +	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
> +			    H2M_MAILBOX_CSR_OWNER, (__reg))
>  
>  static void rt2800usb_bbp_write(struct rt2x00_dev *rt2x00dev,
>  				const unsigned int word, const u8 value)
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.h
> @@ -62,6 +62,14 @@ static inline void rt2x00_register_multi
>  	rt2x00usb_register_multiwrite(rt2x00dev, offset, value, length);
>  }
>  
> +static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
> +				      const unsigned int offset,
> +				      struct rt2x00_field32 field,
> +				      u32 *reg)
> +{
> +	return rt2x00usb_regbusy_read(rt2x00dev, offset, field, reg);
> +}
> +
>  /*
>   * RF chip defines.
>   *
> 


