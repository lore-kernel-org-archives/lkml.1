Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYAVMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYAVMOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYAVMOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:14:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:58163 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYAVMOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tfInrh7qazqH6LJGMZeUrGZAsdPJHxElQnQMbJy7N1rAtDaej51XBZkYpT4SQj15UKAcg6pheBqJ3T3D07rJe9B3Ggj8U9AGkVDgChoRwdgiSUnM9dW1dAZ+eePUwBUe3FQPCWB2EjwMAD2gVDX+IhLDn+a/OCONlGBWJRh+y+g=
Message-ID: <31e679430801220413j763589b0j171873c9a90a3cb3@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:13:58 +0200
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] I2C: ISP1301_OMAP: New-style i2c driver updates, part 2
Cc: "Felipe Balbi" <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, tony@atomide.com, "Linux I2C" <i2c@lm-sensors.org>
In-Reply-To: <20080122130158.4d4d44dc@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
	 <1199379597-6273-2-git-send-email-me@felipebalbi.com>
	 <1199379597-6273-3-git-send-email-me@felipebalbi.com>
	 <20080122130158.4d4d44dc@hyperion.delvare>
X-Google-Sender-Auth: 2067f8ca4b33eefd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 22, 2008 2:01 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Felipe,
>
>
> On Thu,  3 Jan 2008 11:59:57 -0500, Felipe Balbi wrote:
> > Based on David Brownell's patch for tps65010, this patch
> > finish conversting isp1301_omap.c to new-style i2c driver.
> >
> > Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> > ---
> >  arch/arm/mach-omap1/board-h2.c   |    6 ++-
> >  arch/arm/mach-omap1/board-h3.c   |    6 ++-
> >  arch/arm/mach-omap2/board-h4.c   |   12 +++
> >  drivers/i2c/chips/isp1301_omap.c |  149 +++++++++++++-------------------------
> >  4 files changed, 73 insertions(+), 100 deletions(-)
> >
> > diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
> > index 1306812..0307f50 100644
> > --- a/arch/arm/mach-omap1/board-h2.c
> > +++ b/arch/arm/mach-omap1/board-h2.c
> > @@ -350,8 +350,12 @@ static struct i2c_board_info __initdata h2_i2c_board_info[] = {
> >               .type           = "tps65010",
> >               .irq            = OMAP_GPIO_IRQ(58),
> >       },
> > +     {
> > +             I2C_BOARD_INFO("isp1301_omap", 0x2d),
> > +             .type           = "isp1301_omap",
> > +             .irq            = OMAP_GPIO_IRQ(2),
> > +     },
> >       /* TODO when driver support is ready:
> > -      *  - isp1301 OTG transceiver
> >        *  - optional ov9640 camera sensor at 0x30
> >        *  - pcf9754 for aGPS control
> >        *  - ... etc
> > diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
> > index 4f84ae2..71e285a 100644
> > --- a/arch/arm/mach-omap1/board-h3.c
> > +++ b/arch/arm/mach-omap1/board-h3.c
> > @@ -463,8 +463,12 @@ static struct i2c_board_info __initdata h3_i2c_board_info[] = {
> >               .type           = "tps65013",
> >               /* .irq         = OMAP_GPIO_IRQ(??), */
> >       },
> > +     {
> > +             I2C_BOARD_INFO("isp1301_omap", 0x2d),
> > +             .type           = "isp1301_omap",
> > +             .irq            = OMAP_GPIO_IRQ(14),
> > +     },
> >       /* TODO when driver support is ready:
> > -      *  - isp1301 OTG transceiver
> >        *  - optional ov9640 camera sensor at 0x30
> >        *  - ...
> >        */
> > diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
> > index f125f43..33ff80b 100644
> > --- a/arch/arm/mach-omap2/board-h4.c
> > +++ b/arch/arm/mach-omap2/board-h4.c
> > @@ -301,6 +301,15 @@ static struct omap_board_config_kernel h4_config[] = {
> >       { OMAP_TAG_LCD,         &h4_lcd_config },
> >  };
> >
> > +static struct i2c_board_info __initdata h4_i2c_board_info[] = {
> > +     {
> > +             I2C_BOARD_INFO("isp1301_omap", 0x2d),
> > +             .type           = "isp1301_omap",
> > +             .irq            = OMAP_GPIO_IRQ(125),
> > +     },
> > +};
> > +
> > +
> >  static void __init omap_h4_init(void)
> >  {
> >       /*
> > @@ -321,6 +330,9 @@ static void __init omap_h4_init(void)
> >       }
> >  #endif
> >
> > +     i2c_register_board_info(1, h4_i2c_board_info,
> > +                     ARRAY_SIZE(h4_i2c_board_info));
> > +
> >       platform_add_devices(h4_devices, ARRAY_SIZE(h4_devices));
> >       omap_board_config = h4_config;
> >       omap_board_config_size = ARRAY_SIZE(h4_config);
> > diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
> > index 37e1403..c7a7c48 100644
> > --- a/drivers/i2c/chips/isp1301_omap.c
> > +++ b/drivers/i2c/chips/isp1301_omap.c
> > @@ -31,16 +31,12 @@
> >  #include <linux/usb/otg.h>
> >  #include <linux/i2c.h>
> >  #include <linux/workqueue.h>
> > -
> > -#include <asm/irq.h>
> >  #include <asm/arch/usb.h>
> >
> > -
> >  #ifndef      DEBUG
> >  #undef       VERBOSE
> >  #endif
> >
> > -
> >  #define      DRIVER_VERSION  "24 August 2004"
> >  #define      DRIVER_NAME     (isp1301_driver.driver.name)
> >
> > @@ -50,12 +46,8 @@ MODULE_LICENSE("GPL");
> >  struct isp1301 {
> >       struct otg_transceiver  otg;
> >       struct i2c_client       *client;
> > -     struct i2c_client       c;
> >       void                    (*i2c_release)(struct device *dev);
> >
> > -     int                     irq;
> > -     int                     irq_type;
> > -
> >       u32                     last_otg_ctrl;
> >       unsigned                working:1;
> >
> > @@ -140,13 +132,6 @@ static inline void notresponding(struct isp1301 *isp)
> >  /*-------------------------------------------------------------------------*/
> >
> >  /* only two addresses possible */
> > -#define      ISP_BASE                0x2c
> > -static unsigned short normal_i2c[] = {
> > -     ISP_BASE, ISP_BASE + 1,
> > -     I2C_CLIENT_END };
> > -
> > -I2C_CLIENT_INSMOD;
> > -
> >  static struct i2c_driver isp1301_driver;
> >
> >  /* smbus apis are used for portability */
> > @@ -1196,9 +1181,11 @@ static void isp1301_timer(unsigned long _isp)
> >
> >  static void isp1301_release(struct device *dev)
> >  {
> > -     struct isp1301  *isp;
> > +     struct i2c_client       *client;
> > +     struct isp1301          *isp;
> >
> > -     isp = container_of(dev, struct isp1301, c.dev);
> > +     client = container_of(dev, struct i2c_client, dev);
> > +     isp = i2c_get_clientdata(client);
>
> This seems to be a quite complex way to do:
>
>         isp = i2c_get_drvdata(dev);
>
> Or am I missing something?

My bad, thanks for getting this.

>
> >
> >       /* ugly -- i2c hijacks our memory hook to wait_for_completion() */
> >       if (isp->i2c_release)
> > @@ -1208,30 +1195,27 @@ static void isp1301_release(struct device *dev)
> >
> >  static struct isp1301 *the_transceiver;
> >
> > -static int isp1301_detach_client(struct i2c_client *i2c)
> > +static int __exit isp1301_remove(struct i2c_client *client)
> >  {
> > -     struct isp1301  *isp;
> > -
> > -     isp = container_of(i2c, struct isp1301, c);
> > +     struct isp1301  *isp = i2c_get_clientdata(client);
> >
> >       isp1301_clear_bits(isp, ISP1301_INTERRUPT_FALLING, ~0);
> >       isp1301_clear_bits(isp, ISP1301_INTERRUPT_RISING, ~0);
> > -     free_irq(isp->irq, isp);
> > +
> > +     if (client->irq > 0)
> > +             free_irq(client->irq, isp);
> >  #ifdef       CONFIG_USB_OTG
> >       otg_unbind(isp);
> >  #endif
> > -     if (machine_is_omap_h2())
> > -             omap_free_gpio(2);
> > -
>
> Why?

Board specific code should go to board files. I'll try to find a
better way of doing this. Maybe using a private_data.
Ditto to all cases below.

>
> >       isp->timer.data = 0;
> >       set_bit(WORK_STOP, &isp->todo);
> >       del_timer_sync(&isp->timer);
> >       flush_scheduled_work();
> >
> > -     put_device(&i2c->dev);
> > +     put_device(&client->dev);
> >       the_transceiver = 0;
> >
> > -     return i2c_detach_client(i2c);
> > +     return 0;
> >  }
> >
> >  /*-------------------------------------------------------------------------*/
> > @@ -1301,9 +1285,6 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
> >
> >       power_up(isp);
> >
> > -     if (machine_is_omap_h2())
> > -             isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
> > -
>
> Where has this code gone? Why is it no longer needed?
>
> (Did you test you patch on OMAP H2?)

Can't remember anymore, but before applying these patches isp1301 was
crashing the kernel on H2 and H3.

>
>
> >       dev_info(&isp->client->dev, "A-Host sessions ok\n");
> >       isp1301_set_bits(isp, ISP1301_INTERRUPT_RISING,
> >               INTR_ID_GND);
> > @@ -1481,11 +1462,10 @@ isp1301_start_hnp(struct otg_transceiver *dev)
> >  /*-------------------------------------------------------------------------*/
> >
> >  /* no error returns, they'd just make bus scanning stop */
> > -static int isp1301_probe(struct i2c_adapter *bus, int address, int kind)
> > +static int __init isp1301_probe(struct i2c_client *client)
> >  {
> >       int                     status;
> >       struct isp1301          *isp;
> > -     struct i2c_client       *i2c;
> >
> >       if (the_transceiver)
> >               return 0;
> > @@ -1498,46 +1478,35 @@ static int isp1301_probe(struct i2c_adapter *bus, int address, int kind)
> >       init_timer(&isp->timer);
> >       isp->timer.function = isp1301_timer;
> >       isp->timer.data = (unsigned long) isp;
> > -
> > -     isp->irq = -1;
> > -     isp->irq_type = 0;
> > -     isp->c.addr = address;
> > -     i2c_set_clientdata(&isp->c, isp);
> > -     isp->c.adapter = bus;
> > -     isp->c.driver = &isp1301_driver;
> > -     strlcpy(isp->c.name, DRIVER_NAME, I2C_NAME_SIZE);
> > -     isp->client = i2c = &isp->c;
> > +     isp->client = client;
> >
> >       /* if this is a true probe, verify the chip ... */
> > -     if (kind < 0) {
> > -             status = isp1301_get_u16(isp, ISP1301_VENDOR_ID);
> > -             if (status != I2C_VENDOR_ID_PHILIPS) {
> > -                     dev_dbg(&bus->dev, "addr %d not philips id: %d\n",
> > -                             address, status);
> > -                     goto fail1;
> > -             }
> > -             status = isp1301_get_u16(isp, ISP1301_PRODUCT_ID);
> > -             if (status != I2C_PRODUCT_ID_PHILIPS_1301) {
> > -                     dev_dbg(&bus->dev, "%d not isp1301, %d\n",
> > -                             address, status);
> > -                     goto fail1;
> > -             }
> > +     status = isp1301_get_u16(isp, ISP1301_VENDOR_ID);
> > +     if (status != I2C_VENDOR_ID_PHILIPS) {
> > +             dev_dbg(&client->dev, "not philips id: %d\n",
> > +                             status);
>
> Fits on a single line.

Good catch. Changing today.

>
> > +             goto fail1;
> > +     }
> > +     status = isp1301_get_u16(isp, ISP1301_PRODUCT_ID);
> > +     if (status != I2C_PRODUCT_ID_PHILIPS_1301) {
> > +             dev_dbg(&client->dev, "not isp1301, %d\n",
> > +                             status);
>
> Same here.
>
> > +             goto fail1;
> >       }
> >
> > -     status = i2c_attach_client(i2c);
> >       if (status < 0) {
> > -             dev_dbg(&bus->dev, "can't attach %s to device %d, err %d\n",
> > -                             DRIVER_NAME, address, status);
> > +             dev_dbg(&client->dev, "can't attach %s to device, err %d\n",
> > +                             DRIVER_NAME, status);
>
> It doesn't make sense to remove the call to i2c_attach_client() but
> preserve the status check and debug message!

Hmm... sorry for that.
Changing.

>
>
> >  fail1:
> >               kfree(isp);
> >               return 0;
> >       }
> > -     isp->i2c_release = i2c->dev.release;
> > -     i2c->dev.release = isp1301_release;
> > +     isp->i2c_release = client->dev.release;
> > +     client->dev.release = isp1301_release;
> >
> >       /* initial development used chiprev 2.00 */
> > -     status = i2c_smbus_read_word_data(i2c, ISP1301_BCD_DEVICE);
> > -     dev_info(&i2c->dev, "chiprev %x.%02x, driver " DRIVER_VERSION "\n",
> > +     status = i2c_smbus_read_word_data(client, ISP1301_BCD_DEVICE);
> > +     dev_info(&client->dev, "chiprev %x.%02x, driver " DRIVER_VERSION "\n",
> >               status >> 8, status & 0xff);
> >
> >       /* make like power-on reset */
> > @@ -1558,40 +1527,25 @@ fail1:
> >  #ifdef       CONFIG_USB_OTG
> >       status = otg_bind(isp);
> >       if (status < 0) {
> > -             dev_dbg(&i2c->dev, "can't bind OTG\n");
> > +             dev_dbg(&client->dev, "can't bind OTG\n");
> >               goto fail2;
> >       }
> >  #endif
> >
> > -     if (machine_is_omap_h2()) {
> > -             /* full speed signaling by default */
> > -             isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1,
> > -                     MC1_SPEED_REG);
> > -             isp1301_set_bits(isp, ISP1301_MODE_CONTROL_2,
> > -                     MC2_SPD_SUSP_CTRL);
> > -
> > -             /* IRQ wired at M14 */
> > -             omap_cfg_reg(M14_1510_GPIO2);
> > -             isp->irq = OMAP_GPIO_IRQ(2);
> > -             if (gpio_request(2, "isp1301") == 0)
> > -                     gpio_direction_input(2);
> > -             isp->irq_type = IRQF_TRIGGER_FALLING;
> > -     }
>
> Again, why would you remove this code?
>
> > -
> > -     isp->irq_type |= IRQF_SAMPLE_RANDOM;
> > -     status = request_irq(isp->irq, isp1301_irq,
> > -                     isp->irq_type, DRIVER_NAME, isp);
> > +     status = request_irq(client->irq, isp1301_irq,
> > +                     IRQF_SAMPLE_RANDOM | IRQF_TRIGGER_FALLING,
> > +                     DRIVER_NAME, isp);
>
> When freeing the irq you first test that client->irq > 0, but when
> requesting it you do not? It's inconsistent.

I'll fix it.

>
> Also, the original code was passing different IRQF flags depending on
> the platform, your changes force the same mode for everyone. This
> doesn't look correct.

Maybe one other thing to come from a private_data.

>
> >       if (status < 0) {
> > -             dev_dbg(&i2c->dev, "can't get IRQ %d, err %d\n",
> > -                             isp->irq, status);
> > +             dev_dbg(&client->dev, "can't get IRQ %d, err %d\n",
> > +                             client->irq, status);
> >  #ifdef       CONFIG_USB_OTG
> >  fail2:
> >  #endif
> > -             i2c_detach_client(i2c);
> > +             i2c_detach_client(client);
> >               goto fail1;
> >       }
> >
> > -     isp->otg.dev = &isp->client->dev;
> > +     isp->otg.dev = &client->dev;
> >       isp->otg.label = DRIVER_NAME;
> >
> >       isp->otg.set_host = isp1301_set_host,
> > @@ -1608,43 +1562,42 @@ fail2:
> >       update_otg1(isp, isp1301_get_u8(isp, ISP1301_INTERRUPT_SOURCE));
> >       update_otg2(isp, isp1301_get_u8(isp, ISP1301_OTG_STATUS));
> >  #endif
> > -
>
> Noise, please revert.

Reverting

>
>
> >       dump_regs(isp, __FUNCTION__);
> >
> >  #ifdef       VERBOSE
> >       mod_timer(&isp->timer, jiffies + TIMER_JIFFIES);
> > -     dev_dbg(&i2c->dev, "scheduled timer, %d min\n", TIMER_MINUTES);
> > +     dev_dbg(&client->dev, "scheduled timer, %d min\n", TIMER_MINUTES);
> >  #endif
> >
> >       status = otg_set_transceiver(&isp->otg);
> >       if (status < 0)
> > -             dev_err(&i2c->dev, "can't register transceiver, %d\n",
> > +             dev_err(&client->dev, "can't register transceiver, %d\n",
> >                       status);
> >
> >       return 0;
> >  }
> >
> > -static int isp1301_scan_bus(struct i2c_adapter *bus)
> > -{
> > -     if (!i2c_check_functionality(bus, I2C_FUNC_SMBUS_BYTE_DATA
> > -                     | I2C_FUNC_SMBUS_READ_WORD_DATA))
> > -             return -EINVAL;
> > -     return i2c_probe(bus, &addr_data, isp1301_probe);
> > -}
> > -
> >  static struct i2c_driver isp1301_driver = {
> >       .driver = {
> >               .name   = "isp1301_omap",
> >       },
> > -     .attach_adapter = isp1301_scan_bus,
> > -     .detach_client  = isp1301_detach_client,
> > +     .probe  = isp1301_probe,
> > +     .remove = __exit_p(isp1301_remove),
> >  };
> >
> >  /*-------------------------------------------------------------------------*/
> >
> >  static int __init isp_init(void)
> >  {
> > -     return i2c_add_driver(&isp1301_driver);
> > +     int     status = -ENODEV;
> > +
> > +     printk(KERN_INFO "%s: version %s\n", DRIVER_NAME, DRIVER_VERSION);
>
> What's the point of printing a driver version that nobody bothers
> updating?
>
> Most i2c chip drivers keep quiet when loaded, they print a message when
> a device is actually found, as this driver is doing.

Ok. Changing

>
> > +
> > +     status = i2c_add_driver(&isp1301_driver);
> > +     if (status)
> > +             printk(KERN_ERR "%s failed to probe\n", DRIVER_NAME);
>
> This is extremely unlikely to happen, and if it did, i2c-core would
> already log a more informative error message, and insmod/modprobe as
> well. So you can just call i2c_add_driver() and be done with it (as
> the driver was originally doing.)

Ok. Changing


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
