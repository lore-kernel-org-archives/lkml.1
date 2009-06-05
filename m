Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZFEL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZFEL75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZFEL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:59:50 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52439 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFEL7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wl0diBDMd3RJtw0eGOxT21slFEGzbl5/kMw+4y7nrw7qbVthx5ieiq9x/Xlk0bx7Hd
         ue9Jip+ZKOaWFuopNbGoRrZmcIhd161WF2XjJcKMBdQef75hmGkYpQLIbf0Vi0JGehLM
         RzJL1opVVO0o9UagV7usfdvvz4TjYALx1LJmU=
MIME-Version: 1.0
In-Reply-To: <1244197103.3631.40.camel@Joe-Laptop.home>
References: <1244197103.3631.40.camel@Joe-Laptop.home>
Date: Fri, 5 Jun 2009 13:59:50 +0200
Message-ID: <71cd59b00906050459u2743906dl909e34f71464e24d@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop.c: use pr_fmt and pr_<level>
From: Corentin Chary <corentin.chary@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: acpi4asus-user@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 12:18 PM, Joe Perches<joe@perches.com> wrote:
> Convert the unusual printk(EEEPC_<level> uses to
> the more standard pr_fmt and pr_<level>(.
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 353a898..94cacdd 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -16,6 +16,8 @@
>  *  GNU General Public License for more details.
>  */
>
> +#define pr_fmt(fmt) EEEPC_HOTK_FILE ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> @@ -40,11 +42,6 @@
>  #define EEEPC_HOTK_DEVICE_NAME "Hotkey"
>  #define EEEPC_HOTK_HID         "ASUS010"
>
> -#define EEEPC_LOG      EEEPC_HOTK_FILE ": "
> -#define EEEPC_ERR      KERN_ERR        EEEPC_LOG
> -#define EEEPC_WARNING  KERN_WARNING    EEEPC_LOG
> -#define EEEPC_NOTICE   KERN_NOTICE     EEEPC_LOG
> -#define EEEPC_INFO     KERN_INFO       EEEPC_LOG
>
>  /*
>  * Definitions for Asus EeePC
> @@ -258,7 +255,7 @@ static int set_acpi(int cm, int value)
>                if (method == NULL)
>                        return -ENODEV;
>                if (write_acpi_int(ehotk->handle, method, value, NULL))
> -                       printk(EEEPC_WARNING "Error writing %s\n", method);
> +                       pr_warning("Error writing %s\n", method);
>        }
>        return 0;
>  }
> @@ -271,7 +268,7 @@ static int get_acpi(int cm)
>                if (method == NULL)
>                        return -ENODEV;
>                if (read_acpi_int(ehotk->handle, method, &value))
> -                       printk(EEEPC_WARNING "Error reading %s\n", method);
> +                       pr_warning("Error reading %s\n", method);
>        }
>        return value;
>  }
> @@ -468,26 +465,23 @@ static int eeepc_hotk_check(void)
>        if (ehotk->device->status.present) {
>                if (write_acpi_int(ehotk->handle, "INIT", ehotk->init_flag,
>                                    &buffer)) {
> -                       printk(EEEPC_ERR "Hotkey initialization failed\n");
> +                       pr_err("Hotkey initialization failed\n");
>                        return -ENODEV;
>                } else {
> -                       printk(EEEPC_NOTICE "Hotkey init flags 0x%x\n",
> -                              ehotk->init_flag);
> +                       pr_notice("Hotkey init flags 0x%x\n", ehotk->init_flag);
>                }
>                /* get control methods supported */
>                if (read_acpi_int(ehotk->handle, "CMSG"
>                                   , &ehotk->cm_supported)) {
> -                       printk(EEEPC_ERR
> -                              "Get control methods supported failed\n");
> +                       pr_err("Get control methods supported failed\n");
>                        return -ENODEV;
>                } else {
> -                       printk(EEEPC_INFO
> -                              "Get control methods supported: 0x%x\n",
> -                              ehotk->cm_supported);
> +                       pr_info("Get control methods supported: 0x%x\n",
> +                               ehotk->cm_supported);
>                }
>                ehotk->inputdev = input_allocate_device();
>                if (!ehotk->inputdev) {
> -                       printk(EEEPC_INFO "Unable to allocate input device\n");
> +                       pr_info("Unable to allocate input device\n");
>                        return 0;
>                }
>                ehotk->inputdev->name = "Asus EeePC extra buttons";
> @@ -506,12 +500,12 @@ static int eeepc_hotk_check(void)
>                }
>                result = input_register_device(ehotk->inputdev);
>                if (result) {
> -                       printk(EEEPC_INFO "Unable to register input device\n");
> +                       pr_info("Unable to register input device\n");
>                        input_free_device(ehotk->inputdev);
>                        return 0;
>                }
>        } else {
> -               printk(EEEPC_ERR "Hotkey device not present, aborting\n");
> +               pr_err("Hotkey device not present, aborting\n");
>                return -EINVAL;
>        }
>        return 0;
> @@ -539,7 +533,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>                return;
>
>        if (!bus) {
> -               printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
> +               pr_warning("Unable to find PCI bus 1?\n");
>                return;
>        }
>
> @@ -556,7 +550,7 @@ static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
>                if (dev) {
>                        pci_bus_assign_resources(bus);
>                        if (pci_bus_add_device(dev))
> -                               printk(EEEPC_ERR "Unable to hotplug wifi\n");
> +                               pr_err("Unable to hotplug wifi\n");
>                }
>        } else {
>                dev = pci_get_slot(bus, 0);
> @@ -629,8 +623,7 @@ static int eeepc_register_rfkill_notifier(char *node)
>                                                     eeepc_rfkill_notify,
>                                                     NULL);
>                if (ACPI_FAILURE(status))
> -                       printk(EEEPC_WARNING
> -                              "Failed to register notify on %s\n", node);
> +                       pr_warning("Failed to register notify on %s\n", node);
>        } else
>                return -ENODEV;
>
> @@ -649,8 +642,7 @@ static void eeepc_unregister_rfkill_notifier(char *node)
>                                                     ACPI_SYSTEM_NOTIFY,
>                                                     eeepc_rfkill_notify);
>                if (ACPI_FAILURE(status))
> -                       printk(EEEPC_ERR
> -                              "Error removing rfkill notify handler %s\n",
> +                       pr_err("Error removing rfkill notify handler %s\n",
>                                node);
>        }
>  }
> @@ -662,7 +654,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
>
>        if (!device)
>                 return -EINVAL;
> -       printk(EEEPC_NOTICE EEEPC_HOTK_NAME "\n");
> +       pr_notice(EEEPC_HOTK_NAME "\n");
>        ehotk = kzalloc(sizeof(struct eeepc_hotk), GFP_KERNEL);
>        if (!ehotk)
>                return -ENOMEM;
> @@ -678,7 +670,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
>        status = acpi_install_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
>                                             eeepc_hotk_notify, ehotk);
>        if (ACPI_FAILURE(status))
> -               printk(EEEPC_ERR "Error installing notify handler\n");
> +               pr_err("Error installing notify handler\n");
>
>        eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
>        eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
> @@ -766,7 +758,7 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
>        status = acpi_remove_notify_handler(ehotk->handle, ACPI_SYSTEM_NOTIFY,
>                                            eeepc_hotk_notify);
>        if (ACPI_FAILURE(status))
> -               printk(EEEPC_ERR "Error removing notify handler\n");
> +               pr_err("Error removing notify handler\n");
>
>        eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
>        eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
> @@ -936,8 +928,7 @@ static int eeepc_backlight_init(struct device *dev)
>        bd = backlight_device_register(EEEPC_HOTK_FILE, dev,
>                                       NULL, &eeepcbl_ops);
>        if (IS_ERR(bd)) {
> -               printk(EEEPC_ERR
> -                      "Could not register eeepc backlight device\n");
> +               pr_err("Could not register eeepc backlight device\n");
>                eeepc_backlight_device = NULL;
>                return PTR_ERR(bd);
>        }
> @@ -956,8 +947,7 @@ static int eeepc_hwmon_init(struct device *dev)
>
>        hwmon = hwmon_device_register(dev);
>        if (IS_ERR(hwmon)) {
> -               printk(EEEPC_ERR
> -                      "Could not register eeepc hwmon device\n");
> +               pr_err("Could not register eeepc hwmon device\n");
>                eeepc_hwmon_device = NULL;
>                return PTR_ERR(hwmon);
>        }
> @@ -990,8 +980,7 @@ static int __init eeepc_laptop_init(void)
>                if (result)
>                        goto fail_backlight;
>        } else
> -               printk(EEEPC_INFO "Backlight controlled by ACPI video "
> -                      "driver\n");
> +               pr_info("Backlight controlled by ACPI video driver\n");
>
>        result = eeepc_hwmon_init(dev);
>        if (result)
>
>
>

Hi, Thanks for the patch.

But it doesn't compile against acpi4asus tree ( at http://git.iksaif.net/ ).

drivers/platform/x86/eeepc-laptop.c: In function
‘eeepc_setup_pci_hotplug’:
drivers/platform/x86/eeepc-laptop.c:743: error: ‘EEEPC_ERR’ undeclared
(first use in this function)
drivers/platform/x86/eeepc-laptop.c:743: error: (Each undeclared
identifier is reported only once
drivers/platform/x86/eeepc-laptop.c:743: error: for each function it
appears in.)
drivers/platform/x86/eeepc-laptop.c:743: error: expected ‘)’ before
string constant
drivers/platform/x86/eeepc-laptop.c:743: warning: format not a string
literal and no format arguments
drivers/platform/x86/eeepc-laptop.c:764: error: expected ‘)’ before
string constant
drivers/platform/x86/eeepc-laptop.c:764: warning: format not a string
literal and no format arguments

I think it's because you use a tree without commit
3a49ed57e6fab16eae8b60afdd05c783ac155fd9 .


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
