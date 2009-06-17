Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbZFQBVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbZFQBVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFQBVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:21:42 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:35436
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751995AbZFQBVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:21:41 -0400
Message-ID: <4A384580.7030806@bluewatersys.com>
Date: Wed, 17 Jun 2009 13:23:12 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Rob Emanuele <rob@emanuele.us>
CC: nicolas.ferre@atmel.com, haavard.skinnemoen@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] atmel-mci: Platform driver MMC slot power control
References: <1245200079-6323-1-git-send-email-rob@emanuele.us> <1245200079-6323-6-git-send-email-rob@emanuele.us>
In-Reply-To: <1245200079-6323-6-git-send-email-rob@emanuele.us>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele wrote:
> Add support to the at91sam9g20ek_2mmc platform (board-sam9g20ek-2slot-mmc.c) and support files for a VCC pin using the atmel-mci driver.
> 
> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> ---
>  arch/arm/mach-at91/at91sam9260_devices.c       |    2 ++
>  arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |    3 +++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index c372f4f..7634632 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -328,6 +328,8 @@ void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
>  			}
>  			if (data->slot[i].wp_pin)
>  				at91_set_gpio_input(data->slot[i].wp_pin, 1);
> +			if (data->slot[i].vcc_pin)
> +				at91_set_gpio_output(data->slot[i].vcc_pin, 0);
>  

Can use gpio_direction_output on these.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
