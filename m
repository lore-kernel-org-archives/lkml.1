Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZKESta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZKESta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZKESt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:49:29 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62926 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZKESt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=muVzFUpijGylMaZmET33R/dFGKEub4+cAuNX6quVEtFXPOQ8I9SZ8s+vcXppNXuOJy
         qNjQX6LYNlmgPN+TdSFJPdBjGoZN6jDLmnxWeIpTWnlMBJ1joPvuhFtmJ+LT9gwUgDnW
         EJSwO9GxXwhzkCSepkr1/ozAYFfjOT2X0m138=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 14/41] rt2800pci: add rt2800_regbusy_read() wrapper
Date: Thu, 5 Nov 2009 19:49:29 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173341.28463.11122.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173341.28463.11122.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051949.30187.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_regbusy_read() wrapper
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
>  drivers/net/wireless/rt2x00/rt2800pci.c |   12 ++++++------
>  drivers/net/wireless/rt2x00/rt2800pci.h |    8 ++++++++
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -69,14 +69,14 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>   * The _lock versions must be used if you already hold the csr_mutex
>   */
>  #define WAIT_FOR_BBP(__dev, __reg) \
> -	rt2x00pci_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
>  #define WAIT_FOR_RFCSR(__dev, __reg) \
> -	rt2x00pci_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
>  #define WAIT_FOR_RF(__dev, __reg) \
> -	rt2x00pci_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
> +	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
>  #define WAIT_FOR_MCU(__dev, __reg) \
> -	rt2x00pci_regbusy_read((__dev), H2M_MAILBOX_CSR, \
> -			       H2M_MAILBOX_CSR_OWNER, (__reg))
> +	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
> +			    H2M_MAILBOX_CSR_OWNER, (__reg))
>  
>  static void rt2800pci_bbp_write(struct rt2x00_dev *rt2x00dev,
>  				const unsigned int word, const u8 value)
> @@ -350,7 +350,7 @@ static void rt2800pci_efuse_read(struct 
>  	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
>  
>  	/* Wait until the EEPROM has been loaded */
> -	rt2x00pci_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
> +	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
>  
>  	/* Apparently the data is read from end to start */
>  	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
> @@ -63,6 +63,14 @@ static inline void rt2800_register_multi
>  	rt2x00pci_register_multiwrite(rt2x00dev, offset, value, length);
>  }
>  
> +static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
> +				      const unsigned int offset,
> +				      const struct rt2x00_field32 field,
> +				      u32 *reg)
> +{
> +	return rt2x00pci_regbusy_read(rt2x00dev, offset, field, reg);
> +}
> +
>  /*
>   * RF chip defines.
>   *
> 


