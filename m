Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYG2PVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYG2PVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYG2PVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:21:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:65364 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYG2PVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nDdCdYZGMZOyO321hulgWqFFZu0KbR0726hDkgMem50lG9t2hOtfqLfZ4nc9opF6Nj
         v9eVhWQNR2uXAUoz2u3rwUaiinOdJcemza0ihndtCjcASu6i2LVkRBSqte6BWzB1A+I1
         q1kgYzo9qOPMQNQRwnSAMjTuW8tFNgEgu21eg=
Message-ID: <386072610807290821p242eec39med0a7e14261fe29c@mail.gmail.com>
Date: Tue, 29 Jul 2008 23:21:29 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/8] blackfin: replace __FUNCTION__ with __func__
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1217311293.23389.24.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217311293.23389.24.camel@brick>
X-Google-Sender-Auth: bfed3f1fbf9ae94b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 2:01 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> __FUNCTION__ is gcc-specific, use __func__
>

Applied, Thanks
Acked-by: Bryan Wu <cooloney@kernel.org>


> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/serial/bfin_sport_uart.c |   60 +++++++++++++++++++-------------------
>  drivers/video/bfin-t350mcqb-fb.c |    6 ++--
>  2 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
> index dd8564d..529c0ff 100644
> --- a/drivers/serial/bfin_sport_uart.c
> +++ b/drivers/serial/bfin_sport_uart.c
> @@ -99,7 +99,7 @@ static void sport_stop_tx(struct uart_port *port);
>
>  static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
>  {
> -       pr_debug("%s value:%x\n", __FUNCTION__, value);
> +       pr_debug("%s value:%x\n", __func__, value);
>        /* Place a Start and Stop bit */
>        __asm__ volatile (
>                "R2 = b#01111111100;\n\t"
> @@ -110,7 +110,7 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
>                :"=r"(value)
>                :"0"(value)
>                :"R2", "R3");
> -       pr_debug("%s value:%x\n", __FUNCTION__, value);
> +       pr_debug("%s value:%x\n", __func__, value);
>
>        SPORT_PUT_TX(up, value);
>  }
> @@ -120,7 +120,7 @@ static inline unsigned int rx_one_byte(struct sport_uart_port *up)
>        unsigned int value, extract;
>
>        value = SPORT_GET_RX32(up);
> -       pr_debug("%s value:%x\n", __FUNCTION__, value);
> +       pr_debug("%s value:%x\n", __func__, value);
>
>        /* Extract 8 bits data */
>        __asm__ volatile (
> @@ -151,12 +151,12 @@ static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
>        /* Set TCR1 and TCR2 */
>        SPORT_PUT_TCR1(up, (LTFS | ITFS | TFSR | TLSBIT | ITCLK));
>        SPORT_PUT_TCR2(up, 10);
> -       pr_debug("%s TCR1:%x, TCR2:%x\n", __FUNCTION__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
> +       pr_debug("%s TCR1:%x, TCR2:%x\n", __func__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
>
>        /* Set RCR1 and RCR2 */
>        SPORT_PUT_RCR1(up, (RCKFE | LARFS | LRFS | RFSR | IRCLK));
>        SPORT_PUT_RCR2(up, 28);
> -       pr_debug("%s RCR1:%x, RCR2:%x\n", __FUNCTION__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
> +       pr_debug("%s RCR1:%x, RCR2:%x\n", __func__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
>
>        tclkdiv = sclk/(2 * baud_rate) - 1;
>        tfsdiv = 12;
> @@ -166,7 +166,7 @@ static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
>        SPORT_PUT_RCLKDIV(up, rclkdiv);
>        SSYNC();
>        pr_debug("%s sclk:%d, baud_rate:%d, tclkdiv:%d, tfsdiv:%d, rclkdiv:%d\n",
> -                       __FUNCTION__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
> +                       __func__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
>
>        return 0;
>  }
> @@ -231,7 +231,7 @@ static int sport_startup(struct uart_port *port)
>        char buffer[20];
>        int retval;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        memset(buffer, 20, '\0');
>        snprintf(buffer, 20, "%s rx", up->name);
>        retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> @@ -320,7 +320,7 @@ static unsigned int sport_tx_empty(struct uart_port *port)
>        unsigned int stat;
>
>        stat = SPORT_GET_STAT(up);
> -       pr_debug("%s stat:%04x\n", __FUNCTION__, stat);
> +       pr_debug("%s stat:%04x\n", __func__, stat);
>        if (stat & TXHRE) {
>                return TIOCSER_TEMT;
>        } else
> @@ -329,13 +329,13 @@ static unsigned int sport_tx_empty(struct uart_port *port)
>
>  static unsigned int sport_get_mctrl(struct uart_port *port)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        return (TIOCM_CTS | TIOCM_CD | TIOCM_DSR);
>  }
>
>  static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>  }
>
>  static void sport_stop_tx(struct uart_port *port)
> @@ -343,7 +343,7 @@ static void sport_stop_tx(struct uart_port *port)
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>        unsigned int stat;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>
>        stat = SPORT_GET_STAT(up);
>        while(!(stat & TXHRE)) {
> @@ -366,21 +366,21 @@ static void sport_start_tx(struct uart_port *port)
>  {
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        /* Write data into SPORT FIFO before enable SPROT to transmit */
>        sport_uart_tx_chars(up);
>
>        /* Enable transmit, then an interrupt will generated */
>        SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
>        SSYNC();
> -       pr_debug("%s exit\n", __FUNCTION__);
> +       pr_debug("%s exit\n", __func__);
>  }
>
>  static void sport_stop_rx(struct uart_port *port)
>  {
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        /* Disable sport to stop rx */
>        SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
>        SSYNC();
> @@ -388,19 +388,19 @@ static void sport_stop_rx(struct uart_port *port)
>
>  static void sport_enable_ms(struct uart_port *port)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>  }
>
>  static void sport_break_ctl(struct uart_port *port, int break_state)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>  }
>
>  static void sport_shutdown(struct uart_port *port)
>  {
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>
>        /* Disable sport */
>        SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
> @@ -421,7 +421,7 @@ static void sport_shutdown(struct uart_port *port)
>  static void sport_set_termios(struct uart_port *port,
>                struct termios *termios, struct termios *old)
>  {
> -       pr_debug("%s enter, c_cflag:%08x\n", __FUNCTION__, termios->c_cflag);
> +       pr_debug("%s enter, c_cflag:%08x\n", __func__, termios->c_cflag);
>        uart_update_timeout(port, CS8 ,port->uartclk);
>  }
>
> @@ -429,18 +429,18 @@ static const char *sport_type(struct uart_port *port)
>  {
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        return up->name;
>  }
>
>  static void sport_release_port(struct uart_port *port)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>  }
>
>  static int sport_request_port(struct uart_port *port)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        return 0;
>  }
>
> @@ -448,13 +448,13 @@ static void sport_config_port(struct uart_port *port, int flags)
>  {
>        struct sport_uart_port *up = (struct sport_uart_port *)port;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        up->port.type = PORT_BFIN_SPORT;
>  }
>
>  static int sport_verify_port(struct uart_port *port, struct serial_struct *ser)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        return 0;
>  }
>
> @@ -527,7 +527,7 @@ static int sport_uart_suspend(struct platform_device *dev, pm_message_t state)
>  {
>        struct sport_uart_port *sport = platform_get_drvdata(dev);
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        if (sport)
>                uart_suspend_port(&sport_uart_reg, &sport->port);
>
> @@ -538,7 +538,7 @@ static int sport_uart_resume(struct platform_device *dev)
>  {
>        struct sport_uart_port *sport = platform_get_drvdata(dev);
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        if (sport)
>                uart_resume_port(&sport_uart_reg, &sport->port);
>
> @@ -547,7 +547,7 @@ static int sport_uart_resume(struct platform_device *dev)
>
>  static int sport_uart_probe(struct platform_device *dev)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        sport_uart_ports[dev->id].port.dev = &dev->dev;
>        uart_add_one_port(&sport_uart_reg, &sport_uart_ports[dev->id].port);
>        platform_set_drvdata(dev, &sport_uart_ports[dev->id]);
> @@ -559,7 +559,7 @@ static int sport_uart_remove(struct platform_device *dev)
>  {
>        struct sport_uart_port *sport = platform_get_drvdata(dev);
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        platform_set_drvdata(dev, NULL);
>
>        if (sport)
> @@ -582,7 +582,7 @@ static int __init sport_uart_init(void)
>  {
>        int ret;
>
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        ret = uart_register_driver(&sport_uart_reg);
>        if (ret != 0) {
>                printk(KERN_ERR "Failed to register %s:%d\n",
> @@ -597,13 +597,13 @@ static int __init sport_uart_init(void)
>        }
>
>
> -       pr_debug("%s exit\n", __FUNCTION__);
> +       pr_debug("%s exit\n", __func__);
>        return ret;
>  }
>
>  static void __exit sport_uart_exit(void)
>  {
> -       pr_debug("%s enter\n", __FUNCTION__);
> +       pr_debug("%s enter\n", __func__);
>        platform_driver_unregister(&sport_uart_driver);
>        uart_unregister_driver(&sport_uart_reg);
>  }
> diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
> index 7d1b819..a9b3ada 100644
> --- a/drivers/video/bfin-t350mcqb-fb.c
> +++ b/drivers/video/bfin-t350mcqb-fb.c
> @@ -255,7 +255,7 @@ static int bfin_t350mcqb_fb_check_var(struct fb_var_screeninfo *var,
>  {
>
>        if (var->bits_per_pixel != LCD_BPP) {
> -               pr_debug("%s: depth not supported: %u BPP\n", __FUNCTION__,
> +               pr_debug("%s: depth not supported: %u BPP\n", __func__,
>                         var->bits_per_pixel);
>                return -EINVAL;
>        }
> @@ -264,7 +264,7 @@ static int bfin_t350mcqb_fb_check_var(struct fb_var_screeninfo *var,
>            info->var.xres_virtual != var->xres_virtual ||
>            info->var.yres_virtual != var->yres_virtual) {
>                pr_debug("%s: Resolution not supported: X%u x Y%u \n",
> -                        __FUNCTION__, var->xres, var->yres);
> +                        __func__, var->xres, var->yres);
>                return -EINVAL;
>        }
>
> @@ -274,7 +274,7 @@ static int bfin_t350mcqb_fb_check_var(struct fb_var_screeninfo *var,
>
>        if ((info->fix.line_length * var->yres_virtual) > info->fix.smem_len) {
>                pr_debug("%s: Memory Limit requested yres_virtual = %u\n",
> -                        __FUNCTION__, var->yres_virtual);
> +                        __func__, var->yres_virtual);
>                return -ENOMEM;
>        }
>
> --
> 1.6.0.rc1.154.ge3fc
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
