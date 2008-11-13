Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYKMNst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYKMNst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYKMNsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:48:41 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:40943 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbYKMNsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:48:40 -0500
Date: Thu, 13 Nov 2008 13:48:18 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
Message-ID: <20081113134818.GA9161@fluff.org.uk>
References: <491C0C05.6040301@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491C0C05.6040301@atmel.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:14:13PM +0100, Nicolas Ferre wrote:
> Needed to use the atmel-mci driver in a architecture
> independent manner.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> arch/avr32/boards/atngw100/setup.c       |    2 +-
> arch/avr32/boards/atstk1000/atstk1002.c  |    2 +-
> arch/avr32/boards/atstk1000/atstk1003.c  |    2 +-
> arch/avr32/boards/atstk1000/atstk1004.c  |    2 +-
> arch/avr32/include/asm/atmel-mci.h       |   39 ------
> arch/avr32/mach-at32ap/at32ap700x.c      |    2 +-
> drivers/mmc/host/atmel-mci.c             |    2 +-
> include/linux/atmel-mci.h                |   39 ++++++

Would people object to putting this in include/linux/mmc/atmel.h
to avoid making include/linux abound with device/subsystem/machine
specific header files?

> 8 files changed, 45 insertions(+), 45 deletions(-)
> delete mode 100644 arch/avr32/include/asm/atmel-mci.h
> create mode 100644 include/linux/atmel-mci.h
>
> diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
> index 6c54580..ca6e1ff 100644
> --- a/arch/avr32/boards/atngw100/setup.c
> +++ b/arch/avr32/boards/atngw100/setup.c
> @@ -19,8 +19,8 @@
> #include <linux/types.h>
> #include <linux/leds.h>
> #include <linux/spi/spi.h>
> +#include <linux/atmel-mci.h>
>
> -#include <asm/atmel-mci.h>
> #include <asm/io.h>
> #include <asm/setup.h>
>
> diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
> index 29e5b51..5a6380f 100644
> --- a/arch/avr32/boards/atstk1000/atstk1002.c
> +++ b/arch/avr32/boards/atstk1000/atstk1002.c
> @@ -16,12 +16,12 @@
> #include <linux/types.h>
> #include <linux/spi/spi.h>
> #include <linux/spi/at73c213.h>
> +#include <linux/atmel-mci.h>
>
> #include <video/atmel_lcdc.h>
>
> #include <asm/io.h>
> #include <asm/setup.h>
> -#include <asm/atmel-mci.h>
>
> #include <mach/at32ap700x.h>
> #include <mach/board.h>
> diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
> index be089d7..7b9ceee 100644
> --- a/arch/avr32/boards/atstk1000/atstk1003.c
> +++ b/arch/avr32/boards/atstk1000/atstk1003.c
> @@ -17,9 +17,9 @@
>
> #include <linux/spi/at73c213.h>
> #include <linux/spi/spi.h>
> +#include <linux/atmel-mci.h>
>
> #include <asm/setup.h>
> -#include <asm/atmel-mci.h>
>
> #include <mach/at32ap700x.h>
> #include <mach/board.h>
> diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
> index 248ef23..3ff0498 100644
> --- a/arch/avr32/boards/atstk1000/atstk1004.c
> +++ b/arch/avr32/boards/atstk1000/atstk1004.c
> @@ -17,11 +17,11 @@
>
> #include <linux/spi/at73c213.h>
> #include <linux/spi/spi.h>
> +#include <linux/atmel-mci.h>
>
> #include <video/atmel_lcdc.h>
>
> #include <asm/setup.h>
> -#include <asm/atmel-mci.h>
>
> #include <mach/at32ap700x.h>
> #include <mach/board.h>
> diff --git a/arch/avr32/include/asm/atmel-mci.h b/arch/avr32/include/asm/atmel-mci.h
> deleted file mode 100644
> index 59f3fad..0000000
> --- a/arch/avr32/include/asm/atmel-mci.h
> +++ /dev/null
> @@ -1,39 +0,0 @@
> -#ifndef __ASM_AVR32_ATMEL_MCI_H
> -#define __ASM_AVR32_ATMEL_MCI_H
> -
> -#define ATMEL_MCI_MAX_NR_SLOTS	2
> -
> -struct dma_slave;
> -
> -/**
> - * struct mci_slot_pdata - board-specific per-slot configuration
> - * @bus_width: Number of data lines wired up the slot
> - * @detect_pin: GPIO pin wired to the card detect switch
> - * @wp_pin: GPIO pin wired to the write protect sensor
> - *
> - * If a given slot is not present on the board, @bus_width should be
> - * set to 0. The other fields are ignored in this case.
> - *
> - * Any pins that aren't available should be set to a negative value.
> - *
> - * Note that support for multiple slots is experimental -- some cards
> - * might get upset if we don't get the clock management exactly right.
> - * But in most cases, it should work just fine.
> - */
> -struct mci_slot_pdata {
> -	unsigned int		bus_width;
> -	int			detect_pin;
> -	int			wp_pin;
> -};
> -
> -/**
> - * struct mci_platform_data - board-specific MMC/SDcard configuration
> - * @dma_slave: DMA slave interface to use in data transfers, or NULL.
> - * @slot: Per-slot configuration data.
> - */
> -struct mci_platform_data {
> -	struct dma_slave	*dma_slave;
> -	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
> -};
> -
> -#endif /* __ASM_AVR32_ATMEL_MCI_H */
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 813b684..b0ad6da 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -15,8 +15,8 @@
> #include <linux/gpio.h>
> #include <linux/spi/spi.h>
> #include <linux/usb/atmel_usba_udc.h>
> +#include <linux/atmel-mci.h>
>
> -#include <asm/atmel-mci.h>
> #include <asm/io.h>
> #include <asm/irq.h>
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 7a3f243..1e97916 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -25,8 +25,8 @@
> #include <linux/stat.h>
>
> #include <linux/mmc/host.h>
> +#include <linux/atmel-mci.h>
>
> -#include <asm/atmel-mci.h>
> #include <asm/io.h>
> #include <asm/unaligned.h>
>
> diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
> new file mode 100644
> index 0000000..2a2213e
> --- /dev/null
> +++ b/include/linux/atmel-mci.h
> @@ -0,0 +1,39 @@
> +#ifndef __LINUX_ATMEL_MCI_H
> +#define __LINUX_ATMEL_MCI_H
> +
> +#define ATMEL_MCI_MAX_NR_SLOTS	2
> +
> +struct dma_slave;
> +
> +/**
> + * struct mci_slot_pdata - board-specific per-slot configuration
> + * @bus_width: Number of data lines wired up the slot
> + * @detect_pin: GPIO pin wired to the card detect switch
> + * @wp_pin: GPIO pin wired to the write protect sensor
> + *
> + * If a given slot is not present on the board, @bus_width should be
> + * set to 0. The other fields are ignored in this case.
> + *
> + * Any pins that aren't available should be set to a negative value.
> + *
> + * Note that support for multiple slots is experimental -- some cards
> + * might get upset if we don't get the clock management exactly right.
> + * But in most cases, it should work just fine.
> + */
> +struct mci_slot_pdata {
> +	unsigned int		bus_width;
> +	int			detect_pin;
> +	int			wp_pin;
> +};
> +
> +/**
> + * struct mci_platform_data - board-specific MMC/SDcard configuration
> + * @dma_slave: DMA slave interface to use in data transfers, or NULL.
> + * @slot: Per-slot configuration data.
> + */
> +struct mci_platform_data {
> +	struct dma_slave	*dma_slave;
> +	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
> +};
> +
> +#endif /* __LINUX_ATMEL_MCI_H */
> -- 
> 1.5.3.7
>
>
>
> -- 
> Nicolas Ferre
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
