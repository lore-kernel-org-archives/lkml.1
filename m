Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532Ab0ACT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0ACT7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 14:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059Ab0ACT7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 14:59:14 -0500
Received: from us-mx4.synaptics.com ([12.178.49.178]:8544 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0ACT7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 14:59:13 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 14:59:13 EST
X-PGP-Universal: processed;
	by securemail.synaptics.com on Sun, 03 Jan 2010 10:54:30 -0800
From: William Manson <WManson@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Christopher Heiny <Cheiny@synaptics.com>
CC: Allie Xiong <axiong@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 3 Jan 2010 11:48:55 -0800
Subject: RE: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
	Driver
Thread-Topic: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen
	Driver
Thread-Index: AcqBIYwkB1xUNYpPRmKB5hcUui/JBgLjDwhs
Message-ID: <7B4B50AC280A5E45A42CD2D364A3CE2F273406474D@USW-EX2K7-1.synaptics-inc.local>
References: <4B2D3B3A.2010308@synaptics.com>
 <4B2D3C53.8060908@synaptics.com>,<20091220030512.GE4073@core.coreip.homeip.net>
In-Reply-To: <20091220030512.GE4073@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry -

Thanks for the feedback - we really appreciate it. We are currently looking into the issues and the mailer-line wrap issue. We'll be re-sending a patch as soon as we get these issue resolved as soon as possible.
Thanks,
William Manson

________________________________________
From: Dmitry Torokhov [dmitry.torokhov@gmail.com]
Sent: Saturday, December 19, 2009 7:05 PM
To: Christopher Heiny
Cc: Allie Xiong; William Manson; linux-kernel
Subject: Re: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver

Hi Christopher,

On Sat, Dec 19, 2009 at 12:49:23PM -0800, Christopher Heiny wrote:
> From: William Manson <WManson@synaptics.com>
>
> Initial driver for Synaptics touchscreens using RMI4 protocol.

Thank you very much for the driver. Unfortunately your mailer line-wrapped
the patch, I also am not sure whether teh identation style was damaged
my the mailer or if it is the original style (the kernel's standard is
ident with hard TABs).

Some more appearance-related comments inside, I will look at the code
more closely later.

>
> Signed-off-by: William Manson <WManson@synaptics.com>
> Signed-off-by: Allie Xiong <axiong@synaptics.com>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>
>
> index 32fc8ba..2b950f7 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -295,6 +295,19 @@ config TOUCHSCREEN_MIGOR
>         To compile this driver as a module, choose M here: the
>         module will be called migor_ts.
>
> +config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
> +     tristate "Synaptics RMI4 I2C touchscreens"
> +     depends on I2C
> +     help
> +       Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
> +       your system. This enables support for Synaptics RMI4 over I2C based
> +          touchscreens.
> +
> +       If unsure, say N.
> +
> +       To compile this driver as a set of modules, choose M here: the
> +       modules will be called rmi, rmi_app_touchpad, rmi_phys_i2c.

I guess I need to read your RMI document but it is funny to see the
entry in touchscreens with the only application of touchpad. Do you
intend to produce more application modules later?

> +
>  config TOUCHSCREEN_TOUCHRIGHT
>       tristate "Touchright serial touchscreen"
>       select SERIO
> diff --git a/drivers/input/touchscreen/Makefile
> b/drivers/input/touchscreen/Makefile
> index f1f59c9..81f938a 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -12,7 +12,6 @@ obj-$(CONFIG_TOUCHSCREEN_ADS7846)   += ads7846.o
>  obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)       += atmel_tsadcc.o
>  obj-$(CONFIG_TOUCHSCREEN_BITSY)              += h3600_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_CORGI)              += corgi_ts.o
> -obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)    += dynapro.o

Uh-oh, what did you do with dynapro?

>  obj-$(CONFIG_TOUCHSCREEN_GUNZE)              += gunze.o
>  obj-$(CONFIG_TOUCHSCREEN_EETI)               += eeti_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_ELO)                += elo.o
> @@ -26,9 +25,8 @@ obj-$(CONFIG_TOUCHSCREEN_HP600)             += hp680_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_HP7XX)              += jornada720_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_HTCPEN)     += htcpen.o
>  obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)      += usbtouchscreen.o
> -obj-$(CONFIG_TOUCHSCREEN_PCAP)               += pcap_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)   += penmount.o
> -obj-$(CONFIG_TOUCHSCREEN_S3C2410)    += s3c2410_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C) += rmi_core.o
> rmi_app_touchpad.o rmi_function_11.o rmi_phys_i2c.o rmi_i2c_gta01.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213) += touchit213.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT) += touchright.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)   += touchwin.o
> @@ -44,3 +42,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)      += atmel-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)   += mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)    += zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)    += w90p910_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_PCAP)               += pcap_ts.o
> diff --git a/drivers/input/touchscreen/rmi.h
> b/drivers/input/touchscreen/rmi.h
> new file mode 100755
> index 0000000..6caa66f
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi.h
> @@ -0,0 +1,286 @@
> +/**
> + * \file
> + * Synaptics Register Mapped Interface (RMI4) Header File.
> + * Copyright (c) 2007-2009 Synaptics Incorporated
> + *
> + *
> + */
> +/*
> + * This file is licensed under the GPL2 license.
> + *
> +
> *#############################################################################
> + * GPL
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> +
> *#############################################################################
> + */
> +
> +/** RMI4 Protocol Support
> + */
> +
> +/** For each function present on the RMI device, we need to get the
> RMI4 Function
> + *  Descriptor info from the Page Descriptor Table. This will give us the
> + *  addresses for Query, Command, Control, Data and the Source Count
> (number
> + *  of sources for this function) and the function id.
> + */
> +struct rmi_function_descriptor {
> +  unsigned char queryBaseAddr;
> +  unsigned char commandBaseAddr;
> +  unsigned char controlBaseAddr;
> +  unsigned char dataBaseAddr;
> +  unsigned char interruptSrcCnt;
> +  unsigned char functionNum;
> +};
> +
> +/** For each function present on the RMI device, there will be a
> corresponding
> + * entry in the functions list of the rmi_module_info structure.  This
> entry
> + * gives information about the number of data sources and the number of
> data
> + * registers associated with the function.
> + * \see rmi_module_info
> + */
> +struct rmi_function_info {
> +  unsigned char functionNum;
> +
> +  /** This is the number of data sources associated with the function.
> +   * \note This is not the total number of data registers associated with
> +   * this function!
> +   * \see data_regs

This style of markups is not used in the kernel, please try adopting
kerneldoc style (Documentation/kernel-doc-nano-HOWTO.txt)

> +   */
> +  unsigned char numSources;
> +
> +  /** This is the number of data points supported - for example, for
> +   *  function $11 (2D sensor) the number of data points is equal to
> the number
> +   *  of fingers - for function $19 (buttons)it is the number of buttons.
> +   */
> +  unsigned char numDataPoints;
> +
> +  /** This is the number of data registers to read.
> +   */
> +  unsigned char dataRegBlockSize;
> +
> +  /** This is the interrupt register and mask - needed for enabling the
> interrupts
> +   *  and for checking what source had caused the attention line interrupt.
> +   */
> +  unsigned char interruptRegister;
> +  unsigned char interruptMask;
> +
> +  /** This is the RMI function descriptor associated with this function.
> +   *  It contains the Base addresses for the functions query, command,
> +   *  control, and data registers.
> +   */
> +  struct rmi_function_descriptor funcDescriptor;
> +
> +  /** Standard kernel linked list implementation.
> +   * Documentation on how to use it can be found at
> +   * http://isis.poly.edu/kulesh/stuff/src/klist/.
> +   */
> +  struct list_head link;
> +};
> +
> +/* This struct is for creating a list of RMI4 functions that have data
> sources
> +   associated with them. This is to facilitate adding new support for other
> +   data sources besides 2D sensors.
> +
> +   To add a new data source support, the developer will create a new file
> +   and add these 4 functions below with FN$## in front of the names - where
> +   ## is the hex number for the function taken from the RMI4 specification.
> +
> +   The function number will be associated with this and later will be
> used to
> +   match the RMI4 function to the 4 functions for that RMI4 function
> number.
> +
> +   The user will also have to add code that adds the new rmi_functions item
> +   to the global list of RMI4 functions and stores the pointers to the
> 4 functions
> +   in the function pointers.
> +*/
> +struct rmi_functions {
> +  unsigned char functionNum;
> +
> +  struct input_dev *input;
> +
> +  /* ptrs to function specific functions for report, config, init and
> detect. */
> +  /* These ptrs. need to be filled in for every RMI4 function that has data
> +     source(s) associated with it - like fn $11 (2D sensors), fn $19
> (buttons),
> +     etc. Each RMI4 function that has data sources will be added into a
> list
> +     that is used to match the function number against the number
> stored here.
> +  */
> +  int  (*report)(struct rmi_application *app, struct rmi_function_info
> *rfi, struct input_dev *input);
> +  void (*config)(struct rmi_application *app, struct rmi_function_info
> *rfi);
> +  void (*init)(struct input_dev *input);
> +  void (*detect)(struct rmi_application *app, struct rmi_function_info
> *rfi, struct rmi_function_descriptor *fd, unsigned int interruptCount);
> +
> +  /** Standard kernel linked list implementation.
> +   * Documentation on how to use it can be found at
> +   * http://isis.poly.edu/kulesh/stuff/src/klist/.
> +   */
> +  struct list_head link;
> +};
> +
> +
> +/* Each time a new RMI4 function support is added the developer needs
> to bump the number of
> +   supported data src functions and add the info for that RMI4 function
> to the array along
> +   with pointers to the report, config, init and detect functions that
> they coded in rmi_function_xx.c
> +   and rmi_function_xx.h - where xx is the RMI4 function number for the
> new RMI4 data source function.
> +   The information for the RMI4 functions is obtained from the RMI4
> specification document.
> +*/
> +#define rmi4_num_supported_data_src_fns 1
> +
> +/* add hdr files for all prototypes for RMI4 data source functions
> being supported */
> +#include "rmi_function_11.h"
> +/* #include "rmi_function_19.h" */
> +
> +typedef int(*reportFuncPtr)(struct rmi_application *, struct
> rmi_function_info *, struct input_dev *);
> +typedef void(*configFuncPtr)(struct rmi_application *app, struct
> rmi_function_info *rfi);
> +typedef void(*initFuncPtr)(struct input_dev *);
> +typedef void(*detectFuncPtr)(struct rmi_application *, struct
> rmi_function_info *, struct rmi_function_descriptor *, unsigned int);
> +
> +struct rmi_functions_data {
> +  int functionNumber;
> +  reportFuncPtr reportFn;
> +  configFuncPtr configFn;
> +  initFuncPtr initFn;
> +  detectFuncPtr detectFn;
> +};
> +/* NOTE:
> +   Developer - add in any new RMI4 fn data info - function number and
> ptrs to report, config, init and detect functions.
> +   This data is used to point to the functions that need to be called
> to config, init, detect and report data for the
> +   new RMI4 function. These only need to be added for RMI4 functions
> that support data source - like 2D sensors, buttons,
> +   LEDs, GPIOs, etc. Refer to the RMI4 specification for information on
> these RMI4 functions and what data they report.
> +*/
> +
> +struct rmi_functions_data
> rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] =
> +{
> +  /* Fn $11 */
> +  {0x11, FN_11_report, FN_11_config, FN_11_init, FN_11_detect},
> +  /* Fn $19 */
> +  /* {0x19, FN_19_report, FN_19_config, FN_19_init, FN_19_detect), */
> +
> +};
> +
> +
> +/** This encapsulates the information found using the RMI4 Function $01
> + *  query registers. There is only one Function $01 per device.
> + *
> + *  Assuming appropriate endian-ness, you can populate most of this
> + *  structure by reading query registers starting at the query base address
> + *  that was obtained from RMI4 function 0x01 function descriptor info read
> + *  from the Page Descriptor Table.
> + *
> + *  Specific register information is provided in the comments for each
> field.
> + *  For further reference, please see the <i>Synaptics RMI4 Interfacing
> + *  Guide</i> document.
> + */
> +struct rmi_module_info {
> +  /** The Protocol Major Version number.
> +   */
> +  unsigned rmi_maj_ver;
> +
> +  /** The Protocol Minor Version number.
> +   */
> +  unsigned rmi_min_ver;
> +
> +  /** The manufacturer identification byte.
> +   */
> +  unsigned char mfgid;
> +
> +  /** The Product Properties information.
> +   */
> +  unsigned char properties;
> +
> +  /** The product info bytes.
> +   * You can build a product info string using the following printf
> +   * format and args:
> +   * \code printf("%i %02i", productInfo[0], productInfo[1]); \endcode
> +   */
> +  unsigned char prod_info[2];
> +
> +   /** Date Code - Year, Month, Day.
> +    */
> +  unsigned char date_code[3];
> +
> +  /** Tester ID (14 bits).
> +   */
> +  unsigned short tester_id;
> +
> +  /** Serial Number (14 bits).
> +   */
> +  unsigned short serial_num;
> +
> +  /** A null-terminated string that identifies this particular product.
> +   */
> +  char prod_id[10];
> +
> +  /** A list of the function presence queries.
> +   * This list uses the standard kernel linked list implementation.
> +   * Documentation on on how to use it can be found at
> +   * http://isis.poly.edu/kulesh/stuff/src/klist/.
> +   * \see rmi_function_info
> +   */
> +  struct list_head functions;
> +};
> +
> +struct rmi_phys_driver {
> +  char *name;
> +  int  (*write)(struct rmi_phys_driver *pd, unsigned short address,
> char data);
> +  int  (*read)(struct rmi_phys_driver *pd, unsigned short address, char
> *buffer);
> +  int  (*write_multiple)(struct rmi_phys_driver *pd, unsigned short
> address, char *buffer, int length);
> +  int  (*read_multiple)(struct rmi_phys_driver *pd, unsigned short
> address, char *buffer, int length);
> +  void (*attention)(struct rmi_phys_driver *pd, int instance);
> +  int  (*get_attention)(struct rmi_phys_driver *pd);
> +  int  polling_required;
> +  /* Private elements of the structure */
> +  /** Standard kernel linked list implementation.
> +   * Documentation on how to use it can be found at
> +   * http://isis.poly.edu/kulesh/stuff/src/klist/.
> +   */
> +  struct list_head drivers;
> +  struct rmi_application *app;
> +  struct rmi_module_info rmi;
> +  struct module *module;
> +};
> +
> +int rmi_read(struct rmi_application *app, unsigned short address, char
> *dest);
> +int rmi_write(struct rmi_application *app, unsigned short address,
> unsigned char data);
> +int rmi_read_multiple(struct rmi_application *app, unsigned short
> address, char *dest, int length);
> +int rmi_write_multiple(struct rmi_application *app, unsigned short
> address, unsigned char *data, int length);
> +int rmi_register_phys_driver(struct rmi_phys_driver *rpd);
> +int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd);
> +
> +struct rmi_application *rmi_register_application(const char *name,
> +  void (*attention)(struct rmi_phys_driver *pd, int instance),
> +  int (*probe)(struct rmi_application *app, const struct
> rmi_module_info *rmi),
> +  void (*config)(struct rmi_application *app));
> +
> +void rmi_unregister_application(struct rmi_application *app);
> +int  rmi_polling_required(struct rmi_application *app);
> +int  rmi_get_attn(struct rmi_application *app);
> +
> +/** Set this to 1 to turn on code used in detecting buffer leaks. */
> +#define RMI_ALLOC_STATS 1
> +
> +#if RMI_ALLOC_STATS
> +extern int appallocsrmi;
> +extern int rfiallocsrmi;
> +extern int fnallocsrmi;
> +
> +#   define INC_ALLOC_STAT(X)   X##allocsrmi++
> +#   define DEC_ALLOC_STAT(X)   \
> +     do { if(X##allocsrmi) X##allocsrmi--; \
> +          else printk("Too many " #X " frees\n"); } while(0)
> +#   define CHECK_ALLOC_STAT(X) \
> +     do { if(X##allocsrmi) printk("Left over " #X " buffers: %d\n", \
> +             X##allocsrmi); } while(0)
> +#else
> +#   define INC_ALLOC_STAT(X)   do { } while(0)
> +#   define DEC_ALLOC_STAT(X)   do { } while(0)
> +#   define CHECK_ALLOC_STAT(X) do { } while(0)
> +#endif
> +
> +/* vim600: set noexpandtab sw=8 ts=8 :*/
> diff --git a/drivers/input/touchscreen/rmi.mod.c

This is auto-generated file nad should not be included in the patch.

> b/drivers/input/touchscreen/rmi.mod.c
> new file mode 100755
> index 0000000..e11b023
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi.mod.c

> @@ -0,0 +1,20 @@
> +#include <linux/module.h>
> +#include <linux/vermagic.h>
> +#include <linux/compiler.h>
> +
> +MODULE_INFO(vermagic, VERMAGIC_STRING);
> +
> +struct module __this_module
> +__attribute__((section(".gnu.linkonce.this_module"))) = {
> + .name = KBUILD_MODNAME,
> + .init = init_module,
> +#ifdef CONFIG_MODULE_UNLOAD
> + .exit = cleanup_module,
> +#endif
> +};
> +
> +static const char __module_depends[]
> +__attribute_used__
> +__attribute__((section(".modinfo"))) =
> +"depends=";
> +
> diff --git a/drivers/input/touchscreen/rmi_app_touchpad.c
> b/drivers/input/touchscreen/rmi_app_touchpad.c
> new file mode 100755
> index 0000000..bc4d17f
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi_app_touchpad.c
> @@ -0,0 +1,458 @@
> +/**
> + * \file
> + * Synaptics Register Mapped Interface (RMI4) TouchPad Application
> Layer Driver.
> + * Copyright (c) 2007-2009 Synaptics Incorporated
> + *
> + *
> + * This code implements a polling mechanism with backoff as well as
> + * interrupt-driven sampling.  For polling, the module has two parameters:
> + * polljif (Poll Jiffies) and hspolljif (High Speed Poll Jiffies).  The
> driver
> + * polls at polljif until it sees a press, and then it polls at hspolljif.
> + * When there is no longer a touch, it reverts to the polljif period.
> + *
> + * The polljif parameter can be changed during run time like this:\code
> + *   echo 100 > /sys/module/rmi_app_touchpad/parameters/polljif
> + * \endcode
> + *
> + * That will change the pollrate to 1 per second (assuming HZ == 100).  The
> + * same is true for hspolljif.
> + *
> + * The parameters have no effect for the interrupt-driven case.
> + *
> + * Note that it is the lower-level drivers that determine whether this
> driver
> + * has to do polling or interrupt-driven.  Polling can always be done,
> but if
> + * we have an interrupt connected to the attention (ATTN) line, then it is
> + * better to be interrupt driven.
> + *
> + */
> +/*
> + * This file is licensed under the GPL2 license.
> + *
> +
> *#############################################################################
> + * GPL
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> + * for more details.
> + *
> +
> *#############################################################################
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/input.h>
> +
> +#include "rmi_core.h"
> +#include "rmi.h"
> +
> +#if RMI_ALLOC_STATS
> +  static int pollallocsrmi = 0;
> +#endif
> +
> +#define RMI_REPORT_RATE_40 (1 << 6)
> +
> +/** The number of jiffies between polls without touches */
> +static int polljif = HZ/20;
> +/** The number of jiffies between polls with touches */
> +static int hspolljif = HZ/40;
> +module_param(polljif, int, 0644);
> +module_param(hspolljif, int, 0644);
> +MODULE_PARM_DESC(polljif,   "How many jiffies between low speed polls.");
> +MODULE_PARM_DESC(hspolljif, "How many jiffies between high speed polls.");

msecs is better suited for user interface and does not depend on HZ.

> +
> +static struct rmi_application *app = NULL;
> +static struct completion touch_completion;
> +static struct completion thread_comp;
> +struct task_struct *kthread = NULL;
> +static int time_to_quit = 0;
> +static struct input_dev *input = NULL;

No need to initialize statics to 0/NULL.


Quickly scanning the rest there seem to be some more auto-generated
files in the patch and also sometimes style does not quite follow the
onle we have in the kernel. Would you mind running it through
scripts/checkpatch.pl (don't worry about 80 column limit warnings), make
sure the mailer does not mange the patch and resubmit so we can
concentrate on the meat of the changes instead of cosmetics.

Thanks a lot!

--
Dmitry
