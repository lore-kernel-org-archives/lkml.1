Return-Path: <linux-kernel-owner+w=401wt.eu-S1033232AbXEIB0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033232AbXEIB0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbXEIB0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:26:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbXEIB0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:26:14 -0400
Subject: Re: [PATCH 1/3] v4l: Support 10moons TM300 (saa7130) Card
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tony Wan <wankai@sjtu.org>
Cc: michael@mihu.de, linux-kernel@vger.kernel.org,
       Linux and Kernel Video <video4linux-list@redhat.com>
In-Reply-To: <1178661250.16408.5.camel@localhost.localdomain>
References: <1178661250.16408.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 May 2007 22:25:47 -0300
Message-Id: <1178673947.8369.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Can you re-generate your patch against the latest tree? Currently, the
last board is 115. So, this one should be 116.

Also, the proper way for discussing about V4L is to use V4L Mailing List
(I'm c/c it).

Cheers,
Mauro.

Em Qua, 2007-05-09 às 05:54 +0800, Tony Wan escreveu:
> Support the 10moons TM300 TV card (so called TV Master 3), which is a
> 10moons saa7130 based new board.
> Here not include features for the IR-remote.
> 
> It has been tested using TVTIME. The card was auto-detected and all the
> input sources worked correct with sound.
> 
> Signed-off-by: Tony Wan <wankai@sjtu.org>
> ---
>  drivers/media/video/saa7134/saa7134-cards.c |   38 +++++++++++++++++++++++++++
>  drivers/media/video/saa7134/saa7134.h       |    1 +
>  2 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
> index 4ea479b..c89d0ef 100644
> --- a/drivers/media/video/saa7134/saa7134-cards.c
> +++ b/drivers/media/video/saa7134/saa7134-cards.c
> @@ -3407,6 +3407,38 @@ struct saa7134_board saa7134_boards[] = {
>  			.gpio = 0x0200000,
>  		},
>  	},
> +	[SAA7134_BOARD_10MOONSTVMASTER3] = {
> +		/* Tony Wan <aloha_cn@hotmail.com> */
> +		.name           = "10MOONS TM300 TV Card",
> +		.audio_clock    = 0x00200000,
> +		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
> +		.radio_type     = UNSET,
> +		.tuner_addr     = ADDR_UNSET,
> +		.radio_addr     = ADDR_UNSET,
> +		.gpiomask       = 0x7000,
> +		.inputs         = {{
> +			.name = name_tv,
> +			.vmux = 1,
> +			.amux = LINE2,
> +			.gpio = 0x0000,
> +			.tv   = 1,
> +		},{
> +			.name = name_comp1,
> +			.vmux = 3,
> +			.amux = LINE1,
> +			.gpio = 0x2000,
> +		},{
> +			.name = name_svideo,
> +			.vmux = 8,
> +			.amux = LINE1,
> +			.gpio = 0x2000,
> +		}},
> +		.mute = {
> +			.name = name_mute,
> +			.amux = LINE2,
> +			.gpio = 0x3000,
> +		},
> +	},
>  };
>  
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -4100,6 +4132,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
>  		.subdevice    = 0x4857,
>  		.driver_data  = SAA7134_BOARD_ASUSTeK_P7131_DUAL,
>  	},{
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
> +		.subvendor    = PCI_VENDOR_ID_PHILIPS,
> +		.subdevice    = 0x2304,
> +		.driver_data  = SAA7134_BOARD_10MOONSTVMASTER3,
> +	},{
>  		/* --- boards without eeprom + subsystem ID --- */
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
>  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
> index 62224cc..07a155e 100644
> --- a/drivers/media/video/saa7134/saa7134.h
> +++ b/drivers/media/video/saa7134/saa7134.h
> @@ -235,6 +235,7 @@ struct saa7134_format {
>  #define SAA7134_BOARD_AVERMEDIA_M102	   110
>  #define SAA7134_BOARD_ASUS_P7131_4871	   111
>  #define SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA 112
> +#define SAA7134_BOARD_10MOONSTVMASTER3     113
>  
>  #define SAA7134_MAXBOARDS 8
>  #define SAA7134_INPUT_MAX 8
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Cheers,
Mauro

