Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZEAVnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZEAVnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZEAVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:43:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39250 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZEAVnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <20090430234833.GI7901@oksana.dev.rtsoft.ru>
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru> <20090430234833.GI7901@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 1 May 2009 15:42:47 -0600
Message-ID: <fa686aa40905011442y26ef3a50ub012e7cb2f680c91@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 9/9] spi_mpc8xxx: s/83xx/8xxx/g
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 5:48 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> Since we renamed the file, we might want to rename the file
> internals too.
>
> Though we don't bother with changing platform driver name and
> platform module alias. The stuff is legacy and hopefully we'll
> remove it soon.
>

I'd say no personally.  Its a lot of churn for very little gain.  The
filename change alone should be sufficient to clue people into what
the driver is for.

g.

> Suggested-by: Kumar Gala <galak@kernel.crashing.org>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/spi/Kconfig       |    2 +-
>  drivers/spi/Makefile      |    2 +-
>  drivers/spi/spi_mpc8xxx.c |  396 ++++++++++++++++++++++----------------------
>  3 files changed, 200 insertions(+), 200 deletions(-)
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 3c1845c..9e77bf1 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -139,7 +139,7 @@ config SPI_MPC52xx_PSC
>          This enables using the Freescale MPC52xx Programmable Serial
>          Controller in master SPI mode.
>
> -config SPI_MPC83xx
> +config SPI_MPC8xxx
>        tristate "Freescale MPC8xxx SPI controller"
>        depends on FSL_SOC
>        help
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index fdc7aa0..18ba6b4 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -24,7 +24,7 @@ obj-$(CONFIG_SPI_OMAP_UWIRE)          += omap_uwire.o
>  obj-$(CONFIG_SPI_OMAP24XX)             += omap2_mcspi.o
>  obj-$(CONFIG_SPI_ORION)                        += orion_spi.o
>  obj-$(CONFIG_SPI_MPC52xx_PSC)          += mpc52xx_psc_spi.o
> -obj-$(CONFIG_SPI_MPC83xx)              += spi_mpc8xxx.o
> +obj-$(CONFIG_SPI_MPC8xxx)              += spi_mpc8xxx.o
>  obj-$(CONFIG_SPI_S3C24XX_GPIO)         += spi_s3c24xx_gpio.o
>  obj-$(CONFIG_SPI_S3C24XX)              += spi_s3c24xx.o
>  obj-$(CONFIG_SPI_TXX9)                 += spi_txx9.o
> diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
> index 4192ce4..15d9527 100644
> --- a/drivers/spi/spi_mpc8xxx.c
> +++ b/drivers/spi/spi_mpc8xxx.c
> @@ -1,5 +1,5 @@
>  /*
> - * MPC83xx SPI controller driver.
> + * MPC8xxx SPI controller driver.
>  *
>  * Maintainer: Kumar Gala
>  *
> @@ -37,7 +37,7 @@
>  #include <asm/irq.h>
>
>  /* SPI Controller registers */
> -struct mpc83xx_spi_reg {
> +struct mpc8xxx_spi_reg {
>        u8 res1[0x20];
>        __be32 mode;
>        __be32 event;
> @@ -76,16 +76,16 @@ struct mpc83xx_spi_reg {
>  #define        SPIM_NF         0x00000100      /* Not full */
>
>  /* SPI Controller driver's private data. */
> -struct mpc83xx_spi {
> -       struct mpc83xx_spi_reg __iomem *base;
> +struct mpc8xxx_spi {
> +       struct mpc8xxx_spi_reg __iomem *base;
>
>        /* rx & tx bufs from the spi_transfer */
>        const void *tx;
>        void *rx;
>
>        /* functions to deal with different sized buffers */
> -       void (*get_rx) (u32 rx_data, struct mpc83xx_spi *);
> -       u32(*get_tx) (struct mpc83xx_spi *);
> +       void (*get_rx) (u32 rx_data, struct mpc8xxx_spi *);
> +       u32(*get_tx) (struct mpc8xxx_spi *);
>
>        unsigned int count;
>        unsigned int irq;
> @@ -107,44 +107,44 @@ struct mpc83xx_spi {
>        struct completion done;
>  };
>
> -struct spi_mpc83xx_cs {
> +struct spi_mpc8xxx_cs {
>        /* functions to deal with different sized buffers */
> -       void (*get_rx) (u32 rx_data, struct mpc83xx_spi *);
> -       u32 (*get_tx) (struct mpc83xx_spi *);
> +       void (*get_rx) (u32 rx_data, struct mpc8xxx_spi *);
> +       u32 (*get_tx) (struct mpc8xxx_spi *);
>        u32 rx_shift;           /* RX data reg shift when in qe mode */
>        u32 tx_shift;           /* TX data reg shift when in qe mode */
>        u32 hw_mode;            /* Holds HW mode register settings */
>  };
>
> -static inline void mpc83xx_spi_write_reg(__be32 __iomem *reg, u32 val)
> +static inline void mpc8xxx_spi_write_reg(__be32 __iomem *reg, u32 val)
>  {
>        out_be32(reg, val);
>  }
>
> -static inline u32 mpc83xx_spi_read_reg(__be32 __iomem *reg)
> +static inline u32 mpc8xxx_spi_read_reg(__be32 __iomem *reg)
>  {
>        return in_be32(reg);
>  }
>
>  #define MPC83XX_SPI_RX_BUF(type)                                         \
>  static                                                                   \
> -void mpc83xx_spi_rx_buf_##type(u32 data, struct mpc83xx_spi *mpc83xx_spi) \
> +void mpc8xxx_spi_rx_buf_##type(u32 data, struct mpc8xxx_spi *mpc8xxx_spi) \
>  {                                                                        \
> -       type *rx = mpc83xx_spi->rx;                                       \
> -       *rx++ = (type)(data >> mpc83xx_spi->rx_shift);                    \
> -       mpc83xx_spi->rx = rx;                                             \
> +       type *rx = mpc8xxx_spi->rx;                                       \
> +       *rx++ = (type)(data >> mpc8xxx_spi->rx_shift);                    \
> +       mpc8xxx_spi->rx = rx;                                             \
>  }
>
>  #define MPC83XX_SPI_TX_BUF(type)                               \
>  static                                                         \
> -u32 mpc83xx_spi_tx_buf_##type(struct mpc83xx_spi *mpc83xx_spi) \
> +u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi) \
>  {                                                              \
>        u32 data;                                               \
> -       const type *tx = mpc83xx_spi->tx;                       \
> +       const type *tx = mpc8xxx_spi->tx;                       \
>        if (!tx)                                                \
>                return 0;                                       \
> -       data = *tx++ << mpc83xx_spi->tx_shift;                  \
> -       mpc83xx_spi->tx = tx;                                   \
> +       data = *tx++ << mpc8xxx_spi->tx_shift;                  \
> +       mpc8xxx_spi->tx = tx;                                   \
>        return data;                                            \
>  }
>
> @@ -155,12 +155,12 @@ MPC83XX_SPI_TX_BUF(u8)
>  MPC83XX_SPI_TX_BUF(u16)
>  MPC83XX_SPI_TX_BUF(u32)
>
> -static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
> +static void mpc8xxx_spi_chipselect(struct spi_device *spi, int value)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi = spi_master_get_devdata(spi->master);
> +       struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
>        struct fsl_spi_platform_data *pdata = spi->dev.parent->platform_data;
>        bool pol = spi->mode & SPI_CS_HIGH;
> -       struct spi_mpc83xx_cs   *cs = spi->controller_state;
> +       struct spi_mpc8xxx_cs   *cs = spi->controller_state;
>
>        if (value == BITBANG_CS_INACTIVE) {
>                if (pdata->cs_control)
> @@ -168,16 +168,16 @@ static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
>        }
>
>        if (value == BITBANG_CS_ACTIVE) {
> -               u32 regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
> +               u32 regval = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
>
> -               mpc83xx_spi->rx_shift = cs->rx_shift;
> -               mpc83xx_spi->tx_shift = cs->tx_shift;
> -               mpc83xx_spi->get_rx = cs->get_rx;
> -               mpc83xx_spi->get_tx = cs->get_tx;
> +               mpc8xxx_spi->rx_shift = cs->rx_shift;
> +               mpc8xxx_spi->tx_shift = cs->tx_shift;
> +               mpc8xxx_spi->get_rx = cs->get_rx;
> +               mpc8xxx_spi->get_tx = cs->get_tx;
>
>                if (cs->hw_mode != regval) {
>                        unsigned long flags;
> -                       __be32 __iomem *mode = &mpc83xx_spi->base->mode;
> +                       __be32 __iomem *mode = &mpc8xxx_spi->base->mode;
>
>                        regval = cs->hw_mode;
>                        /* Turn off IRQs locally to minimize time that
> @@ -185,8 +185,8 @@ static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
>                         */
>                        local_irq_save(flags);
>                        /* Turn off SPI unit prior changing mode */
> -                       mpc83xx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
> -                       mpc83xx_spi_write_reg(mode, regval);
> +                       mpc8xxx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
> +                       mpc8xxx_spi_write_reg(mode, regval);
>                        local_irq_restore(flags);
>                }
>                if (pdata->cs_control)
> @@ -195,15 +195,15 @@ static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
>  }
>
>  static
> -int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
> +int mpc8xxx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi;
> +       struct mpc8xxx_spi *mpc8xxx_spi;
>        u32 regval;
>        u8 bits_per_word, pm;
>        u32 hz;
> -       struct spi_mpc83xx_cs   *cs = spi->controller_state;
> +       struct spi_mpc8xxx_cs   *cs = spi->controller_state;
>
> -       mpc83xx_spi = spi_master_get_devdata(spi->master);
> +       mpc8xxx_spi = spi_master_get_devdata(spi->master);
>
>        if (t) {
>                bits_per_word = t->bits_per_word;
> @@ -228,26 +228,26 @@ int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>        cs->rx_shift = 0;
>        cs->tx_shift = 0;
>        if (bits_per_word <= 8) {
> -               cs->get_rx = mpc83xx_spi_rx_buf_u8;
> -               cs->get_tx = mpc83xx_spi_tx_buf_u8;
> -               if (mpc83xx_spi->qe_mode) {
> +               cs->get_rx = mpc8xxx_spi_rx_buf_u8;
> +               cs->get_tx = mpc8xxx_spi_tx_buf_u8;
> +               if (mpc8xxx_spi->qe_mode) {
>                        cs->rx_shift = 16;
>                        cs->tx_shift = 24;
>                }
>        } else if (bits_per_word <= 16) {
> -               cs->get_rx = mpc83xx_spi_rx_buf_u16;
> -               cs->get_tx = mpc83xx_spi_tx_buf_u16;
> -               if (mpc83xx_spi->qe_mode) {
> +               cs->get_rx = mpc8xxx_spi_rx_buf_u16;
> +               cs->get_tx = mpc8xxx_spi_tx_buf_u16;
> +               if (mpc8xxx_spi->qe_mode) {
>                        cs->rx_shift = 16;
>                        cs->tx_shift = 16;
>                }
>        } else if (bits_per_word <= 32) {
> -               cs->get_rx = mpc83xx_spi_rx_buf_u32;
> -               cs->get_tx = mpc83xx_spi_tx_buf_u32;
> +               cs->get_rx = mpc8xxx_spi_rx_buf_u32;
> +               cs->get_tx = mpc8xxx_spi_tx_buf_u32;
>        } else
>                return -EINVAL;
>
> -       if (mpc83xx_spi->qe_mode && spi->mode & SPI_LSB_FIRST) {
> +       if (mpc8xxx_spi->qe_mode && spi->mode & SPI_LSB_FIRST) {
>                cs->tx_shift = 0;
>                if (bits_per_word <= 8)
>                        cs->rx_shift = 8;
> @@ -255,10 +255,10 @@ int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>                        cs->rx_shift = 0;
>        }
>
> -       mpc83xx_spi->rx_shift = cs->rx_shift;
> -       mpc83xx_spi->tx_shift = cs->tx_shift;
> -       mpc83xx_spi->get_rx = cs->get_rx;
> -       mpc83xx_spi->get_tx = cs->get_tx;
> +       mpc8xxx_spi->rx_shift = cs->rx_shift;
> +       mpc8xxx_spi->tx_shift = cs->tx_shift;
> +       mpc8xxx_spi->get_rx = cs->get_rx;
> +       mpc8xxx_spi->get_tx = cs->get_tx;
>
>        if (bits_per_word == 32)
>                bits_per_word = 0;
> @@ -271,25 +271,25 @@ int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>
>        cs->hw_mode |= SPMODE_LEN(bits_per_word);
>
> -       if ((mpc83xx_spi->spibrg / hz) > 64) {
> +       if ((mpc8xxx_spi->spibrg / hz) > 64) {
>                cs->hw_mode |= SPMODE_DIV16;
> -               pm = mpc83xx_spi->spibrg / (hz * 64);
> +               pm = mpc8xxx_spi->spibrg / (hz * 64);
>
>                WARN_ONCE(pm > 16, "%s: Requested speed is too low: %d Hz. "
>                          "Will use %d Hz instead.\n", dev_name(&spi->dev),
> -                         hz, mpc83xx_spi->spibrg / 1024);
> +                         hz, mpc8xxx_spi->spibrg / 1024);
>                if (pm > 16)
>                        pm = 16;
>        } else
> -               pm = mpc83xx_spi->spibrg / (hz * 4);
> +               pm = mpc8xxx_spi->spibrg / (hz * 4);
>        if (pm)
>                pm--;
>
>        cs->hw_mode |= SPMODE_PM(pm);
> -       regval =  mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
> +       regval =  mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
>        if (cs->hw_mode != regval) {
>                unsigned long flags;
> -               __be32 __iomem *mode = &mpc83xx_spi->base->mode;
> +               __be32 __iomem *mode = &mpc8xxx_spi->base->mode;
>
>                regval = cs->hw_mode;
>                /* Turn off IRQs locally to minimize time
> @@ -297,22 +297,22 @@ int mpc83xx_spi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>                 */
>                local_irq_save(flags);
>                /* Turn off SPI unit prior changing mode */
> -               mpc83xx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
> -               mpc83xx_spi_write_reg(mode, regval);
> +               mpc8xxx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
> +               mpc8xxx_spi_write_reg(mode, regval);
>                local_irq_restore(flags);
>        }
>        return 0;
>  }
>
> -static int mpc83xx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
> +static int mpc8xxx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi;
> +       struct mpc8xxx_spi *mpc8xxx_spi;
>        u32 word, len, bits_per_word;
>
> -       mpc83xx_spi = spi_master_get_devdata(spi->master);
> +       mpc8xxx_spi = spi_master_get_devdata(spi->master);
>
> -       mpc83xx_spi->tx = t->tx_buf;
> -       mpc83xx_spi->rx = t->rx_buf;
> +       mpc8xxx_spi->tx = t->tx_buf;
> +       mpc8xxx_spi->rx = t->rx_buf;
>        bits_per_word = spi->bits_per_word;
>        if (t->bits_per_word)
>                bits_per_word = t->bits_per_word;
> @@ -329,26 +329,26 @@ static int mpc83xx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
>                        return -EINVAL;
>                len /= 2;
>        }
> -       mpc83xx_spi->count = len;
> +       mpc8xxx_spi->count = len;
>
> -       INIT_COMPLETION(mpc83xx_spi->done);
> +       INIT_COMPLETION(mpc8xxx_spi->done);
>
>        /* enable rx ints */
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, SPIM_NE);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mask, SPIM_NE);
>
>        /* transmit word */
> -       word = mpc83xx_spi->get_tx(mpc83xx_spi);
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit, word);
> +       word = mpc8xxx_spi->get_tx(mpc8xxx_spi);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->transmit, word);
>
> -       wait_for_completion(&mpc83xx_spi->done);
> +       wait_for_completion(&mpc8xxx_spi->done);
>
>        /* disable rx ints */
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, 0);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mask, 0);
>
> -       return mpc83xx_spi->count;
> +       return mpc8xxx_spi->count;
>  }
>
> -static void mpc83xx_spi_do_one_msg(struct spi_message *m)
> +static void mpc8xxx_spi_do_one_msg(struct spi_message *m)
>  {
>        struct spi_device *spi = m->spi;
>        struct spi_transfer *t;
> @@ -364,18 +364,18 @@ static void mpc83xx_spi_do_one_msg(struct spi_message *m)
>                        status = -EINVAL;
>
>                        if (cs_change)
> -                               status = mpc83xx_spi_setup_transfer(spi, t);
> +                               status = mpc8xxx_spi_setup_transfer(spi, t);
>                        if (status < 0)
>                                break;
>                }
>
>                if (cs_change) {
> -                       mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
> +                       mpc8xxx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
>                        ndelay(nsecs);
>                }
>                cs_change = t->cs_change;
>                if (t->len)
> -                       status = mpc83xx_spi_bufs(spi, t);
> +                       status = mpc8xxx_spi_bufs(spi, t);
>                if (status) {
>                        status = -EMSGSIZE;
>                        break;
> @@ -387,7 +387,7 @@ static void mpc83xx_spi_do_one_msg(struct spi_message *m)
>
>                if (cs_change) {
>                        ndelay(nsecs);
> -                       mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
> +                       mpc8xxx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
>                        ndelay(nsecs);
>                }
>        }
> @@ -397,42 +397,42 @@ static void mpc83xx_spi_do_one_msg(struct spi_message *m)
>
>        if (status || !cs_change) {
>                ndelay(nsecs);
> -               mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
> +               mpc8xxx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
>        }
>
> -       mpc83xx_spi_setup_transfer(spi, NULL);
> +       mpc8xxx_spi_setup_transfer(spi, NULL);
>  }
>
> -static void mpc83xx_spi_work(struct work_struct *work)
> +static void mpc8xxx_spi_work(struct work_struct *work)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi = container_of(work, struct mpc83xx_spi,
> +       struct mpc8xxx_spi *mpc8xxx_spi = container_of(work, struct mpc8xxx_spi,
>                                                       work);
>
> -       spin_lock_irq(&mpc83xx_spi->lock);
> -       while (!list_empty(&mpc83xx_spi->queue)) {
> -               struct spi_message *m = container_of(mpc83xx_spi->queue.next,
> +       spin_lock_irq(&mpc8xxx_spi->lock);
> +       while (!list_empty(&mpc8xxx_spi->queue)) {
> +               struct spi_message *m = container_of(mpc8xxx_spi->queue.next,
>                                                   struct spi_message, queue);
>
>                list_del_init(&m->queue);
> -               spin_unlock_irq(&mpc83xx_spi->lock);
> +               spin_unlock_irq(&mpc8xxx_spi->lock);
>
> -               mpc83xx_spi_do_one_msg(m);
> +               mpc8xxx_spi_do_one_msg(m);
>
> -               spin_lock_irq(&mpc83xx_spi->lock);
> +               spin_lock_irq(&mpc8xxx_spi->lock);
>        }
> -       spin_unlock_irq(&mpc83xx_spi->lock);
> +       spin_unlock_irq(&mpc8xxx_spi->lock);
>  }
>
>  /* the spi->mode bits understood by this driver: */
>  #define MODEBITS       (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
>                        | SPI_LSB_FIRST | SPI_LOOP)
>
> -static int mpc83xx_spi_setup(struct spi_device *spi)
> +static int mpc8xxx_spi_setup(struct spi_device *spi)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi;
> +       struct mpc8xxx_spi *mpc8xxx_spi;
>        int retval;
>        u32 hw_mode;
> -       struct spi_mpc83xx_cs   *cs = spi->controller_state;
> +       struct spi_mpc8xxx_cs   *cs = spi->controller_state;
>
>        if (spi->mode & ~MODEBITS) {
>                dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
> @@ -449,13 +449,13 @@ static int mpc83xx_spi_setup(struct spi_device *spi)
>                        return -ENOMEM;
>                spi->controller_state = cs;
>        }
> -       mpc83xx_spi = spi_master_get_devdata(spi->master);
> +       mpc8xxx_spi = spi_master_get_devdata(spi->master);
>
>        if (!spi->bits_per_word)
>                spi->bits_per_word = 8;
>
>        hw_mode = cs->hw_mode; /* Save orginal settings */
> -       cs->hw_mode = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
> +       cs->hw_mode = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->mode);
>        /* mask out bits we are going to set */
>        cs->hw_mode &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
>                         | SPMODE_REV | SPMODE_LOOP);
> @@ -469,7 +469,7 @@ static int mpc83xx_spi_setup(struct spi_device *spi)
>        if (spi->mode & SPI_LOOP)
>                cs->hw_mode |= SPMODE_LOOP;
>
> -       retval = mpc83xx_spi_setup_transfer(spi, NULL);
> +       retval = mpc8xxx_spi_setup_transfer(spi, NULL);
>        if (retval < 0) {
>                cs->hw_mode = hw_mode; /* Restore settings */
>                return retval;
> @@ -481,21 +481,21 @@ static int mpc83xx_spi_setup(struct spi_device *spi)
>        return 0;
>  }
>
> -static irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
> +static irqreturn_t mpc8xxx_spi_irq(s32 irq, void *context_data)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi = context_data;
> +       struct mpc8xxx_spi *mpc8xxx_spi = context_data;
>        u32 event;
>        irqreturn_t ret = IRQ_NONE;
>
>        /* Get interrupt events(tx/rx) */
> -       event = mpc83xx_spi_read_reg(&mpc83xx_spi->base->event);
> +       event = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->event);
>
>        /* We need handle RX first */
>        if (event & SPIE_NE) {
> -               u32 rx_data = mpc83xx_spi_read_reg(&mpc83xx_spi->base->receive);
> +               u32 rx_data = mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->receive);
>
> -               if (mpc83xx_spi->rx)
> -                       mpc83xx_spi->get_rx(rx_data, mpc83xx_spi);
> +               if (mpc8xxx_spi->rx)
> +                       mpc8xxx_spi->get_rx(rx_data, mpc8xxx_spi);
>
>                ret = IRQ_HANDLED;
>        }
> @@ -503,56 +503,56 @@ static irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
>        if ((event & SPIE_NF) == 0)
>                /* spin until TX is done */
>                while (((event =
> -                        mpc83xx_spi_read_reg(&mpc83xx_spi->base->event)) &
> +                        mpc8xxx_spi_read_reg(&mpc8xxx_spi->base->event)) &
>                                                SPIE_NF) == 0)
>                        cpu_relax();
>
> -       mpc83xx_spi->count -= 1;
> -       if (mpc83xx_spi->count) {
> -               u32 word = mpc83xx_spi->get_tx(mpc83xx_spi);
> -               mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit, word);
> +       mpc8xxx_spi->count -= 1;
> +       if (mpc8xxx_spi->count) {
> +               u32 word = mpc8xxx_spi->get_tx(mpc8xxx_spi);
> +               mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->transmit, word);
>        } else {
> -               complete(&mpc83xx_spi->done);
> +               complete(&mpc8xxx_spi->done);
>        }
>
>        /* Clear the events */
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->event, event);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->event, event);
>
>        return ret;
>  }
> -static int mpc83xx_spi_transfer(struct spi_device *spi,
> +static int mpc8xxx_spi_transfer(struct spi_device *spi,
>                                struct spi_message *m)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi = spi_master_get_devdata(spi->master);
> +       struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
>        unsigned long flags;
>
>        m->actual_length = 0;
>        m->status = -EINPROGRESS;
>
> -       spin_lock_irqsave(&mpc83xx_spi->lock, flags);
> -       list_add_tail(&m->queue, &mpc83xx_spi->queue);
> -       queue_work(mpc83xx_spi->workqueue, &mpc83xx_spi->work);
> -       spin_unlock_irqrestore(&mpc83xx_spi->lock, flags);
> +       spin_lock_irqsave(&mpc8xxx_spi->lock, flags);
> +       list_add_tail(&m->queue, &mpc8xxx_spi->queue);
> +       queue_work(mpc8xxx_spi->workqueue, &mpc8xxx_spi->work);
> +       spin_unlock_irqrestore(&mpc8xxx_spi->lock, flags);
>
>        return 0;
>  }
>
>
> -static void mpc83xx_spi_cleanup(struct spi_device *spi)
> +static void mpc8xxx_spi_cleanup(struct spi_device *spi)
>  {
>        kfree(spi->controller_state);
>  }
>
>  static struct spi_master * __devinit
> -mpc83xx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
> +mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
>  {
>        struct fsl_spi_platform_data *pdata = dev->platform_data;
>        struct spi_master *master;
> -       struct mpc83xx_spi *mpc83xx_spi;
> +       struct mpc8xxx_spi *mpc8xxx_spi;
>        u32 regval;
>        int ret = 0;
>
> -       master = spi_alloc_master(dev, sizeof(struct mpc83xx_spi));
> +       master = spi_alloc_master(dev, sizeof(struct mpc8xxx_spi));
>        if (master == NULL) {
>                ret = -ENOMEM;
>                goto err;
> @@ -560,36 +560,36 @@ mpc83xx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
>
>        dev_set_drvdata(dev, master);
>
> -       master->setup = mpc83xx_spi_setup;
> -       master->transfer = mpc83xx_spi_transfer;
> -       master->cleanup = mpc83xx_spi_cleanup;
> -
> -       mpc83xx_spi = spi_master_get_devdata(master);
> -       mpc83xx_spi->qe_mode = pdata->qe_mode;
> -       mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
> -       mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
> -       mpc83xx_spi->spibrg = pdata->sysclk;
> -
> -       mpc83xx_spi->rx_shift = 0;
> -       mpc83xx_spi->tx_shift = 0;
> -       if (mpc83xx_spi->qe_mode) {
> -               mpc83xx_spi->rx_shift = 16;
> -               mpc83xx_spi->tx_shift = 24;
> +       master->setup = mpc8xxx_spi_setup;
> +       master->transfer = mpc8xxx_spi_transfer;
> +       master->cleanup = mpc8xxx_spi_cleanup;
> +
> +       mpc8xxx_spi = spi_master_get_devdata(master);
> +       mpc8xxx_spi->qe_mode = pdata->qe_mode;
> +       mpc8xxx_spi->get_rx = mpc8xxx_spi_rx_buf_u8;
> +       mpc8xxx_spi->get_tx = mpc8xxx_spi_tx_buf_u8;
> +       mpc8xxx_spi->spibrg = pdata->sysclk;
> +
> +       mpc8xxx_spi->rx_shift = 0;
> +       mpc8xxx_spi->tx_shift = 0;
> +       if (mpc8xxx_spi->qe_mode) {
> +               mpc8xxx_spi->rx_shift = 16;
> +               mpc8xxx_spi->tx_shift = 24;
>        }
>
> -       init_completion(&mpc83xx_spi->done);
> +       init_completion(&mpc8xxx_spi->done);
>
> -       mpc83xx_spi->base = ioremap(mem->start, mem->end - mem->start + 1);
> -       if (mpc83xx_spi->base == NULL) {
> +       mpc8xxx_spi->base = ioremap(mem->start, mem->end - mem->start + 1);
> +       if (mpc8xxx_spi->base == NULL) {
>                ret = -ENOMEM;
>                goto put_master;
>        }
>
> -       mpc83xx_spi->irq = irq;
> +       mpc8xxx_spi->irq = irq;
>
>        /* Register for SPI Interrupt */
> -       ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,
> -                         0, "mpc83xx_spi", mpc83xx_spi);
> +       ret = request_irq(mpc8xxx_spi->irq, mpc8xxx_spi_irq,
> +                         0, "mpc8xxx_spi", mpc8xxx_spi);
>
>        if (ret != 0)
>                goto unmap_io;
> @@ -598,25 +598,25 @@ mpc83xx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
>        master->num_chipselect = pdata->max_chipselect;
>
>        /* SPI controller initializations */
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, 0);
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->command, 0);
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->event, 0xffffffff);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mode, 0);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mask, 0);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->command, 0);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->event, 0xffffffff);
>
>        /* Enable SPI interface */
>        regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
>        if (pdata->qe_mode)
>                regval |= SPMODE_OP;
>
> -       mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
> -       spin_lock_init(&mpc83xx_spi->lock);
> -       init_completion(&mpc83xx_spi->done);
> -       INIT_WORK(&mpc83xx_spi->work, mpc83xx_spi_work);
> -       INIT_LIST_HEAD(&mpc83xx_spi->queue);
> +       mpc8xxx_spi_write_reg(&mpc8xxx_spi->base->mode, regval);
> +       spin_lock_init(&mpc8xxx_spi->lock);
> +       init_completion(&mpc8xxx_spi->done);
> +       INIT_WORK(&mpc8xxx_spi->work, mpc8xxx_spi_work);
> +       INIT_LIST_HEAD(&mpc8xxx_spi->queue);
>
> -       mpc83xx_spi->workqueue = create_singlethread_workqueue(
> +       mpc8xxx_spi->workqueue = create_singlethread_workqueue(
>                dev_name(master->dev.parent));
> -       if (mpc83xx_spi->workqueue == NULL) {
> +       if (mpc8xxx_spi->workqueue == NULL) {
>                ret = -EBUSY;
>                goto free_irq;
>        }
> @@ -626,57 +626,57 @@ mpc83xx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
>                goto unreg_master;
>
>        printk(KERN_INFO
> -              "%s: MPC83xx SPI Controller driver at 0x%p (irq = %d)\n",
> -              dev_name(dev), mpc83xx_spi->base, mpc83xx_spi->irq);
> +              "%s: MPC8xxx SPI Controller driver at 0x%p (irq = %d)\n",
> +              dev_name(dev), mpc8xxx_spi->base, mpc8xxx_spi->irq);
>
>        return master;
>
>  unreg_master:
> -       destroy_workqueue(mpc83xx_spi->workqueue);
> +       destroy_workqueue(mpc8xxx_spi->workqueue);
>  free_irq:
> -       free_irq(mpc83xx_spi->irq, mpc83xx_spi);
> +       free_irq(mpc8xxx_spi->irq, mpc8xxx_spi);
>  unmap_io:
> -       iounmap(mpc83xx_spi->base);
> +       iounmap(mpc8xxx_spi->base);
>  put_master:
>        spi_master_put(master);
>  err:
>        return ERR_PTR(ret);
>  }
>
> -static int __devexit mpc83xx_spi_remove(struct device *dev)
> +static int __devexit mpc8xxx_spi_remove(struct device *dev)
>  {
> -       struct mpc83xx_spi *mpc83xx_spi;
> +       struct mpc8xxx_spi *mpc8xxx_spi;
>        struct spi_master *master;
>
>        master = dev_get_drvdata(dev);
> -       mpc83xx_spi = spi_master_get_devdata(master);
> +       mpc8xxx_spi = spi_master_get_devdata(master);
>
> -       flush_workqueue(mpc83xx_spi->workqueue);
> -       destroy_workqueue(mpc83xx_spi->workqueue);
> +       flush_workqueue(mpc8xxx_spi->workqueue);
> +       destroy_workqueue(mpc8xxx_spi->workqueue);
>        spi_unregister_master(master);
>
> -       free_irq(mpc83xx_spi->irq, mpc83xx_spi);
> -       iounmap(mpc83xx_spi->base);
> +       free_irq(mpc8xxx_spi->irq, mpc8xxx_spi);
> +       iounmap(mpc8xxx_spi->base);
>
>        return 0;
>  }
>
> -struct mpc83xx_spi_probe_info {
> +struct mpc8xxx_spi_probe_info {
>        struct fsl_spi_platform_data pdata;
>        int *gpios;
>        bool *alow_flags;
>  };
>
> -static struct mpc83xx_spi_probe_info *
> +static struct mpc8xxx_spi_probe_info *
>  to_of_pinfo(struct fsl_spi_platform_data *pdata)
>  {
> -       return container_of(pdata, struct mpc83xx_spi_probe_info, pdata);
> +       return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
>  }
>
> -static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
> +static void mpc8xxx_spi_cs_control(struct spi_device *spi, bool on)
>  {
>        struct device *dev = spi->dev.parent;
> -       struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
> +       struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
>        u16 cs = spi->chip_select;
>        int gpio = pinfo->gpios[cs];
>        bool alow = pinfo->alow_flags[cs];
> @@ -684,11 +684,11 @@ static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
>        gpio_set_value(gpio, on ^ alow);
>  }
>
> -static int of_mpc83xx_spi_get_chipselects(struct device *dev)
> +static int of_mpc8xxx_spi_get_chipselects(struct device *dev)
>  {
>        struct device_node *np = dev_archdata_get_node(&dev->archdata);
>        struct fsl_spi_platform_data *pdata = dev->platform_data;
> -       struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(pdata);
> +       struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
>        unsigned int ngpios;
>        int i = 0;
>        int ret;
> @@ -744,7 +744,7 @@ static int of_mpc83xx_spi_get_chipselects(struct device *dev)
>        }
>
>        pdata->max_chipselect = ngpios;
> -       pdata->cs_control = mpc83xx_spi_cs_control;
> +       pdata->cs_control = mpc8xxx_spi_cs_control;
>
>        return 0;
>
> @@ -763,10 +763,10 @@ err_alloc_flags:
>        return ret;
>  }
>
> -static int of_mpc83xx_spi_free_chipselects(struct device *dev)
> +static int of_mpc8xxx_spi_free_chipselects(struct device *dev)
>  {
>        struct fsl_spi_platform_data *pdata = dev->platform_data;
> -       struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(pdata);
> +       struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
>        int i;
>
>        if (!pinfo->gpios)
> @@ -782,12 +782,12 @@ static int of_mpc83xx_spi_free_chipselects(struct device *dev)
>        return 0;
>  }
>
> -static int __devinit of_mpc83xx_spi_probe(struct of_device *ofdev,
> +static int __devinit of_mpc8xxx_spi_probe(struct of_device *ofdev,
>                                          const struct of_device_id *ofid)
>  {
>        struct device *dev = &ofdev->dev;
>        struct device_node *np = ofdev->node;
> -       struct mpc83xx_spi_probe_info *pinfo;
> +       struct mpc8xxx_spi_probe_info *pinfo;
>        struct fsl_spi_platform_data *pdata;
>        struct spi_master *master;
>        struct resource mem;
> @@ -819,7 +819,7 @@ static int __devinit of_mpc83xx_spi_probe(struct of_device *ofdev,
>        if (prop && !strcmp(prop, "cpu-qe"))
>                pdata->qe_mode = 1;
>
> -       ret = of_mpc83xx_spi_get_chipselects(dev);
> +       ret = of_mpc8xxx_spi_get_chipselects(dev);
>        if (ret)
>                goto err;
>
> @@ -833,7 +833,7 @@ static int __devinit of_mpc83xx_spi_probe(struct of_device *ofdev,
>                goto err;
>        }
>
> -       master = mpc83xx_spi_probe(dev, &mem, irq.start);
> +       master = mpc8xxx_spi_probe(dev, &mem, irq.start);
>        if (IS_ERR(master)) {
>                ret = PTR_ERR(master);
>                goto err;
> @@ -844,34 +844,34 @@ static int __devinit of_mpc83xx_spi_probe(struct of_device *ofdev,
>        return 0;
>
>  err:
> -       of_mpc83xx_spi_free_chipselects(dev);
> +       of_mpc8xxx_spi_free_chipselects(dev);
>  err_clk:
>        kfree(pinfo);
>        return ret;
>  }
>
> -static int __devexit of_mpc83xx_spi_remove(struct of_device *ofdev)
> +static int __devexit of_mpc8xxx_spi_remove(struct of_device *ofdev)
>  {
>        int ret;
>
> -       ret = mpc83xx_spi_remove(&ofdev->dev);
> +       ret = mpc8xxx_spi_remove(&ofdev->dev);
>        if (ret)
>                return ret;
> -       of_mpc83xx_spi_free_chipselects(&ofdev->dev);
> +       of_mpc8xxx_spi_free_chipselects(&ofdev->dev);
>        return 0;
>  }
>
> -static const struct of_device_id of_mpc83xx_spi_match[] = {
> +static const struct of_device_id of_mpc8xxx_spi_match[] = {
>        { .compatible = "fsl,spi" },
>        {},
>  };
> -MODULE_DEVICE_TABLE(of, of_mpc83xx_spi_match);
> +MODULE_DEVICE_TABLE(of, of_mpc8xxx_spi_match);
>
> -static struct of_platform_driver of_mpc83xx_spi_driver = {
> -       .name           = "mpc83xx_spi",
> -       .match_table    = of_mpc83xx_spi_match,
> -       .probe          = of_mpc83xx_spi_probe,
> -       .remove         = __devexit_p(of_mpc83xx_spi_remove),
> +static struct of_platform_driver of_mpc8xxx_spi_driver = {
> +       .name           = "mpc8xxx_spi",
> +       .match_table    = of_mpc8xxx_spi_match,
> +       .probe          = of_mpc8xxx_spi_probe,
> +       .remove         = __devexit_p(of_mpc8xxx_spi_remove),
>  };
>
>  #ifdef CONFIG_MPC832x_RDB
> @@ -882,7 +882,7 @@ static struct of_platform_driver of_mpc83xx_spi_driver = {
>  * tree can work with OpenFirmware driver. But for now we support old trees
>  * as well.
>  */
> -static int __devinit plat_mpc83xx_spi_probe(struct platform_device *pdev)
> +static int __devinit plat_mpc8xxx_spi_probe(struct platform_device *pdev)
>  {
>        struct resource *mem;
>        unsigned int irq;
> @@ -899,21 +899,21 @@ static int __devinit plat_mpc83xx_spi_probe(struct platform_device *pdev)
>        if (!irq)
>                return -EINVAL;
>
> -       master = mpc83xx_spi_probe(&pdev->dev, mem, irq);
> +       master = mpc8xxx_spi_probe(&pdev->dev, mem, irq);
>        if (IS_ERR(master))
>                return PTR_ERR(master);
>        return 0;
>  }
>
> -static int __devexit plat_mpc83xx_spi_remove(struct platform_device *pdev)
> +static int __devexit plat_mpc8xxx_spi_remove(struct platform_device *pdev)
>  {
> -       return mpc83xx_spi_remove(&pdev->dev);
> +       return mpc8xxx_spi_remove(&pdev->dev);
>  }
>
>  MODULE_ALIAS("platform:mpc83xx_spi");
> -static struct platform_driver mpc83xx_spi_driver = {
> -       .probe = plat_mpc83xx_spi_probe,
> -       .remove = __exit_p(plat_mpc83xx_spi_remove),
> +static struct platform_driver mpc8xxx_spi_driver = {
> +       .probe = plat_mpc8xxx_spi_probe,
> +       .remove = __exit_p(plat_mpc8xxx_spi_remove),
>        .driver = {
>                .name = "mpc83xx_spi",
>                .owner = THIS_MODULE,
> @@ -924,35 +924,35 @@ static bool legacy_driver_failed;
>
>  static void __init legacy_driver_register(void)
>  {
> -       legacy_driver_failed = platform_driver_register(&mpc83xx_spi_driver);
> +       legacy_driver_failed = platform_driver_register(&mpc8xxx_spi_driver);
>  }
>
>  static void __exit legacy_driver_unregister(void)
>  {
>        if (legacy_driver_failed)
>                return;
> -       platform_driver_unregister(&mpc83xx_spi_driver);
> +       platform_driver_unregister(&mpc8xxx_spi_driver);
>  }
>  #else
>  static void __init legacy_driver_register(void) {}
>  static void __exit legacy_driver_unregister(void) {}
>  #endif /* CONFIG_MPC832x_RDB */
>
> -static int __init mpc83xx_spi_init(void)
> +static int __init mpc8xxx_spi_init(void)
>  {
>        legacy_driver_register();
> -       return of_register_platform_driver(&of_mpc83xx_spi_driver);
> +       return of_register_platform_driver(&of_mpc8xxx_spi_driver);
>  }
>
> -static void __exit mpc83xx_spi_exit(void)
> +static void __exit mpc8xxx_spi_exit(void)
>  {
> -       of_unregister_platform_driver(&of_mpc83xx_spi_driver);
> +       of_unregister_platform_driver(&of_mpc8xxx_spi_driver);
>        legacy_driver_unregister();
>  }
>
> -module_init(mpc83xx_spi_init);
> -module_exit(mpc83xx_spi_exit);
> +module_init(mpc8xxx_spi_init);
> +module_exit(mpc8xxx_spi_exit);
>
>  MODULE_AUTHOR("Kumar Gala");
> -MODULE_DESCRIPTION("Simple MPC83xx SPI Driver");
> +MODULE_DESCRIPTION("Simple MPC8xxx SPI Driver");
>  MODULE_LICENSE("GPL");
> --
> 1.6.2.2
>
> ------------------------------------------------------------------------------
> Register Now & Save for Velocity, the Web Performance & Operations
> Conference from O'Reilly Media. Velocity features a full day of
> expert-led, hands-on workshops and two days of sessions from industry
> leaders in dedicated Performance & Operations tracks. Use code vel09scf
> and Save an extra 15% before 5/3. http://p.sf.net/sfu/velocityconf
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
