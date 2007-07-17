Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXGQNUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXGQNUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXGQNUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:20:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:20159 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXGQNUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y2TKHKrttWfBZ06O6nSGbPm+imZY9kicCW7YrOf7AwA1+LCqSobdKI6Ey9T+DPHnRN2icEtPdeLlRG1CEUyrN8yf4AYUdqYI6CLfILkqjIIvTn0t5tjsdNp4pv+QyJuoj3jmvMZGfQ2Hw0JxThRenG7KTo7XaqsVn95sEIUOfw8=
Message-ID: <d120d5000707170620y31b8351dkb904312445f3f6e3@mail.gmail.com>
Date: Tue, 17 Jul 2007 09:20:34 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
Cc: "Richard Purdie" <rpurdie@rpsys.net>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, "Rodrigo Pereira" <rodripe@gmail.com>
In-Reply-To: <469C978A.5060809@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <469C978A.5060809@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Németh Márton <nm127@freemail.hu> wrote:
> +
> +#define TRUE                   1
> +#define FALSE                  0
> +
> +#define CLEVO_MAIL_LED_OFF             0x0084
> +#define CLEVO_MAIL_LED_BLINK_1HZ       0x008A
> +#define CLEVO_MAIL_LED_BLINK_0_5HZ     0x0083
> +
> +#define MODULE_FNAME   "leds-clevo-mail.c"
> +#define DRVNAME                        "clevo-mail-led"
> +#define NO_RESOURCES           NULL
> +
> +#define printk_hint(fmt, args...)                       \
> +       printk(KERN_ERR MODULE_FNAME ": " fmt, ## args)
> +
> +
> +#define printk_dmi(field)                               \
> +       printk(KERN_ERR MODULE_FNAME                    \
> +              ":    " # field "=\"%s\"\n",             \
> +              dmi_get_system_info(field))
> +
> +
> +MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
> +MODULE_DESCRIPTION("Clevo mail LED driver");
> +MODULE_LICENSE("GPL");
> +
> +static unsigned int __initdata nodetect;
> +module_param_named(nodetect, nodetect, bool, 0);
> +MODULE_PARM_DESC(nodetect, "Skip DMI hardware detection");
> +
> +
> +static struct platform_device *pdev;
> +
> +
> +static int __init led_dmi_callback(struct dmi_system_id *id) {

Functions are not statements (opening brace placement).

> +       printk(KERN_INFO MODULE_FNAME ": '%s' found\n", id->ident);
> +       return 1;
> +}
> +
> +/**
> + * struct mail_led_whitelist - List of known good models
> + *
> + * Contains the known good models this driver is compatible with.
> + * When adding a new model try to be as strict as possible. This
> + * makes it possible to keep the false positives (the model is
> + * detected as working, but in reality it is not) as low as
> + * possible.
> + */
> +static struct dmi_system_id __initdata mail_led_whitelist[] = {
> +       {
> +               .callback = led_dmi_callback,
> +               .ident = "Clevo D410J",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "VIA"),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "K8N800"),
> +                       DMI_MATCH(DMI_PRODUCT_VERSION, "VT8204B")
> +               }
> +       },
> +       {
> +               .callback = led_dmi_callback,
> +               .ident = "Clevo M5x0N",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "M5x0N")
> +               }
> +       },
> +       {
> +               .callback = led_dmi_callback,
> +               .ident = "Positivo Mobile",
> +               .matches = {
> +                       DMI_MATCH(DMI_BOARD_VENDOR, "CLEVO Co. "),
> +                       DMI_MATCH(DMI_BOARD_NAME, "M5X0V "),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "Positivo Mobile"),
> +                       DMI_MATCH(DMI_PRODUCT_VERSION, "VT6198")
> +               }
> +       },
> +       {
> +               .callback = led_dmi_callback,
> +               .ident = "Clevo D410V",
> +               .matches = {
> +                       DMI_MATCH(DMI_BOARD_VENDOR, "Clevo, Co."),
> +                       DMI_MATCH(DMI_BOARD_NAME, "D400V/D470V"),
> +                       DMI_MATCH(DMI_BOARD_VERSION, "SS78B"),
> +                       DMI_MATCH(DMI_PRODUCT_VERSION, "Rev. A1")
> +               }
> +       },
> +       { }
> +};
> +
> +
> +static void clevo_mail_led_set(struct led_classdev *led_cdev,
> +                               enum led_brightness value)
> +{
> +       if (value == LED_OFF) {
> +               i8042_command(NULL, CLEVO_MAIL_LED_OFF);
> +       } else if (value <= LED_HALF) {
> +               i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
> +       } else {
> +               i8042_command(NULL, CLEVO_MAIL_LED_BLINK_1HZ);
> +       }
> +

I think general preference is not to use braces for single-line bodies.

> +}
> +
> +static int clevo_mail_led_blink(struct led_classdev *led_cdev,
> +                               int delay_on, int delay_off)
> +{
> +       int supported = 0;
> +
> +       if (delay_on == 500 /* ms */ && delay_off == 500 /* ms */) {
> +               /* blink the led with 1Hz */
> +               i8042_command(NULL, CLEVO_MAIL_LED_BLINK_1HZ);
> +               supported = 1;
> +
> +       } else if (delay_on == 1000 /* ms */ && delay_off == 1000 /* ms */) {
> +               /* blink the led with 0.5Hz */
> +               i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
> +               supported = 1;
> +
> +       } else {
> +               printk(KERN_DEBUG MODULE_FNAME
> +                      ": clevo_mail_led_blink(..., %u, %u),"
> +                      " returning 0 (unsupported)\n", delay_on, delay_off);
> +       }
> +
> +       return supported;

Please return 0/-EINVAL.

> +}
> +
> +
> +static struct led_classdev clevo_mail_led = {
> +       .name                   = "clevo::mail",
> +       .brightness_set         = clevo_mail_led_set,
> +       .blink_set              = clevo_mail_led_blink,
> +};
> +
> +static int __init clevo_mail_led_probe(struct platform_device *pdev)
> +{
> +       int error;
> +
> +       printk(KERN_DEBUG MODULE_FNAME ": probe()\n");
> +

Use pr_debug here or just kill it - it will litter users dmesgs.

> +       error = led_classdev_register(&pdev->dev, &clevo_mail_led);
> +       return error;
> +}
> +
> +static int clevo_mail_led_remove(struct platform_device *pdev)
> +{
> +
> +       printk(KERN_DEBUG MODULE_FNAME ": remove()\n");
> +
> +       led_classdev_unregister(&clevo_mail_led);
> +       return 0;
> +}
> +
> +
> +
> +#ifdef CONFIG_PM
> +static int clevo_mail_led_suspend(struct platform_device *dev,
> +                                 pm_message_t state)
> +{
> +       led_classdev_suspend(&clevo_mail_led);
> +       return 0;
> +}
> +
> +static int clevo_mail_led_resume(struct platform_device *dev)
> +{
> +       led_classdev_resume(&clevo_mail_led);
> +       return 0;
> +}
> +#endif
> +
> +static struct platform_driver clevo_mail_led_driver = {
> +       .probe          = clevo_mail_led_probe,
> +       .remove         = clevo_mail_led_remove,
> +#ifdef CONFIG_PM
> +       .suspend        = clevo_mail_led_suspend,
> +       .resume         = clevo_mail_led_resume,
> +#endif
> +       .driver         = {
> +               .name           = DRVNAME,
> +       },
> +};
> +
> +
> +static __init void print_hints(void)
> +{
> +       if (!nodetect) {
> +               printk_hint("Current hardware not supported:\n");
> +       } else {
> +               printk_hint("Current hardware is:\n");
> +       }
> +       printk_dmi(DMI_BIOS_VENDOR);
> +       printk_dmi(DMI_BIOS_VERSION);
> +       printk_dmi(DMI_BIOS_DATE);
> +       printk_dmi(DMI_SYS_VENDOR);
> +       printk_dmi(DMI_PRODUCT_NAME);
> +       printk_dmi(DMI_PRODUCT_VERSION);
> +       printk_dmi(DMI_PRODUCT_SERIAL);
> +       printk_dmi(DMI_BOARD_VENDOR);
> +       printk_dmi(DMI_BOARD_NAME);
> +       printk_dmi(DMI_BOARD_VERSION);
> +       if (!nodetect) {
> +               printk_hint("Try 'nodetect' module parameter.\n");
> +       }
> +       printk_hint("If this driver is working with your hardware, report\n");
> +       printk_hint("it through the Tracker at\n");
> +       printk_hint("http://sourceforge.net/projects/clevo-mailled/ in\n");
> +       printk_hint("order your laptop model can be added to the detection.\n");
> +       printk_hint("Please make sure to include in the report\n");
> +       printk_hint("    - all lines starting with \"%s\"\n", MODULE_FNAME);
> +       printk_hint("    - the product model of the laptop and\n");
> +       printk_hint("    - the color of the mail led.\n");
> +}
> +
> +static int __init led_init(void)

clevo_led_init just to be consistent with the rest of the driver?

> +{
> +       int error = 0;
> +       int count = 0;
> +
> +       /* Check with the help of DMI if we are running on supported hardware */
> +       if (!nodetect) {
> +               count = dmi_check_system(mail_led_whitelist);
> +       }
> +       if (!count) {
> +               print_hints();

I really don't want to see that dissertation on my box. Normally we
silently return if DMI data does not match. User has an option to
'force' loading the module. In that case I'd say something like
'Forcing module load. If the driver works on your hardware please
report in tracker at http://sourceforge.net/projects/clevo-mailled/"

-- 
Dmitry
