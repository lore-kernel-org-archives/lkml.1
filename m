Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJOIlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJOIlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYJOIll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:41:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526AbYJOIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:41:37 -0400
Date: Wed, 15 Oct 2008 01:41:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, w.beiter@aon.at,
       g.gebhardt@meilhaus.de
Subject: Re: [PATCH 09/23] Staging: add me4000 pci data collection driver
Message-Id: <20081015014106.037c8639.akpm@linux-foundation.org>
In-Reply-To: <1223678567-30143-9-git-send-email-greg@kroah.com>
References: <20081010224130.GA30117@kroah.com>
	<1223678567-30143-9-git-send-email-greg@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 10 Oct 2008 15:42:33 -0700 Greg KH <greg@kroah.com> wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Originally written by Guenter Gebhardt <g.gebhardt@meilhaus.de>
> 
> TODO:
> 	- checkpatch.pl cleanups
> 	- sparse cleanups
> 	- possible /proc interaction cleanups
> 	- more info needed for Kconfig entry
> 	- real device id?
> 	- module parameter cleanup

- sort includes (include/linux before asm/)

- Make me4000_board_info_list static

> Cc: Wolfgang Beiter <w.beiter@aon.at>
> Cc: Guenter Gebhardt <g.gebhardt@meilhaus.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/Kconfig         |    2 +
>  drivers/staging/Makefile        |    1 +
>  drivers/staging/me4000/Kconfig  |   10 +
>  drivers/staging/me4000/Makefile |    1 +
>  drivers/staging/me4000/README   |   13 +
>  drivers/staging/me4000/me4000.c | 6133 +++++++++++++++++++++++++++++++++++++++
>  drivers/staging/me4000/me4000.h |  954 ++++++
>  7 files changed, 7114 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/me4000/Kconfig
>  create mode 100644 drivers/staging/me4000/Makefile
>  create mode 100644 drivers/staging/me4000/README
>  create mode 100644 drivers/staging/me4000/me4000.c
>  create mode 100644 drivers/staging/me4000/me4000.h
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 6da7662..56c73bc 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -29,4 +29,6 @@ source "drivers/staging/slicoss/Kconfig"
>  
>  source "drivers/staging/sxg/Kconfig"
>  
> +source "drivers/staging/me4000/Kconfig"
> +
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index cd6d6a5..97df19b 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -3,3 +3,4 @@
>  obj-$(CONFIG_ET131X)		+= et131x/
>  obj-$(CONFIG_SLICOSS)		+= slicoss/
>  obj-$(CONFIG_SXG)		+= sxg/
> +obj-$(CONFIG_ME4000)		+= me4000/
> diff --git a/drivers/staging/me4000/Kconfig b/drivers/staging/me4000/Kconfig
> new file mode 100644
> index 0000000..5e6c9de
> --- /dev/null
> +++ b/drivers/staging/me4000/Kconfig
> @@ -0,0 +1,10 @@
> +config ME4000
> +	tristate "Meilhaus ME-4000 support"
> +	default n
> +	depends on PCI
> +	help
> +	  This driver supports the Meilhaus ME-4000 family of boards
> +	  that do data collection and multipurpose I/O.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called me4000.
> diff --git a/drivers/staging/me4000/Makefile b/drivers/staging/me4000/Makefile
> new file mode 100644
> index 0000000..74487cd
> --- /dev/null
> +++ b/drivers/staging/me4000/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_ME4000)		+= me4000.o
> diff --git a/drivers/staging/me4000/README b/drivers/staging/me4000/README
> new file mode 100644
> index 0000000..bbb8386
> --- /dev/null
> +++ b/drivers/staging/me4000/README
> @@ -0,0 +1,13 @@
> +
> +TODO:
> +	- checkpatch.pl cleanups
> +	- sparse cleanups
> +	- possible /proc interaction cleanups
> +	- more info needed for Kconfig entry
> +	- real device id?
> +	- module parameter cleanup
> +
> +Please send patches to Greg Kroah-Hartman <gregkh@suse.de>
> +and Cc: Wolfgang Beiter <w.beiter@aon.at> and
> +Guenter Gebhardt <g.gebhardt@meilhaus.de>
> +
> diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
> new file mode 100644
> index 0000000..862dd7f
> --- /dev/null
> +++ b/drivers/staging/me4000/me4000.c
> @@ -0,0 +1,6133 @@
> +/* Device driver for Meilhaus ME-4000 board family.
> + * ================================================
> + *
> + *  Copyright (C) 2003 Meilhaus Electronic GmbH (support@meilhaus.de)
> + *
> + *  This file is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + *  Author:	Guenter Gebhardt	<g.gebhardt@meilhaus.de>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/sched.h>
> +#include <linux/interrupt.h>
> +#include <linux/pci.h>
> +#include <asm/io.h>
> +#include <asm/system.h>
> +#include <asm/uaccess.h>
> +#include <linux/errno.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/unistd.h>
> +#include <linux/list.h>
> +#include <linux/proc_fs.h>
> +
> +#include <linux/poll.h>
> +#include <linux/vmalloc.h>
> +#include <asm/pgtable.h>
> +#include <asm/uaccess.h>
> +#include <linux/types.h>

Reorder includes (inxlude/linux before include/asm)

> +#include <linux/slab.h>
> +
> +/* Include-File for the Meilhaus ME-4000 I/O board */
> +#include "me4000.h"
> +#include "me4000_firmware.h"
> +#include "me4610_firmware.h"
> +
> +/* Administrative stuff for modinfo */
> +MODULE_AUTHOR("Guenter Gebhardt <g.gebhardt@meilhaus.de>");
> +MODULE_DESCRIPTION
> +    ("Device Driver Module for Meilhaus ME-4000 boards version 1.0.5");
> +MODULE_SUPPORTED_DEVICE("Meilhaus ME-4000 Multi I/O boards");
> +MODULE_LICENSE("GPL");
> +
> +/* Board specific data are kept in a global list */
> +LIST_HEAD(me4000_board_info_list);

static

> +/* Major Device Numbers. 0 means to get it automatically from the System */
> +static int me4000_ao_major_driver_no = 0;
> +static int me4000_ai_major_driver_no = 0;
> +static int me4000_dio_major_driver_no = 0;
> +static int me4000_cnt_major_driver_no = 0;
> +static int me4000_ext_int_major_driver_no = 0;

s/= 0//

> +/* Let the user specify a custom major driver number */
> +module_param(me4000_ao_major_driver_no, int, 0);
> +MODULE_PARM_DESC(me4000_ao_major_driver_no,
> +		 "Major driver number for analog output (default 0)");
> +
> +module_param(me4000_ai_major_driver_no, int, 0);
> +MODULE_PARM_DESC(me4000_ai_major_driver_no,
> +		 "Major driver number for analog input (default 0)");
> +
> +module_param(me4000_dio_major_driver_no, int, 0);
> +MODULE_PARM_DESC(me4000_dio_major_driver_no,
> +		 "Major driver number digital I/O (default 0)");
> +
> +module_param(me4000_cnt_major_driver_no, int, 0);
> +MODULE_PARM_DESC(me4000_cnt_major_driver_no,
> +		 "Major driver number for counter (default 0)");
> +
> +module_param(me4000_ext_int_major_driver_no, int, 0);
> +MODULE_PARM_DESC(me4000_ext_int_major_driver_no,
> +		 "Major driver number for external interrupt (default 0)");
> +
> +/*-----------------------------------------------------------------------------
> +  Module stuff
> +  ---------------------------------------------------------------------------*/
> +int init_module(void);
> +void cleanup_module(void);

kill

> +/*-----------------------------------------------------------------------------
> +  Board detection and initialization
> +  ---------------------------------------------------------------------------*/
> +static int me4000_probe(struct pci_dev *dev, const struct pci_device_id *id);
> +static int me4000_xilinx_download(me4000_info_t *);
> +static int me4000_reset_board(me4000_info_t *);
> +
> +static void clear_board_info_list(void);
> +static int get_registers(struct pci_dev *dev, me4000_info_t * info);
> +static int init_board_info(struct pci_dev *dev, me4000_info_t * board_info);
> +static int alloc_ao_contexts(me4000_info_t * info);
> +static void release_ao_contexts(me4000_info_t * board_info);
> +static int alloc_ai_context(me4000_info_t * info);
> +static int alloc_dio_context(me4000_info_t * info);
> +static int alloc_cnt_context(me4000_info_t * info);
> +static int alloc_ext_int_context(me4000_info_t * info);

lots of these are unneeded.

> +/*-----------------------------------------------------------------------------
> +  Stuff used by all device parts
> +  ---------------------------------------------------------------------------*/
> +static int me4000_open(struct inode *, struct file *);
> +static int me4000_release(struct inode *, struct file *);
> +
> +static int me4000_get_user_info(me4000_user_info_t *,
> +				me4000_info_t * board_info);
> +static int me4000_read_procmem(char *, char **, off_t, int, int *, void *);
> +
> +/*-----------------------------------------------------------------------------
> +  Analog output stuff
> +  ---------------------------------------------------------------------------*/
> +static ssize_t me4000_ao_write_sing(struct file *, const char *, size_t,
> +				    loff_t *);
> +static ssize_t me4000_ao_write_wrap(struct file *, const char *, size_t,
> +				    loff_t *);
> +static ssize_t me4000_ao_write_cont(struct file *, const char *, size_t,
> +				    loff_t *);
> +
> +static int me4000_ao_ioctl_sing(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> +static int me4000_ao_ioctl_wrap(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> +static int me4000_ao_ioctl_cont(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> +
> +static unsigned int me4000_ao_poll_cont(struct file *, poll_table *);
> +static int me4000_ao_fsync_cont(struct file *, struct dentry *, int);
> +
> +static int me4000_ao_start(unsigned long *, me4000_ao_context_t *);
> +static int me4000_ao_stop(me4000_ao_context_t *);
> +static int me4000_ao_immediate_stop(me4000_ao_context_t *);
> +static int me4000_ao_timer_set_divisor(u32 *, me4000_ao_context_t *);
> +static int me4000_ao_preload(me4000_ao_context_t *);
> +static int me4000_ao_preload_update(me4000_ao_context_t *);
> +static int me4000_ao_ex_trig_set_edge(int *, me4000_ao_context_t *);
> +static int me4000_ao_ex_trig_enable(me4000_ao_context_t *);
> +static int me4000_ao_ex_trig_disable(me4000_ao_context_t *);
> +static int me4000_ao_prepare(me4000_ao_context_t * ao_info);
> +static int me4000_ao_reset(me4000_ao_context_t * ao_info);
> +static int me4000_ao_enable_do(me4000_ao_context_t *);
> +static int me4000_ao_disable_do(me4000_ao_context_t *);
> +static int me4000_ao_fsm_state(int *, me4000_ao_context_t *);
> +
> +static int me4000_ao_simultaneous_ex_trig(me4000_ao_context_t * ao_context);
> +static int me4000_ao_simultaneous_sw(me4000_ao_context_t * ao_context);
> +static int me4000_ao_simultaneous_disable(me4000_ao_context_t * ao_context);
> +static int me4000_ao_simultaneous_update(me4000_ao_channel_list_t * channels,
> +					 me4000_ao_context_t * ao_context);
> +
> +static int me4000_ao_synchronous_ex_trig(me4000_ao_context_t * ao_context);
> +static int me4000_ao_synchronous_sw(me4000_ao_context_t * ao_context);
> +static int me4000_ao_synchronous_disable(me4000_ao_context_t * ao_context);
> +
> +static int me4000_ao_ex_trig_timeout(unsigned long *arg,
> +				     me4000_ao_context_t * ao_context);
> +static int me4000_ao_get_free_buffer(unsigned long *arg,
> +				     me4000_ao_context_t * ao_context);

probably lots of those too.

> +/*-----------------------------------------------------------------------------
> +  Analog input stuff
> +  ---------------------------------------------------------------------------*/
> +static int me4000_ai_single(me4000_ai_single_t *, me4000_ai_context_t *);
> +static int me4000_ai_ioctl_sing(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> +
> +static ssize_t me4000_ai_read(struct file *, char *, size_t, loff_t *);
> +static int me4000_ai_ioctl_sw(struct inode *, struct file *, unsigned int,
> +			      unsigned long);
> +static unsigned int me4000_ai_poll(struct file *, poll_table *);
> +static int me4000_ai_fasync(int fd, struct file *file_p, int mode);
> +
> +static int me4000_ai_ioctl_ext(struct inode *, struct file *, unsigned int,
> +			       unsigned long);
> +
> +static int me4000_ai_prepare(me4000_ai_context_t * ai_context);
> +static int me4000_ai_reset(me4000_ai_context_t * ai_context);
> +static int me4000_ai_config(me4000_ai_config_t *, me4000_ai_context_t *);
> +static int me4000_ai_start(me4000_ai_context_t *);
> +static int me4000_ai_start_ex(unsigned long *, me4000_ai_context_t *);
> +static int me4000_ai_stop(me4000_ai_context_t *);
> +static int me4000_ai_immediate_stop(me4000_ai_context_t *);
> +static int me4000_ai_ex_trig_enable(me4000_ai_context_t *);
> +static int me4000_ai_ex_trig_disable(me4000_ai_context_t *);
> +static int me4000_ai_ex_trig_setup(me4000_ai_trigger_t *,
> +				   me4000_ai_context_t *);
> +static int me4000_ai_sc_setup(me4000_ai_sc_t * arg,
> +			      me4000_ai_context_t * ai_context);
> +static int me4000_ai_offset_enable(me4000_ai_context_t * ai_context);
> +static int me4000_ai_offset_disable(me4000_ai_context_t * ai_context);
> +static int me4000_ai_fullscale_enable(me4000_ai_context_t * ai_context);
> +static int me4000_ai_fullscale_disable(me4000_ai_context_t * ai_context);
> +static int me4000_ai_fsm_state(int *arg, me4000_ai_context_t * ai_context);
> +static int me4000_ai_get_count_buffer(unsigned long *arg,
> +				      me4000_ai_context_t * ai_context);

blah

> +/*-----------------------------------------------------------------------------
> +  EEPROM stuff
> +  ---------------------------------------------------------------------------*/
> +static int me4000_eeprom_read(me4000_eeprom_t * arg,
> +			      me4000_ai_context_t * ai_context);
> +static int me4000_eeprom_write(me4000_eeprom_t * arg,
> +			       me4000_ai_context_t * ai_context);
> +static unsigned short eeprom_read_cmd(me4000_ai_context_t * ai_context,
> +				      unsigned long cmd, int length);
> +static int eeprom_write_cmd(me4000_ai_context_t * ai_context, unsigned long cmd,
> +			    int length);
> +
> +/*-----------------------------------------------------------------------------
> +  Digital I/O stuff
> +  ---------------------------------------------------------------------------*/
> +static int me4000_dio_ioctl(struct inode *, struct file *, unsigned int,
> +			    unsigned long);
> +static int me4000_dio_config(me4000_dio_config_t *, me4000_dio_context_t *);
> +static int me4000_dio_get_byte(me4000_dio_byte_t *, me4000_dio_context_t *);
> +static int me4000_dio_set_byte(me4000_dio_byte_t *, me4000_dio_context_t *);
> +static int me4000_dio_reset(me4000_dio_context_t *);
> +
> +/*-----------------------------------------------------------------------------
> +  Counter stuff
> +  ---------------------------------------------------------------------------*/
> +static int me4000_cnt_ioctl(struct inode *, struct file *, unsigned int,
> +			    unsigned long);
> +static int me4000_cnt_config(me4000_cnt_config_t *, me4000_cnt_context_t *);
> +static int me4000_cnt_read(me4000_cnt_t *, me4000_cnt_context_t *);
> +static int me4000_cnt_write(me4000_cnt_t *, me4000_cnt_context_t *);
> +static int me4000_cnt_reset(me4000_cnt_context_t *);
> +
> +/*-----------------------------------------------------------------------------
> +  External interrupt routines
> +  ---------------------------------------------------------------------------*/
> +static int me4000_ext_int_ioctl(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> +static int me4000_ext_int_enable(me4000_ext_int_context_t *);
> +static int me4000_ext_int_disable(me4000_ext_int_context_t *);
> +static int me4000_ext_int_count(unsigned long *arg,
> +				me4000_ext_int_context_t * ext_int_context);
> +static int me4000_ext_int_fasync(int fd, struct file *file_ptr, int mode);
> +
> +/*-----------------------------------------------------------------------------
> +  The interrupt service routines
> +  ---------------------------------------------------------------------------*/
> +static irqreturn_t me4000_ao_isr(int, void *);
> +static irqreturn_t me4000_ai_isr(int, void *);
> +static irqreturn_t me4000_ext_int_isr(int, void *);
> +
> +/*-----------------------------------------------------------------------------
> +  Inline functions
> +  ---------------------------------------------------------------------------*/
> +static int inline me4000_buf_count(me4000_circ_buf_t, int);
> +static int inline me4000_buf_space(me4000_circ_buf_t, int);
> +static int inline me4000_space_to_end(me4000_circ_buf_t, int);
> +static int inline me4000_values_to_end(me4000_circ_buf_t, int);
> +
> +static void inline me4000_outb(unsigned char value, unsigned long port);
> +static void inline me4000_outl(unsigned long value, unsigned long port);
> +static unsigned long inline me4000_inl(unsigned long port);
> +static unsigned char inline me4000_inb(unsigned long port);

wtf

> +static int me4000_buf_count(me4000_circ_buf_t buf, int size)
> +{
> +	return ((buf.head - buf.tail) & (size - 1));
> +}
> +
> +static int me4000_buf_space(me4000_circ_buf_t buf, int size)
> +{
> +	return ((buf.tail - (buf.head + 1)) & (size - 1));
> +}
>
> +static int me4000_values_to_end(me4000_circ_buf_t buf, int size)
> +{
> +	int end;
> +	int n;
> +	end = size - buf.tail;
> +	n = (buf.head + end) & (size - 1);
> +	return (n < end) ? n : end;
> +}
> +
> +static int me4000_space_to_end(me4000_circ_buf_t buf, int size)
> +{
> +	int end;
> +	int n;
> +
> +	end = size - 1 - buf.head;
> +	n = (end + buf.tail) & (size - 1);
> +	return (n <= end) ? n : (end + 1);
> +}

yet another home-made circular buffer implementation

rename all struct foo_t to struct foo

> +static void me4000_outb(unsigned char value, unsigned long port)
> +{
> +	PORT_PDEBUG("--> 0x%02X port 0x%04lX\n", value, port);
> +	outb(value, port);
> +}
> +
> +static void me4000_outl(unsigned long value, unsigned long port)
> +{
> +	PORT_PDEBUG("--> 0x%08lX port 0x%04lX\n", value, port);
> +	outl(value, port);
> +}
> +
> +static unsigned long me4000_inl(unsigned long port)
> +{
> +	unsigned long value;
> +	value = inl(port);
> +	PORT_PDEBUG("<-- 0x%08lX port 0x%04lX\n", value, port);
> +	return value;
> +}
> +
> +static unsigned char me4000_inb(unsigned long port)
> +{
> +	unsigned char value;
> +	value = inb(port);
> +	PORT_PDEBUG("<-- 0x%08X port 0x%04lX\n", value, port);
> +	return value;
> +}
> +
> +struct pci_driver me4000_driver = {
> +	.name = ME4000_NAME,
> +	.id_table = me4000_pci_table,
> +	.probe = me4000_probe
> +};
> +
> +static struct file_operations me4000_ao_fops_sing = {
> +      owner:THIS_MODULE,
> +      write:me4000_ao_write_sing,
> +      ioctl:me4000_ao_ioctl_sing,
> +      open:me4000_open,
> +      release:me4000_release,
> +};

	.foo = bar,

> +static struct file_operations me4000_ao_fops_wrap = {
> +      owner:THIS_MODULE,
> +      write:me4000_ao_write_wrap,
> +      ioctl:me4000_ao_ioctl_wrap,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_ao_fops_cont = {
> +      owner:THIS_MODULE,
> +      write:me4000_ao_write_cont,
> +      poll:me4000_ao_poll_cont,
> +      ioctl:me4000_ao_ioctl_cont,
> +      open:me4000_open,
> +      release:me4000_release,
> +      fsync:me4000_ao_fsync_cont,
> +};
> +
> +static struct file_operations me4000_ai_fops_sing = {
> +      owner:THIS_MODULE,
> +      ioctl:me4000_ai_ioctl_sing,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_ai_fops_cont_sw = {
> +      owner:THIS_MODULE,
> +      read:me4000_ai_read,
> +      poll:me4000_ai_poll,
> +      ioctl:me4000_ai_ioctl_sw,
> +      open:me4000_open,
> +      release:me4000_release,
> +      fasync:me4000_ai_fasync,
> +};
> +
> +static struct file_operations me4000_ai_fops_cont_et = {
> +      owner:THIS_MODULE,
> +      read:me4000_ai_read,
> +      poll:me4000_ai_poll,
> +      ioctl:me4000_ai_ioctl_ext,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_ai_fops_cont_et_value = {
> +      owner:THIS_MODULE,
> +      read:me4000_ai_read,
> +      poll:me4000_ai_poll,
> +      ioctl:me4000_ai_ioctl_ext,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_ai_fops_cont_et_chanlist = {
> +      owner:THIS_MODULE,
> +      read:me4000_ai_read,
> +      poll:me4000_ai_poll,
> +      ioctl:me4000_ai_ioctl_ext,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_dio_fops = {
> +      owner:THIS_MODULE,
> +      ioctl:me4000_dio_ioctl,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_cnt_fops = {
> +      owner:THIS_MODULE,
> +      ioctl:me4000_cnt_ioctl,
> +      open:me4000_open,
> +      release:me4000_release,
> +};
> +
> +static struct file_operations me4000_ext_int_fops = {
> +      owner:THIS_MODULE,
> +      ioctl:me4000_ext_int_ioctl,
> +      open:me4000_open,
> +      release:me4000_release,
> +      fasync:me4000_ext_int_fasync,
> +};

dittoes

> +static struct file_operations *me4000_ao_fops_array[] = {
> +	&me4000_ao_fops_sing,	// single operations
> +	&me4000_ao_fops_wrap,	// wraparound operations
> +	&me4000_ao_fops_cont,	// continous operations
> +};
> +
> +static struct file_operations *me4000_ai_fops_array[] = {
> +	&me4000_ai_fops_sing,	// single operations
> +	&me4000_ai_fops_cont_sw,	// continuous operations with software start
> +	&me4000_ai_fops_cont_et,	// continous operations with external trigger
> +	&me4000_ai_fops_cont_et_value,	// sample values by external trigger
> +	&me4000_ai_fops_cont_et_chanlist,	// work through one channel list by external trigger
> +};

ditto

> +int __init me4000_init_module(void)

static

> +{
> +	int result = 0;

unneeded initialisation

> +	CALL_PDEBUG("init_module() is executed\n");
> +
> +	/* Register driver capabilities */
> +	result = pci_register_driver(&me4000_driver);
> +	PDEBUG("init_module():%d devices detected\n", result);
> +	if (result < 0) {
> +		printk(KERN_ERR "ME4000:init_module():Can't register driver\n");
> +		goto INIT_ERROR_1;
> +	}
> +
> +	/* Allocate major number for analog output */
> +	result =
> +	    register_chrdev(me4000_ao_major_driver_no, ME4000_AO_NAME,
> +			    &me4000_ao_fops_sing);
> +	if (result < 0) {
> +		printk(KERN_ERR "ME4000:init_module():Can't get AO major no\n");
> +		goto INIT_ERROR_2;
> +	} else {
> +		me4000_ao_major_driver_no = result;
> +	}
> +	PDEBUG("init_module():Major driver number for AO = %ld\n",
> +	       me4000_ao_major_driver_no);
> +
> +	/* Allocate major number for analog input  */
> +	result =
> +	    register_chrdev(me4000_ai_major_driver_no, ME4000_AI_NAME,
> +			    &me4000_ai_fops_sing);
> +	if (result < 0) {
> +		printk(KERN_ERR "ME4000:init_module():Can't get AI major no\n");
> +		goto INIT_ERROR_3;
> +	} else {
> +		me4000_ai_major_driver_no = result;
> +	}
> +	PDEBUG("init_module():Major driver number for AI = %ld\n",
> +	       me4000_ai_major_driver_no);
> +
> +	/* Allocate major number for digital I/O */
> +	result =
> +	    register_chrdev(me4000_dio_major_driver_no, ME4000_DIO_NAME,
> +			    &me4000_dio_fops);
> +	if (result < 0) {
> +		printk(KERN_ERR
> +		       "ME4000:init_module():Can't get DIO major no\n");
> +		goto INIT_ERROR_4;
> +	} else {
> +		me4000_dio_major_driver_no = result;
> +	}
> +	PDEBUG("init_module():Major driver number for DIO = %ld\n",
> +	       me4000_dio_major_driver_no);
> +
> +	/* Allocate major number for counter */
> +	result =
> +	    register_chrdev(me4000_cnt_major_driver_no, ME4000_CNT_NAME,
> +			    &me4000_cnt_fops);
> +	if (result < 0) {
> +		printk(KERN_ERR
> +		       "ME4000:init_module():Can't get CNT major no\n");
> +		goto INIT_ERROR_5;
> +	} else {
> +		me4000_cnt_major_driver_no = result;
> +	}
> +	PDEBUG("init_module():Major driver number for CNT = %ld\n",
> +	       me4000_cnt_major_driver_no);
> +
> +	/* Allocate major number for external interrupt */
> +	result =
> +	    register_chrdev(me4000_ext_int_major_driver_no, ME4000_EXT_INT_NAME,
> +			    &me4000_ext_int_fops);
> +	if (result < 0) {
> +		printk(KERN_ERR
> +		       "ME4000:init_module():Can't get major no for external interrupt\n");
> +		goto INIT_ERROR_6;
> +	} else {
> +		me4000_ext_int_major_driver_no = result;
> +	}
> +	PDEBUG

Yet another home-made prdebug?

> +	    ("init_module():Major driver number for external interrupt = %ld\n",
> +	     me4000_ext_int_major_driver_no);
> +
> +	/* Create the /proc/me4000 entry */
> +	if (!create_proc_read_entry
> +	    ("me4000", 0, NULL, me4000_read_procmem, NULL)) {
> +		result = -ENODEV;
> +		printk(KERN_ERR
> +		       "ME4000:init_module():Can't create proc entry\n");
> +		goto INIT_ERROR_7;
> +	}
> +
> +	return 0;
> +
> +      INIT_ERROR_7:

crazy label indenting

> +	unregister_chrdev(me4000_ext_int_major_driver_no, ME4000_EXT_INT_NAME);
> +
> +      INIT_ERROR_6:
> +	unregister_chrdev(me4000_cnt_major_driver_no, ME4000_CNT_NAME);
> +
> +      INIT_ERROR_5:
> +	unregister_chrdev(me4000_dio_major_driver_no, ME4000_DIO_NAME);
> +
> +      INIT_ERROR_4:
> +	unregister_chrdev(me4000_ai_major_driver_no, ME4000_AI_NAME);
> +
> +      INIT_ERROR_3:
> +	unregister_chrdev(me4000_ao_major_driver_no, ME4000_AO_NAME);
> +
> +      INIT_ERROR_2:
> +	pci_unregister_driver(&me4000_driver);
> +	clear_board_info_list();
> +
> +      INIT_ERROR_1:
> +	return result;
> +}
> +
> +module_init(me4000_init_module);
> +
> +static void clear_board_info_list(void)
> +{
> +	struct list_head *board_p;
> +	struct list_head *dac_p;
> +	me4000_info_t *board_info;
> +	me4000_ao_context_t *ao_context;
> +
> +	/* Clear context lists */
> +	for (board_p = me4000_board_info_list.next;
> +	     board_p != &me4000_board_info_list; board_p = board_p->next) {
> +		board_info = list_entry(board_p, me4000_info_t, list);
> +		/* Clear analog output context list */
> +		while (!list_empty(&board_info->ao_context_list)) {
> +			dac_p = board_info->ao_context_list.next;
> +			ao_context =
> +			    list_entry(dac_p, me4000_ao_context_t, list);
> +			me4000_ao_reset(ao_context);
> +			free_irq(ao_context->irq, ao_context);
> +			if (ao_context->circ_buf.buf)
> +				kfree(ao_context->circ_buf.buf);
> +			list_del(dac_p);
> +			kfree(ao_context);
> +		}
> +
> +		/* Clear analog input context */
> +		if (board_info->ai_context->circ_buf.buf)
> +			kfree(board_info->ai_context->circ_buf.buf);
> +		kfree(board_info->ai_context);
> +
> +		/* Clear digital I/O context */
> +		kfree(board_info->dio_context);
> +
> +		/* Clear counter context */
> +		kfree(board_info->cnt_context);
> +
> +		/* Clear external interrupt context */
> +		kfree(board_info->ext_int_context);
> +	}
> +
> +	/* Clear the board info list */
> +	while (!list_empty(&me4000_board_info_list)) {
> +		board_p = me4000_board_info_list.next;
> +		board_info = list_entry(board_p, me4000_info_t, list);
> +		pci_release_regions(board_info->pci_dev_p);
> +		list_del(board_p);
> +		kfree(board_info);
> +	}
> +}

locking for me4000_board_info_list

> +static int get_registers(struct pci_dev *dev, me4000_info_t * board_info)
> +{
> +
> +	/*--------------------------- plx regbase ---------------------------------*/
> +
> +	board_info->plx_regbase = pci_resource_start(dev, 1);
> +	if (board_info->plx_regbase == 0) {
> +		printk(KERN_ERR
> +		       "ME4000:get_registers():PCI base address 1 is not available\n");
> +		return -ENODEV;
> +	}
> +	board_info->plx_regbase_size = pci_resource_len(dev, 1);
> +
> +	PDEBUG
> +	    ("get_registers():PLX configuration registers at address 0x%4lX [0x%4lX]\n",
> +	     board_info->plx_regbase, board_info->plx_regbase_size);
> +
> +	/*--------------------------- me4000 regbase ------------------------------*/
> +
> +	board_info->me4000_regbase = pci_resource_start(dev, 2);
> +	if (board_info->me4000_regbase == 0) {
> +		printk(KERN_ERR
> +		       "ME4000:get_registers():PCI base address 2 is not available\n");
> +		return -ENODEV;
> +	}
> +	board_info->me4000_regbase_size = pci_resource_len(dev, 2);

me4000_regbase and me4000_regbase_size should become resource_size_t.

> +	PDEBUG("get_registers():ME4000 registers at address 0x%4lX [0x%4lX]\n",
> +	       board_info->me4000_regbase, board_info->me4000_regbase_size);

> +	/*--------------------------- timer regbase ------------------------------*/
> +
> +	board_info->timer_regbase = pci_resource_start(dev, 3);
> +	if (board_info->timer_regbase == 0) {
> +		printk(KERN_ERR
> +		       "ME4000:get_registers():PCI base address 3 is not available\n");
> +		return -ENODEV;
> +	}
> +	board_info->timer_regbase_size = pci_resource_len(dev, 3);
> +
> +	PDEBUG("get_registers():Timer registers at address 0x%4lX [0x%4lX]\n",
> +	       board_info->timer_regbase, board_info->timer_regbase_size);
> +
> +	/*--------------------------- program regbase ------------------------------*/
> +
> +	board_info->program_regbase = pci_resource_start(dev, 5);
> +	if (board_info->program_regbase == 0) {
> +		printk(KERN_ERR
> +		       "get_registers():ME4000:PCI base address 5 is not available\n");
> +		return -ENODEV;
> +	}
> +	board_info->program_regbase_size = pci_resource_len(dev, 5);
> +
> +	PDEBUG("get_registers():Program registers at address 0x%4lX [0x%4lX]\n",
> +	       board_info->program_regbase, board_info->program_regbase_size);

dittoes

> +	return 0;
> +}
> +
> +static int init_board_info(struct pci_dev *pci_dev_p,
> +			   me4000_info_t * board_info)
> +{
> +	int i;
> +	int result;
> +	struct list_head *board_p;
> +	board_info->pci_dev_p = pci_dev_p;
> +
> +	for (i = 0; i < ME4000_BOARD_VERSIONS; i++) {
> +		if (me4000_boards[i].device_id == pci_dev_p->device) {
> +			board_info->board_p = &me4000_boards[i];
> +			break;
> +		}
> +	}
> +	if (i == ME4000_BOARD_VERSIONS) {
> +		printk(KERN_ERR
> +		       "ME4000:init_board_info():Device ID not valid\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Get the index of the board in the global list */
> +	for (board_p = me4000_board_info_list.next, i = 0;
> +	     board_p != &me4000_board_info_list; board_p = board_p->next, i++) {
> +		if (board_p == &board_info->list) {
> +			board_info->board_count = i;
> +			break;
> +		}
> +	}
> +	if (board_p == &me4000_board_info_list) {
> +		printk(KERN_ERR
> +		       "ME4000:init_board_info():Cannot get index of baord\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Init list head for analog output contexts */
> +	INIT_LIST_HEAD(&board_info->ao_context_list);
> +
> +	/* Init spin locks */
> +	spin_lock_init(&board_info->preload_lock);
> +	spin_lock_init(&board_info->ai_ctrl_lock);
> +
> +	/* Get the serial number */
> +	result = pci_read_config_dword(pci_dev_p, 0x2C, &board_info->serial_no);
> +	if (result != PCIBIOS_SUCCESSFUL) {
> +		printk(KERN_WARNING
> +		       "ME4000:init_board_info: Can't get serial_no\n");
> +		return result;
> +	}
> +	PDEBUG("init_board_info():serial_no = 0x%x\n", board_info->serial_no);
> +
> +	/* Get the hardware revision */
> +	result =
> +	    pci_read_config_byte(pci_dev_p, 0x08, &board_info->hw_revision);
> +	if (result != PCIBIOS_SUCCESSFUL) {
> +		printk(KERN_WARNING
> +		       "ME4000:init_board_info():Can't get hw_revision\n");
> +		return result;
> +	}
> +	PDEBUG("init_board_info():hw_revision = 0x%x\n",
> +	       board_info->hw_revision);
> +
> +	/* Get the vendor id */
> +	board_info->vendor_id = pci_dev_p->vendor;
> +	PDEBUG("init_board_info():vendor_id = 0x%x\n", board_info->vendor_id);
> +
> +	/* Get the device id */
> +	board_info->device_id = pci_dev_p->device;
> +	PDEBUG("init_board_info():device_id = 0x%x\n", board_info->device_id);
> +
> +	/* Get the pci device number */
> +	board_info->pci_dev_no = PCI_FUNC(pci_dev_p->devfn);
> +	PDEBUG("init_board_info():pci_func_no = 0x%x\n",
> +	       board_info->pci_func_no);
> +
> +	/* Get the pci slot number */
> +	board_info->pci_dev_no = PCI_SLOT(pci_dev_p->devfn);
> +	PDEBUG("init_board_info():pci_dev_no = 0x%x\n", board_info->pci_dev_no);
> +
> +	/* Get the pci bus number */
> +	board_info->pci_bus_no = pci_dev_p->bus->number;
> +	PDEBUG("init_board_info():pci_bus_no = 0x%x\n", board_info->pci_bus_no);
> +
> +	/* Get the irq assigned to the board */
> +	board_info->irq = pci_dev_p->irq;
> +	PDEBUG("init_board_info():irq = %d\n", board_info->irq);
> +
> +	return 0;
> +}
> +
> +static int alloc_ao_contexts(me4000_info_t * info)
> +{
> +	int i;
> +	int err;
> +	me4000_ao_context_t *ao_context;
> +
> +	for (i = 0; i < info->board_p->ao.count; i++) {
> +		ao_context = kmalloc(sizeof(me4000_ao_context_t), GFP_KERNEL);
> +		if (!ao_context) {
> +			printk(KERN_ERR
> +			       "alloc_ao_contexts():Can't get memory for ao context\n");
> +			release_ao_contexts(info);
> +			return -ENOMEM;
> +		}
> +		memset(ao_context, 0, sizeof(me4000_ao_context_t));

kzalloc

> +		spin_lock_init(&ao_context->use_lock);
> +		spin_lock_init(&ao_context->int_lock);
> +		ao_context->irq = info->irq;
> +		init_waitqueue_head(&ao_context->wait_queue);
> +		ao_context->board_info = info;
> +
> +		if (info->board_p->ao.fifo_count) {
> +			/* Allocate circular buffer */
> +			ao_context->circ_buf.buf =
> +			    kmalloc(ME4000_AO_BUFFER_SIZE, GFP_KERNEL);
> +			if (!ao_context->circ_buf.buf) {
> +				printk(KERN_ERR
> +				       "alloc_ao_contexts():Can't get circular buffer\n");
> +				release_ao_contexts(info);
> +				return -ENOMEM;
> +			}
> +			memset(ao_context->circ_buf.buf, 0,
> +			       ME4000_AO_BUFFER_SIZE);

kzalloc

> +			/* Clear the circular buffer */
> +			ao_context->circ_buf.head = 0;
> +			ao_context->circ_buf.tail = 0;
> +		}
> +
> +		switch (i) {
> +		case 0:
> +			ao_context->ctrl_reg =
> +			    info->me4000_regbase + ME4000_AO_00_CTRL_REG;
> +			ao_context->status_reg =
> +			    info->me4000_regbase + ME4000_AO_00_STATUS_REG;
> +			ao_context->fifo_reg =
> +			    info->me4000_regbase + ME4000_AO_00_FIFO_REG;
> +			ao_context->single_reg =
> +			    info->me4000_regbase + ME4000_AO_00_SINGLE_REG;
> +			ao_context->timer_reg =
> +			    info->me4000_regbase + ME4000_AO_00_TIMER_REG;
> +			ao_context->irq_status_reg =
> +			    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +			ao_context->preload_reg =
> +			    info->me4000_regbase + ME4000_AO_LOADSETREG_XX;
> +			break;
> +		case 1:
> +			ao_context->ctrl_reg =
> +			    info->me4000_regbase + ME4000_AO_01_CTRL_REG;
> +			ao_context->status_reg =
> +			    info->me4000_regbase + ME4000_AO_01_STATUS_REG;
> +			ao_context->fifo_reg =
> +			    info->me4000_regbase + ME4000_AO_01_FIFO_REG;
> +			ao_context->single_reg =
> +			    info->me4000_regbase + ME4000_AO_01_SINGLE_REG;
> +			ao_context->timer_reg =
> +			    info->me4000_regbase + ME4000_AO_01_TIMER_REG;
> +			ao_context->irq_status_reg =
> +			    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +			ao_context->preload_reg =
> +			    info->me4000_regbase + ME4000_AO_LOADSETREG_XX;
> +			break;
> +		case 2:
> +			ao_context->ctrl_reg =
> +			    info->me4000_regbase + ME4000_AO_02_CTRL_REG;
> +			ao_context->status_reg =
> +			    info->me4000_regbase + ME4000_AO_02_STATUS_REG;
> +			ao_context->fifo_reg =
> +			    info->me4000_regbase + ME4000_AO_02_FIFO_REG;
> +			ao_context->single_reg =
> +			    info->me4000_regbase + ME4000_AO_02_SINGLE_REG;
> +			ao_context->timer_reg =
> +			    info->me4000_regbase + ME4000_AO_02_TIMER_REG;
> +			ao_context->irq_status_reg =
> +			    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +			ao_context->preload_reg =
> +			    info->me4000_regbase + ME4000_AO_LOADSETREG_XX;
> +			break;
> +		case 3:
> +			ao_context->ctrl_reg =
> +			    info->me4000_regbase + ME4000_AO_03_CTRL_REG;
> +			ao_context->status_reg =
> +			    info->me4000_regbase + ME4000_AO_03_STATUS_REG;
> +			ao_context->fifo_reg =
> +			    info->me4000_regbase + ME4000_AO_03_FIFO_REG;
> +			ao_context->single_reg =
> +			    info->me4000_regbase + ME4000_AO_03_SINGLE_REG;
> +			ao_context->timer_reg =
> +			    info->me4000_regbase + ME4000_AO_03_TIMER_REG;
> +			ao_context->irq_status_reg =
> +			    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +			ao_context->preload_reg =
> +			    info->me4000_regbase + ME4000_AO_LOADSETREG_XX;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (info->board_p->ao.fifo_count) {
> +			/* Request the interrupt line */
> +			err =
> +			    request_irq(ao_context->irq, me4000_ao_isr,
> +					IRQF_DISABLED | IRQF_SHARED,
> +					ME4000_NAME, ao_context);
> +			if (err) {
> +				printk(KERN_ERR
> +				       "alloc_ao_contexts():Can't get interrupt line");

__func__(?)

> +				if (ao_context->circ_buf.buf)
> +					kfree(ao_context->circ_buf.buf);

kfree(NULL) is legal

> +				kfree(ao_context);
> +				release_ao_contexts(info);
> +				return -ENODEV;
> +			}
> +		}
> +
> +		list_add_tail(&ao_context->list, &info->ao_context_list);
> +		ao_context->index = i;
> +	}
> +
> +	return 0;
> +}
> +
> +static void release_ao_contexts(me4000_info_t * board_info)
> +{
> +	struct list_head *dac_p;
> +	me4000_ao_context_t *ao_context;
> +
> +	/* Clear analog output context list */
> +	while (!list_empty(&board_info->ao_context_list)) {
> +		dac_p = board_info->ao_context_list.next;
> +		ao_context = list_entry(dac_p, me4000_ao_context_t, list);
> +		free_irq(ao_context->irq, ao_context);
> +		if (ao_context->circ_buf.buf)
> +			kfree(ao_context->circ_buf.buf);

etc

> +		list_del(dac_p);
> +		kfree(ao_context);
> +	}
> +}
> +
> +static int alloc_ai_context(me4000_info_t * info)
> +{
> +	me4000_ai_context_t *ai_context;
> +
> +	if (info->board_p->ai.count) {
> +		ai_context = kmalloc(sizeof(me4000_ai_context_t), GFP_KERNEL);
> +		if (!ai_context) {
> +			printk(KERN_ERR
> +			       "ME4000:alloc_ai_context():Can't get memory for ai context\n");
> +			return -ENOMEM;
> +		}
> +		memset(ai_context, 0, sizeof(me4000_ai_context_t));

kzalloc()

> +		info->ai_context = ai_context;
> +
> +		spin_lock_init(&ai_context->use_lock);
> +		spin_lock_init(&ai_context->int_lock);
> +		ai_context->number = 0;
> +		ai_context->irq = info->irq;
> +		init_waitqueue_head(&ai_context->wait_queue);
> +		ai_context->board_info = info;
> +
> +		ai_context->ctrl_reg =
> +		    info->me4000_regbase + ME4000_AI_CTRL_REG;
> +		ai_context->status_reg =
> +		    info->me4000_regbase + ME4000_AI_STATUS_REG;
> +		ai_context->channel_list_reg =
> +		    info->me4000_regbase + ME4000_AI_CHANNEL_LIST_REG;
> +		ai_context->data_reg =
> +		    info->me4000_regbase + ME4000_AI_DATA_REG;
> +		ai_context->chan_timer_reg =
> +		    info->me4000_regbase + ME4000_AI_CHAN_TIMER_REG;
> +		ai_context->chan_pre_timer_reg =
> +		    info->me4000_regbase + ME4000_AI_CHAN_PRE_TIMER_REG;
> +		ai_context->scan_timer_low_reg =
> +		    info->me4000_regbase + ME4000_AI_SCAN_TIMER_LOW_REG;
> +		ai_context->scan_timer_high_reg =
> +		    info->me4000_regbase + ME4000_AI_SCAN_TIMER_HIGH_REG;
> +		ai_context->scan_pre_timer_low_reg =
> +		    info->me4000_regbase + ME4000_AI_SCAN_PRE_TIMER_LOW_REG;
> +		ai_context->scan_pre_timer_high_reg =
> +		    info->me4000_regbase + ME4000_AI_SCAN_PRE_TIMER_HIGH_REG;
> +		ai_context->start_reg =
> +		    info->me4000_regbase + ME4000_AI_START_REG;
> +		ai_context->irq_status_reg =
> +		    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +		ai_context->sample_counter_reg =
> +		    info->me4000_regbase + ME4000_AI_SAMPLE_COUNTER_REG;
> +	}
> +
> +	return 0;
> +}
> +
> +static int alloc_dio_context(me4000_info_t * info)
> +{
> +	me4000_dio_context_t *dio_context;
> +
> +	if (info->board_p->dio.count) {
> +		dio_context = kmalloc(sizeof(me4000_dio_context_t), GFP_KERNEL);
> +		if (!dio_context) {
> +			printk(KERN_ERR
> +			       "ME4000:alloc_dio_context():Can't get memory for dio context\n");
> +			return -ENOMEM;
> +		}
> +		memset(dio_context, 0, sizeof(me4000_dio_context_t));

etc

> +		info->dio_context = dio_context;
> +
> +		spin_lock_init(&dio_context->use_lock);
> +		dio_context->board_info = info;
> +
> +		dio_context->dio_count = info->board_p->dio.count;
> +
> +		dio_context->dir_reg =
> +		    info->me4000_regbase + ME4000_DIO_DIR_REG;
> +		dio_context->ctrl_reg =
> +		    info->me4000_regbase + ME4000_DIO_CTRL_REG;
> +		dio_context->port_0_reg =
> +		    info->me4000_regbase + ME4000_DIO_PORT_0_REG;
> +		dio_context->port_1_reg =
> +		    info->me4000_regbase + ME4000_DIO_PORT_1_REG;
> +		dio_context->port_2_reg =
> +		    info->me4000_regbase + ME4000_DIO_PORT_2_REG;
> +		dio_context->port_3_reg =
> +		    info->me4000_regbase + ME4000_DIO_PORT_3_REG;
> +	}
> +
> +	return 0;
> +}
> +
> +static int alloc_cnt_context(me4000_info_t * info)
> +{
> +	me4000_cnt_context_t *cnt_context;
> +
> +	if (info->board_p->cnt.count) {
> +		cnt_context = kmalloc(sizeof(me4000_cnt_context_t), GFP_KERNEL);
> +		if (!cnt_context) {
> +			printk(KERN_ERR
> +			       "ME4000:alloc_cnt_context():Can't get memory for cnt context\n");
> +			return -ENOMEM;
> +		}
> +		memset(cnt_context, 0, sizeof(me4000_cnt_context_t));

etc

> +		info->cnt_context = cnt_context;
> +
> +		spin_lock_init(&cnt_context->use_lock);
> +		cnt_context->board_info = info;
> +
> +		cnt_context->ctrl_reg =
> +		    info->timer_regbase + ME4000_CNT_CTRL_REG;
> +		cnt_context->counter_0_reg =
> +		    info->timer_regbase + ME4000_CNT_COUNTER_0_REG;
> +		cnt_context->counter_1_reg =
> +		    info->timer_regbase + ME4000_CNT_COUNTER_1_REG;
> +		cnt_context->counter_2_reg =
> +		    info->timer_regbase + ME4000_CNT_COUNTER_2_REG;
> +	}
> +
> +	return 0;
> +}
> +
> +static int alloc_ext_int_context(me4000_info_t * info)
> +{
> +	me4000_ext_int_context_t *ext_int_context;
> +
> +	if (info->board_p->cnt.count) {
> +		ext_int_context =
> +		    kmalloc(sizeof(me4000_ext_int_context_t), GFP_KERNEL);
> +		if (!ext_int_context) {
> +			printk(KERN_ERR
> +			       "ME4000:alloc_ext_int_context():Can't get memory for cnt context\n");
> +			return -ENOMEM;
> +		}
> +		memset(ext_int_context, 0, sizeof(me4000_ext_int_context_t));

ho hum

> +		info->ext_int_context = ext_int_context;
> +
> +		spin_lock_init(&ext_int_context->use_lock);
> +		ext_int_context->board_info = info;
> +
> +		ext_int_context->fasync_ptr = NULL;
> +		ext_int_context->irq = info->irq;
> +
> +		ext_int_context->ctrl_reg =
> +		    info->me4000_regbase + ME4000_AI_CTRL_REG;
> +		ext_int_context->irq_status_reg =
> +		    info->me4000_regbase + ME4000_IRQ_STATUS_REG;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	int result = 0;
> +	me4000_info_t *board_info;
> +
> +	CALL_PDEBUG("me4000_probe() is executed\n");
> +
> +	/* Allocate structure for board context */
> +	board_info = kmalloc(sizeof(me4000_info_t), GFP_KERNEL);
> +	if (!board_info) {
> +		printk(KERN_ERR
> +		       "ME4000:Can't get memory for board info structure\n");
> +		result = -ENOMEM;
> +		goto PROBE_ERROR_1;
> +	}
> +	memset(board_info, 0, sizeof(me4000_info_t));
> +
> +	/* Add to global linked list */
> +	list_add_tail(&board_info->list, &me4000_board_info_list);
> +
> +	/* Get the PCI base registers */
> +	result = get_registers(dev, board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot get registers\n");
> +		goto PROBE_ERROR_2;
> +	}
> +
> +	/* Enable the device */
> +	result = pci_enable_device(dev);
> +	if (result < 0) {
> +		printk(KERN_ERR "me4000_probe():Cannot enable PCI device\n");
> +		goto PROBE_ERROR_2;
> +	}
> +
> +	/* Request the PCI register regions */
> +	result = pci_request_regions(dev, ME4000_NAME);
> +	if (result < 0) {
> +		printk(KERN_ERR "me4000_probe():Cannot request I/O regions\n");
> +		goto PROBE_ERROR_2;
> +	}
> +
> +	/* Initialize board info */
> +	result = init_board_info(dev, board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot init baord info\n");
> +		goto PROBE_ERROR_3;
> +	}
> +
> +	/* Download the xilinx firmware */
> +	result = me4000_xilinx_download(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe:Can't download firmware\n");
> +		goto PROBE_ERROR_3;
> +	}
> +
> +	/* Make a hardware reset */
> +	result = me4000_reset_board(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe:Can't reset board\n");
> +		goto PROBE_ERROR_3;
> +	}
> +
> +	/* Allocate analog output context structures */
> +	result = alloc_ao_contexts(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot allocate ao contexts\n");
> +		goto PROBE_ERROR_3;
> +	}
> +
> +	/* Allocate analog input context */
> +	result = alloc_ai_context(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot allocate ai context\n");
> +		goto PROBE_ERROR_4;
> +	}
> +
> +	/* Allocate digital I/O context */
> +	result = alloc_dio_context(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot allocate dio context\n");
> +		goto PROBE_ERROR_5;
> +	}
> +
> +	/* Allocate counter context */
> +	result = alloc_cnt_context(board_info);
> +	if (result) {
> +		printk(KERN_ERR "me4000_probe():Cannot allocate cnt context\n");
> +		goto PROBE_ERROR_6;
> +	}
> +
> +	/* Allocate external interrupt context */
> +	result = alloc_ext_int_context(board_info);
> +	if (result) {
> +		printk(KERN_ERR
> +		       "me4000_probe():Cannot allocate ext_int context\n");
> +		goto PROBE_ERROR_7;
> +	}

__func__

> +	return 0;
> +
> +      PROBE_ERROR_7:

indent

> +	kfree(board_info->cnt_context);
> +
> +      PROBE_ERROR_6:
> +	kfree(board_info->dio_context);
> +
> +      PROBE_ERROR_5:
> +	kfree(board_info->ai_context);
> +
> +      PROBE_ERROR_4:
> +	release_ao_contexts(board_info);
> +
> +      PROBE_ERROR_3:
> +	pci_release_regions(dev);
> +
> +      PROBE_ERROR_2:
> +	list_del(&board_info->list);
> +	kfree(board_info);
> +
> +      PROBE_ERROR_1:
> +	return result;
> +}
> +
> +static int me4000_xilinx_download(me4000_info_t * info)
> +{
> +	int size = 0;
> +	u32 value = 0;
> +	int idx = 0;
> +	unsigned char *firm;
> +	wait_queue_head_t queue;

this doesn't do anything

> +
> +	CALL_PDEBUG("me4000_xilinx_download() is executed\n");
> +
> +	init_waitqueue_head(&queue);
> +
> +	firm = (info->device_id == 0x4610) ? xilinx_firm_4610 : xilinx_firm;
> +
> +	/*
> +	 * Set PLX local interrupt 2 polarity to high.
> +	 * Interrupt is thrown by init pin of xilinx.
> +	 */
> +	outl(0x10, info->plx_regbase + PLX_INTCSR);
> +
> +	/* Set /CS and /WRITE of the Xilinx */
> +	value = inl(info->plx_regbase + PLX_ICR);
> +	value |= 0x100;
> +	outl(value, info->plx_regbase + PLX_ICR);
> +
> +	/* Init Xilinx with CS1 */
> +	inb(info->program_regbase + 0xC8);
> +
> +	/* Wait until /INIT pin is set */
> +	udelay(20);
> +	if (!inl(info->plx_regbase + PLX_INTCSR) & 0x20) {
> +		printk(KERN_ERR "me4000_xilinx_download():Can't init Xilinx\n");
> +		return -EIO;
> +	}
> +
> +	/* Reset /CS and /WRITE of the Xilinx */
> +	value = inl(info->plx_regbase + PLX_ICR);
> +	value &= ~0x100;
> +	outl(value, info->plx_regbase + PLX_ICR);
> +
> +	/* Download Xilinx firmware */
> +	size = (firm[0] << 24) + (firm[1] << 16) + (firm[2] << 8) + firm[3];
> +	udelay(10);
> +
> +	for (idx = 0; idx < size; idx++) {
> +		outb(firm[16 + idx], info->program_regbase);
> +
> +		udelay(10);
> +
> +		/* Check if BUSY flag is low */
> +		if (inl(info->plx_regbase + PLX_ICR) & 0x20) {
> +			printk(KERN_ERR
> +			       "me4000_xilinx_download():Xilinx is still busy (idx = %d)\n",
> +			       idx);
> +			return -EIO;
> +		}
> +	}
> +
> +	PDEBUG("me4000_xilinx_download():%d bytes written\n", idx);
> +
> +	/* If done flag is high download was successful */
> +	if (inl(info->plx_regbase + PLX_ICR) & 0x4) {
> +		PDEBUG("me4000_xilinx_download():Done flag is set\n");
> +		PDEBUG("me4000_xilinx_download():Download was successful\n");
> +	} else {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_xilinx_download():DONE flag is not set\n");
> +		printk(KERN_ERR
> +		       "ME4000:me4000_xilinx_download():Download not succesful\n");
> +		return -EIO;
> +	}
> +
> +	/* Set /CS and /WRITE */
> +	value = inl(info->plx_regbase + PLX_ICR);
> +	value |= 0x100;
> +	outl(value, info->plx_regbase + PLX_ICR);
> +
> +	return 0;
> +}
> +
> +static int me4000_reset_board(me4000_info_t * info)
> +{
> +	unsigned long icr;
> +
> +	CALL_PDEBUG("me4000_reset_board() is executed\n");
> +
> +	/* Make a hardware reset */
> +	icr = me4000_inl(info->plx_regbase + PLX_ICR);
> +	icr |= 0x40000000;
> +	me4000_outl(icr, info->plx_regbase + PLX_ICR);
> +	icr &= ~0x40000000;
> +	me4000_outl(icr, info->plx_regbase + PLX_ICR);
> +
> +	/* Set both stop bits in the analog input control register */
> +	me4000_outl(ME4000_AI_CTRL_BIT_IMMEDIATE_STOP | ME4000_AI_CTRL_BIT_STOP,
> +		    info->me4000_regbase + ME4000_AI_CTRL_REG);
> +
> +	/* Set both stop bits in the analog output control register */
> +	me4000_outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
> +		    info->me4000_regbase + ME4000_AO_00_CTRL_REG);
> +	me4000_outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
> +		    info->me4000_regbase + ME4000_AO_01_CTRL_REG);
> +	me4000_outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
> +		    info->me4000_regbase + ME4000_AO_02_CTRL_REG);
> +	me4000_outl(ME4000_AO_CTRL_BIT_IMMEDIATE_STOP | ME4000_AO_CTRL_BIT_STOP,
> +		    info->me4000_regbase + ME4000_AO_03_CTRL_REG);
> +
> +	/* 0x8000 to the DACs means an output voltage of 0V */
> +	me4000_outl(0x8000, info->me4000_regbase + ME4000_AO_00_SINGLE_REG);
> +	me4000_outl(0x8000, info->me4000_regbase + ME4000_AO_01_SINGLE_REG);
> +	me4000_outl(0x8000, info->me4000_regbase + ME4000_AO_02_SINGLE_REG);
> +	me4000_outl(0x8000, info->me4000_regbase + ME4000_AO_03_SINGLE_REG);
> +
> +	/* Enable interrupts on the PLX */
> +	me4000_outl(0x43, info->plx_regbase + PLX_INTCSR);
> +
> +	/* Set the adustment register for AO demux */
> +	me4000_outl(ME4000_AO_DEMUX_ADJUST_VALUE,
> +		    info->me4000_regbase + ME4000_AO_DEMUX_ADJUST_REG);
> +
> +	/* Set digital I/O direction for port 0 to output on isolated versions */
> +	if (!(me4000_inl(info->me4000_regbase + ME4000_DIO_DIR_REG) & 0x1)) {
> +		me4000_outl(0x1, info->me4000_regbase + ME4000_DIO_CTRL_REG);
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_open(struct inode *inode_p, struct file *file_p)
> +{
> +	int board, dev, mode;
> +	int err = 0;
> +	int i;
> +	struct list_head *ptr;
> +	me4000_info_t *board_info = NULL;
> +	me4000_ao_context_t *ao_context = NULL;
> +	me4000_ai_context_t *ai_context = NULL;
> +	me4000_dio_context_t *dio_context = NULL;
> +	me4000_cnt_context_t *cnt_context = NULL;
> +	me4000_ext_int_context_t *ext_int_context = NULL;
> +
> +	CALL_PDEBUG("me4000_open() is executed\n");
> +
> +	/* Analog output */
> +	if (MAJOR(inode_p->i_rdev) == me4000_ao_major_driver_no) {
> +		board = AO_BOARD(inode_p->i_rdev);
> +		dev = AO_PORT(inode_p->i_rdev);
> +		mode = AO_MODE(inode_p->i_rdev);
> +
> +		PDEBUG("me4000_open():board = %d ao = %d mode = %d\n", board,
> +		       dev, mode);
> +
> +		/* Search for the board context */
> +		for (ptr = me4000_board_info_list.next, i = 0;
> +		     ptr != &me4000_board_info_list; ptr = ptr->next, i++) {
> +			board_info = list_entry(ptr, me4000_info_t, list);
> +			if (i == board)
> +				break;
> +		}
> +
> +		if (ptr == &me4000_board_info_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Board %d not in device list\n",
> +			       board);
> +			return -ENODEV;
> +		}
> +
> +		/* Search for the dac context */
> +		for (ptr = board_info->ao_context_list.next, i = 0;
> +		     ptr != &board_info->ao_context_list;
> +		     ptr = ptr->next, i++) {
> +			ao_context = list_entry(ptr, me4000_ao_context_t, list);
> +			if (i == dev)
> +				break;
> +		}
> +
> +		if (ptr == &board_info->ao_context_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Device %d not in device list\n",
> +			       dev);
> +			return -ENODEV;
> +		}
> +
> +		/* Check if mode is valid */
> +		if (mode > 2) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Mode is not valid\n");
> +			return -ENODEV;
> +		}
> +
> +		/* Check if mode is valid for this AO */
> +		if ((mode != ME4000_AO_CONV_MODE_SINGLE)
> +		    && (dev >= board_info->board_p->ao.fifo_count)) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():AO %d only in single mode available\n",
> +			       dev);
> +			return -ENODEV;
> +		}
> +
> +		/* Check if already opened */
> +		spin_lock(&ao_context->use_lock);
> +		if (ao_context->dac_in_use) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():AO %d already in use\n",
> +			       dev);
> +			spin_unlock(&ao_context->use_lock);
> +			return -EBUSY;
> +		}
> +		ao_context->dac_in_use = 1;
> +		spin_unlock(&ao_context->use_lock);
> +
> +		ao_context->mode = mode;
> +
> +		/* Hold the context in private data */
> +		file_p->private_data = ao_context;
> +
> +		/* Set file operations pointer */
> +		file_p->f_op = me4000_ao_fops_array[mode];
> +
> +		err = me4000_ao_prepare(ao_context);
> +		if (err) {
> +			ao_context->dac_in_use = 0;
> +			return 1;
> +		}
> +	}
> +	/* Analog input */
> +	else if (MAJOR(inode_p->i_rdev) == me4000_ai_major_driver_no) {
> +		board = AI_BOARD(inode_p->i_rdev);
> +		mode = AI_MODE(inode_p->i_rdev);
> +
> +		PDEBUG("me4000_open():ai board = %d mode = %d\n", board, mode);
> +
> +		/* Search for the board context */
> +		for (ptr = me4000_board_info_list.next, i = 0;
> +		     ptr != &me4000_board_info_list; ptr = ptr->next, i++) {
> +			board_info = list_entry(ptr, me4000_info_t, list);
> +			if (i == board)
> +				break;
> +		}
> +
> +		if (ptr == &me4000_board_info_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Board %d not in device list\n",
> +			       board);
> +			return -ENODEV;
> +		}
> +
> +		ai_context = board_info->ai_context;
> +
> +		/* Check if mode is valid */
> +		if (mode > 5) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Mode is not valid\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Check if already opened */
> +		spin_lock(&ai_context->use_lock);
> +		if (ai_context->in_use) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():AI already in use\n");
> +			spin_unlock(&ai_context->use_lock);
> +			return -EBUSY;
> +		}
> +		ai_context->in_use = 1;
> +		spin_unlock(&ai_context->use_lock);
> +
> +		ai_context->mode = mode;
> +
> +		/* Hold the context in private data */
> +		file_p->private_data = ai_context;
> +
> +		/* Set file operations pointer */
> +		file_p->f_op = me4000_ai_fops_array[mode];
> +
> +		/* Prepare analog input */
> +		me4000_ai_prepare(ai_context);
> +	}
> +	/* Digital I/O */
> +	else if (MAJOR(inode_p->i_rdev) == me4000_dio_major_driver_no) {
> +		board = DIO_BOARD(inode_p->i_rdev);
> +		dev = 0;
> +		mode = 0;
> +
> +		PDEBUG("me4000_open():board = %d\n", board);
> +
> +		/* Search for the board context */
> +		for (ptr = me4000_board_info_list.next;
> +		     ptr != &me4000_board_info_list; ptr = ptr->next) {
> +			board_info = list_entry(ptr, me4000_info_t, list);
> +			if (board_info->board_count == board)
> +				break;
> +		}
> +
> +		if (ptr == &me4000_board_info_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Board %d not in device list\n",
> +			       board);
> +			return -ENODEV;
> +		}
> +
> +		/* Search for the dio context */
> +		dio_context = board_info->dio_context;
> +
> +		/* Check if already opened */
> +		spin_lock(&dio_context->use_lock);
> +		if (dio_context->in_use) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():DIO already in use\n");
> +			spin_unlock(&dio_context->use_lock);
> +			return -EBUSY;
> +		}
> +		dio_context->in_use = 1;
> +		spin_unlock(&dio_context->use_lock);
> +
> +		/* Hold the context in private data */
> +		file_p->private_data = dio_context;
> +
> +		/* Set file operations pointer to single functions */
> +		file_p->f_op = &me4000_dio_fops;
> +
> +		//me4000_dio_reset(dio_context);
> +	}
> +	/* Counters */
> +	else if (MAJOR(inode_p->i_rdev) == me4000_cnt_major_driver_no) {
> +		board = CNT_BOARD(inode_p->i_rdev);
> +		dev = 0;
> +		mode = 0;
> +
> +		PDEBUG("me4000_open():board = %d\n", board);
> +
> +		/* Search for the board context */
> +		for (ptr = me4000_board_info_list.next;
> +		     ptr != &me4000_board_info_list; ptr = ptr->next) {
> +			board_info = list_entry(ptr, me4000_info_t, list);
> +			if (board_info->board_count == board)
> +				break;
> +		}
> +
> +		if (ptr == &me4000_board_info_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Board %d not in device list\n",
> +			       board);
> +			return -ENODEV;
> +		}
> +
> +		/* Get the cnt context */
> +		cnt_context = board_info->cnt_context;
> +
> +		/* Check if already opened */
> +		spin_lock(&cnt_context->use_lock);
> +		if (cnt_context->in_use) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():CNT already in use\n");
> +			spin_unlock(&cnt_context->use_lock);
> +			return -EBUSY;
> +		}
> +		cnt_context->in_use = 1;
> +		spin_unlock(&cnt_context->use_lock);
> +
> +		/* Hold the context in private data */
> +		file_p->private_data = cnt_context;
> +
> +		/* Set file operations pointer to single functions */
> +		file_p->f_op = &me4000_cnt_fops;
> +	}
> +	/* External Interrupt */
> +	else if (MAJOR(inode_p->i_rdev) == me4000_ext_int_major_driver_no) {
> +		board = EXT_INT_BOARD(inode_p->i_rdev);
> +		dev = 0;
> +		mode = 0;
> +
> +		PDEBUG("me4000_open():board = %d\n", board);
> +
> +		/* Search for the board context */
> +		for (ptr = me4000_board_info_list.next;
> +		     ptr != &me4000_board_info_list; ptr = ptr->next) {
> +			board_info = list_entry(ptr, me4000_info_t, list);
> +			if (board_info->board_count == board)
> +				break;
> +		}
> +
> +		if (ptr == &me4000_board_info_list) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Board %d not in device list\n",
> +			       board);
> +			return -ENODEV;
> +		}
> +
> +		/* Get the external interrupt context */
> +		ext_int_context = board_info->ext_int_context;
> +
> +		/* Check if already opened */
> +		spin_lock(&cnt_context->use_lock);
> +		if (ext_int_context->in_use) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():External interrupt already in use\n");
> +			spin_unlock(&ext_int_context->use_lock);
> +			return -EBUSY;
> +		}
> +		ext_int_context->in_use = 1;
> +		spin_unlock(&ext_int_context->use_lock);
> +
> +		/* Hold the context in private data */
> +		file_p->private_data = ext_int_context;
> +
> +		/* Set file operations pointer to single functions */
> +		file_p->f_op = &me4000_ext_int_fops;
> +
> +		/* Request the interrupt line */
> +		err =
> +		    request_irq(ext_int_context->irq, me4000_ext_int_isr,
> +				IRQF_DISABLED | IRQF_SHARED, ME4000_NAME,
> +				ext_int_context);
> +		if (err) {
> +			printk(KERN_ERR
> +			       "ME4000:me4000_open():Can't get interrupt line");
> +			ext_int_context->in_use = 0;
> +			return -ENODEV;
> +		}
> +
> +		/* Reset the counter */
> +		me4000_ext_int_disable(ext_int_context);
> +	} else {
> +		printk(KERN_ERR "ME4000:me4000_open():Major number unknown\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_release(struct inode *inode_p, struct file *file_p)
> +{
> +	me4000_ao_context_t *ao_context;
> +	me4000_ai_context_t *ai_context;
> +	me4000_dio_context_t *dio_context;
> +	me4000_cnt_context_t *cnt_context;
> +	me4000_ext_int_context_t *ext_int_context;
> +
> +	CALL_PDEBUG("me4000_release() is executed\n");
> +
> +	if (MAJOR(inode_p->i_rdev) == me4000_ao_major_driver_no) {
> +		ao_context = file_p->private_data;
> +
> +		/* Mark DAC as unused */
> +		ao_context->dac_in_use = 0;
> +	} else if (MAJOR(inode_p->i_rdev) == me4000_ai_major_driver_no) {
> +		ai_context = file_p->private_data;
> +
> +		/* Reset the analog input */
> +		me4000_ai_reset(ai_context);
> +
> +		/* Free the interrupt and the circular buffer */
> +		if (ai_context->mode) {
> +			free_irq(ai_context->irq, ai_context);
> +			kfree(ai_context->circ_buf.buf);
> +			ai_context->circ_buf.buf = NULL;
> +			ai_context->circ_buf.head = 0;
> +			ai_context->circ_buf.tail = 0;
> +		}
> +
> +		/* Mark AI as unused */
> +		ai_context->in_use = 0;
> +	} else if (MAJOR(inode_p->i_rdev) == me4000_dio_major_driver_no) {
> +		dio_context = file_p->private_data;
> +
> +		/* Mark digital I/O as unused */
> +		dio_context->in_use = 0;
> +	} else if (MAJOR(inode_p->i_rdev) == me4000_cnt_major_driver_no) {
> +		cnt_context = file_p->private_data;
> +
> +		/* Mark counters as unused */
> +		cnt_context->in_use = 0;
> +	} else if (MAJOR(inode_p->i_rdev) == me4000_ext_int_major_driver_no) {
> +		ext_int_context = file_p->private_data;
> +
> +		/* Disable the externel interrupt */
> +		me4000_ext_int_disable(ext_int_context);
> +
> +		free_irq(ext_int_context->irq, ext_int_context);
> +
> +		/* Delete the fasync structure and free memory */
> +		me4000_ext_int_fasync(0, file_p, 0);
> +
> +		/* Mark as unused */
> +		ext_int_context->in_use = 0;
> +	} else {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_release():Major number unknown\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*------------------------------- Analog output stuff --------------------------------------*/
> +
> +static int me4000_ao_prepare(me4000_ao_context_t * ao_context)
> +{
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_prepare() is executed\n");
> +
> +	if (ao_context->mode == ME4000_AO_CONV_MODE_CONTINUOUS) {
> +		/* Only do anything if not already in the correct mode */
> +		unsigned long mode = me4000_inl(ao_context->ctrl_reg);
> +		if ((mode & ME4000_AO_CONV_MODE_CONTINUOUS)
> +		    && (mode & ME4000_AO_CTRL_BIT_ENABLE_FIFO)) {
> +			return 0;
> +		}
> +
> +		/* Stop any conversion */
> +		me4000_ao_immediate_stop(ao_context);
> +
> +		/* Set the control register to default state  */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		me4000_outl(ME4000_AO_CONV_MODE_CONTINUOUS |
> +			    ME4000_AO_CTRL_BIT_ENABLE_FIFO |
> +			    ME4000_AO_CTRL_BIT_STOP |
> +			    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP,
> +			    ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +		/* Set to fastest sample rate */
> +		me4000_outl(65, ao_context->timer_reg);
> +	} else if (ao_context->mode == ME4000_AO_CONV_MODE_WRAPAROUND) {
> +		/* Only do anything if not already in the correct mode */
> +		unsigned long mode = me4000_inl(ao_context->ctrl_reg);
> +		if ((mode & ME4000_AO_CONV_MODE_WRAPAROUND)
> +		    && (mode & ME4000_AO_CTRL_BIT_ENABLE_FIFO)) {
> +			return 0;
> +		}
> +
> +		/* Stop any conversion */
> +		me4000_ao_immediate_stop(ao_context);
> +
> +		/* Set the control register to default state  */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		me4000_outl(ME4000_AO_CONV_MODE_WRAPAROUND |
> +			    ME4000_AO_CTRL_BIT_ENABLE_FIFO |
> +			    ME4000_AO_CTRL_BIT_STOP |
> +			    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP,
> +			    ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +		/* Set to fastest sample rate */
> +		me4000_outl(65, ao_context->timer_reg);
> +	} else if (ao_context->mode == ME4000_AO_CONV_MODE_SINGLE) {
> +		/* Only do anything if not already in the correct mode */
> +		unsigned long mode = me4000_inl(ao_context->ctrl_reg);
> +		if (!
> +		    (mode &
> +		     (ME4000_AO_CONV_MODE_WRAPAROUND |
> +		      ME4000_AO_CONV_MODE_CONTINUOUS))) {
> +			return 0;
> +		}
> +
> +		/* Stop any conversion */
> +		me4000_ao_immediate_stop(ao_context);
> +
> +		/* Clear the control register */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		me4000_outl(0x0, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +		/* Set voltage to 0V */
> +		me4000_outl(0x8000, ao_context->single_reg);
> +	} else {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_prepare():Invalid mode specified\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_reset(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	wait_queue_head_t queue;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_reset() is executed\n");
> +
> +	init_waitqueue_head(&queue);
> +
> +	if (ao_context->mode == ME4000_AO_CONV_MODE_WRAPAROUND) {
> +		/*
> +		 * First stop conversion of the DAC before reconfigure.
> +		 * This is essantial, cause of the state machine.
> +		 * If not stopped before configuring mode, it could
> +		 * walk in a undefined state.
> +		 */
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp |= ME4000_AO_CTRL_BIT_IMMEDIATE_STOP;
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +
> +		while (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +			sleep_on_timeout(&queue, 1);

whee

> +		}
> +
> +		/* Set to transparent mode */
> +		me4000_ao_simultaneous_disable(ao_context);
> +
> +		/* Set to single mode in order to set default voltage */
> +		me4000_outl(0x0, ao_context->ctrl_reg);
> +
> +		/* Set voltage to 0V */
> +		me4000_outl(0x8000, ao_context->single_reg);
> +
> +		/* Set to fastest sample rate */
> +		me4000_outl(65, ao_context->timer_reg);
> +
> +		/* Set the original mode and enable FIFO */
> +		me4000_outl(ME4000_AO_CONV_MODE_WRAPAROUND |
> +			    ME4000_AO_CTRL_BIT_ENABLE_FIFO |
> +			    ME4000_AO_CTRL_BIT_STOP |
> +			    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP,
> +			    ao_context->ctrl_reg);
> +	} else if (ao_context->mode == ME4000_AO_CONV_MODE_CONTINUOUS) {
> +		/*
> +		 * First stop conversion of the DAC before reconfigure.
> +		 * This is essantial, cause of the state machine.
> +		 * If not stopped before configuring mode, it could
> +		 * walk in a undefined state.
> +		 */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp |= ME4000_AO_CTRL_BIT_STOP;
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +		while (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +			sleep_on_timeout(&queue, 1);
> +		}
> +
> +		/* Clear the circular buffer */
> +		ao_context->circ_buf.head = 0;
> +		ao_context->circ_buf.tail = 0;
> +
> +		/* Set to transparent mode */
> +		me4000_ao_simultaneous_disable(ao_context);
> +
> +		/* Set to single mode in order to set default voltage */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		me4000_outl(0x0, ao_context->ctrl_reg);
> +
> +		/* Set voltage to 0V */
> +		me4000_outl(0x8000, ao_context->single_reg);
> +
> +		/* Set to fastest sample rate */
> +		me4000_outl(65, ao_context->timer_reg);
> +
> +		/* Set the original mode and enable FIFO */
> +		me4000_outl(ME4000_AO_CONV_MODE_CONTINUOUS |
> +			    ME4000_AO_CTRL_BIT_ENABLE_FIFO |
> +			    ME4000_AO_CTRL_BIT_STOP |
> +			    ME4000_AO_CTRL_BIT_IMMEDIATE_STOP,
> +			    ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +	} else {
> +		/* Set to transparent mode */
> +		me4000_ao_simultaneous_disable(ao_context);
> +
> +		/* Set voltage to 0V */
> +		me4000_outl(0x8000, ao_context->single_reg);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t me4000_ao_write_sing(struct file *filep, const char *buff,
> +				    size_t cnt, loff_t * offp)
> +{
> +	me4000_ao_context_t *ao_context = filep->private_data;
> +	u32 value;
> +	const u16 *buffer = (const u16 *)buff;
> +
> +	CALL_PDEBUG("me4000_ao_write_sing() is executed\n");
> +
> +	if (cnt != 2) {
> +		printk(KERN_ERR
> +		       "me4000_ao_write_sing():Write count is not 2\n");
> +		return -EINVAL;
> +	}
> +
> +	if (get_user(value, buffer)) {

eh?

> +		printk(KERN_ERR
> +		       "me4000_ao_write_sing():Cannot copy data from user\n");
> +		return -EFAULT;
> +	}
> +
> +	me4000_outl(value, ao_context->single_reg);
> +
> +	return 2;
> +}
> +
> +static ssize_t me4000_ao_write_wrap(struct file *filep, const char *buff,
> +				    size_t cnt, loff_t * offp)
> +{
> +	me4000_ao_context_t *ao_context = filep->private_data;
> +	size_t i;
> +	u32 value;
> +	u32 tmp;
> +	const u16 *buffer = (const u16 *)buff;
> +	size_t count = cnt / 2;
> +
> +	CALL_PDEBUG("me4000_ao_write_wrap() is executed\n");
> +
> +	/* Check if a conversion is already running */
> +	if (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_write_wrap():There is already a conversion running\n");
> +		return -EBUSY;
> +	}
> +
> +	if (count > ME4000_AO_FIFO_COUNT) {
> +		printk(KERN_ERR
> +		       "me4000_ao_write_wrap():Can't load more than %d values\n",
> +		       ME4000_AO_FIFO_COUNT);
> +		return -ENOSPC;
> +	}
> +
> +	/* Reset the FIFO */
> +	tmp = inl(ao_context->ctrl_reg);
> +	tmp &= ~ME4000_AO_CTRL_BIT_ENABLE_FIFO;
> +	outl(tmp, ao_context->ctrl_reg);
> +	tmp |= ME4000_AO_CTRL_BIT_ENABLE_FIFO;
> +	outl(tmp, ao_context->ctrl_reg);
> +
> +	for (i = 0; i < count; i++) {
> +		if (get_user(value, buffer + i)) {
> +			printk(KERN_ERR
> +			       "me4000_ao_write_single():Cannot copy data from user\n");
> +			return -EFAULT;
> +		}
> +		if (((ao_context->fifo_reg & 0xFF) == ME4000_AO_01_FIFO_REG)
> +		    || ((ao_context->fifo_reg & 0xFF) == ME4000_AO_03_FIFO_REG))
> +			value = value << 16;
> +		outl(value, ao_context->fifo_reg);
> +	}
> +	CALL_PDEBUG("me4000_ao_write_wrap() is leaved with %d\n", i * 2);
> +
> +	return i * 2;
> +}
> +
> +static ssize_t me4000_ao_write_cont(struct file *filep, const char *buff,
> +				    size_t cnt, loff_t * offp)
> +{
> +	me4000_ao_context_t *ao_context = filep->private_data;
> +	const u16 *buffer = (const u16 *)buff;
> +	size_t count = cnt / 2;
> +	unsigned long flags;
> +	u32 tmp;
> +	int c = 0;
> +	int k = 0;
> +	int ret = 0;
> +	u16 svalue;
> +	u32 lvalue;
> +	int i;
> +	wait_queue_head_t queue;
> +
> +	CALL_PDEBUG("me4000_ao_write_cont() is executed\n");
> +
> +	init_waitqueue_head(&queue);
> +
> +	/* Check count */
> +	if (count <= 0) {
> +		PDEBUG("me4000_ao_write_cont():Count is 0\n");
> +		return 0;
> +	}
> +
> +	if (filep->f_flags & O_APPEND) {
> +		PDEBUG("me4000_ao_write_cont():Append data to data stream\n");
> +		while (count > 0) {
> +			if (filep->f_flags & O_NONBLOCK) {
> +				if (ao_context->pipe_flag) {
> +					printk(KERN_ERR
> +					       "ME4000:me4000_ao_write_cont():Broken pipe in nonblocking write\n");
> +					return -EPIPE;
> +				}
> +				c = me4000_space_to_end(ao_context->circ_buf,
> +							ME4000_AO_BUFFER_COUNT);
> +				if (!c) {
> +					PDEBUG
> +					    ("me4000_ao_write_cont():Returning from nonblocking write\n");
> +					break;
> +				}
> +			} else {
> +				wait_event_interruptible(ao_context->wait_queue,
> +							 (c =
> +							  me4000_space_to_end
> +							  (ao_context->circ_buf,
> +							   ME4000_AO_BUFFER_COUNT)));
> +				if (ao_context->pipe_flag) {
> +					printk(KERN_ERR
> +					       "me4000_ao_write_cont():Broken pipe in blocking write\n");
> +					return -EPIPE;
> +				}
> +				if (signal_pending(current)) {
> +					printk(KERN_ERR
> +					       "me4000_ao_write_cont():Wait for free buffer interrupted from signal\n");
> +					return -EINTR;
> +				}
> +			}
> +
> +			PDEBUG("me4000_ao_write_cont():Space to end = %d\n", c);
> +
> +			/* Only able to write size of free buffer or size of count */
> +			if (count < c)
> +				c = count;
> +
> +			k = 2 * c;
> +			k -= copy_from_user(ao_context->circ_buf.buf +
> +					    ao_context->circ_buf.head, buffer,
> +					    k);
> +			c = k / 2;
> +			PDEBUG
> +			    ("me4000_ao_write_cont():Copy %d values from user space\n",
> +			     c);
> +
> +			if (!c)
> +				return -EFAULT;
> +
> +			ao_context->circ_buf.head =
> +			    (ao_context->circ_buf.head +
> +			     c) & (ME4000_AO_BUFFER_COUNT - 1);
> +			buffer += c;
> +			count -= c;
> +			ret += c;
> +
> +			/* Values are now available so enable interrupts */
> +			spin_lock_irqsave(&ao_context->int_lock, flags);
> +			if (me4000_buf_count
> +			    (ao_context->circ_buf, ME4000_AO_BUFFER_COUNT)) {
> +				tmp = me4000_inl(ao_context->ctrl_reg);
> +				tmp |= ME4000_AO_CTRL_BIT_ENABLE_IRQ;
> +				me4000_outl(tmp, ao_context->ctrl_reg);
> +			}
> +			spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +		}
> +
> +		/* Wait until the state machine is stopped if O_SYNC is set */
> +		if (filep->f_flags & O_SYNC) {
> +			while (inl(ao_context->status_reg) &
> +			       ME4000_AO_STATUS_BIT_FSM) {
> +				interruptible_sleep_on_timeout(&queue, 1);
> +				if (ao_context->pipe_flag) {
> +					PDEBUG
> +					    ("me4000_ao_write_cont():Broken pipe detected after sync\n");
> +					return -EPIPE;
> +				}
> +				if (signal_pending(current)) {
> +					printk(KERN_ERR
> +					       "me4000_ao_write_cont():Wait on state machine after sync interrupted\n");
> +					return -EINTR;
> +				}
> +			}
> +		}
> +	} else {
> +		PDEBUG("me4000_ao_write_cont():Preload DAC FIFO\n");
> +		if ((me4000_inl(ao_context->status_reg) &
> +		     ME4000_AO_STATUS_BIT_FSM)) {
> +			printk(KERN_ERR
> +			       "me4000_ao_write_cont():Can't Preload DAC FIFO while conversion is running\n");
> +			return -EBUSY;
> +		}
> +
> +		/* Clear the FIFO */
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp &=
> +		    ~(ME4000_AO_CTRL_BIT_ENABLE_FIFO |
> +		      ME4000_AO_CTRL_BIT_ENABLE_IRQ);
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		tmp |= ME4000_AO_CTRL_BIT_ENABLE_FIFO;
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +		/* Clear the circular buffer */
> +		ao_context->circ_buf.head = 0;
> +		ao_context->circ_buf.tail = 0;
> +
> +		/* Reset the broken pipe flag */
> +		ao_context->pipe_flag = 0;
> +
> +		/* Only able to write size of fifo or count */
> +		c = ME4000_AO_FIFO_COUNT;
> +		if (count < c)
> +			c = count;
> +
> +		PDEBUG
> +		    ("me4000_ao_write_cont():Write %d values to DAC on 0x%lX\n",
> +		     c, ao_context->fifo_reg);
> +
> +		/* Write values to the fifo */
> +		for (i = 0; i < c; i++) {
> +			if (get_user(svalue, buffer))
> +				return -EFAULT;
> +
> +			if (((ao_context->fifo_reg & 0xFF) ==
> +			     ME4000_AO_01_FIFO_REG)
> +			    || ((ao_context->fifo_reg & 0xFF) ==
> +				ME4000_AO_03_FIFO_REG)) {
> +				lvalue = ((u32) svalue) << 16;
> +			} else
> +				lvalue = (u32) svalue;
> +
> +			outl(lvalue, ao_context->fifo_reg);
> +			buffer++;
> +		}
> +		count -= c;
> +		ret += c;
> +
> +		while (1) {
> +			/* Get free buffer */
> +			c = me4000_space_to_end(ao_context->circ_buf,
> +						ME4000_AO_BUFFER_COUNT);
> +
> +			if (c == 0)
> +				return (2 * ret);
> +
> +			/* Only able to write size of free buffer or size of count */
> +			if (count < c)
> +				c = count;
> +
> +			/* If count = 0 return to user */
> +			if (c <= 0) {
> +				PDEBUG
> +				    ("me4000_ao_write_cont():Count reached 0\n");
> +				break;
> +			}
> +
> +			k = 2 * c;
> +			k -= copy_from_user(ao_context->circ_buf.buf +
> +					    ao_context->circ_buf.head, buffer,
> +					    k);
> +			c = k / 2;
> +			PDEBUG
> +			    ("me4000_ao_write_cont():Wrote %d values to buffer\n",
> +			     c);
> +
> +			if (!c)
> +				return -EFAULT;
> +
> +			ao_context->circ_buf.head =
> +			    (ao_context->circ_buf.head +
> +			     c) & (ME4000_AO_BUFFER_COUNT - 1);
> +			buffer += c;
> +			count -= c;
> +			ret += c;
> +
> +			/* If values in the buffer are available so enable interrupts */
> +			spin_lock_irqsave(&ao_context->int_lock, flags);
> +			if (me4000_buf_count
> +			    (ao_context->circ_buf, ME4000_AO_BUFFER_COUNT)) {
> +				PDEBUG
> +				    ("me4000_ao_write_cont():Enable Interrupts\n");
> +				tmp = me4000_inl(ao_context->ctrl_reg);
> +				tmp |= ME4000_AO_CTRL_BIT_ENABLE_IRQ;
> +				me4000_outl(tmp, ao_context->ctrl_reg);
> +			}
> +			spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +		}
> +	}
> +
> +	if (filep->f_flags & O_NONBLOCK) {
> +		return (ret == 0) ? -EAGAIN : 2 * ret;
> +	}
> +
> +	return 2 * ret;
> +}
> +
> +static unsigned int me4000_ao_poll_cont(struct file *file_p, poll_table * wait)
> +{
> +	me4000_ao_context_t *ao_context;
> +	unsigned long mask = 0;
> +
> +	CALL_PDEBUG("me4000_ao_poll_cont() is executed\n");
> +
> +	ao_context = file_p->private_data;
> +
> +	poll_wait(file_p, &ao_context->wait_queue, wait);
> +
> +	/* Get free buffer */
> +	if (me4000_space_to_end(ao_context->circ_buf, ME4000_AO_BUFFER_COUNT))
> +		mask |= POLLOUT | POLLWRNORM;
> +
> +	CALL_PDEBUG("me4000_ao_poll_cont():Return mask %lX\n", mask);
> +
> +	return mask;
> +}
> +
> +static int me4000_ao_fsync_cont(struct file *file_p, struct dentry *dentry_p,
> +				int datasync)
> +{
> +	me4000_ao_context_t *ao_context;
> +	wait_queue_head_t queue;
> +
> +	CALL_PDEBUG("me4000_ao_fsync_cont() is executed\n");
> +
> +	ao_context = file_p->private_data;
> +	init_waitqueue_head(&queue);
> +
> +	while (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +		interruptible_sleep_on_timeout(&queue, 1);

remove all sleep_on()s

> +		if (ao_context->pipe_flag) {
> +			printk(KERN_ERR
> +			       "me4000_ao_fsync_cont():Broken pipe detected\n");
> +			return -EPIPE;
> +		}
> +
> +		if (signal_pending(current)) {
> +			printk(KERN_ERR
> +			       "me4000_ao_fsync_cont():Wait on state machine interrupted\n");
> +			return -EINTR;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ioctl_sing(struct inode *inode_p, struct file *file_p,
> +				unsigned int service, unsigned long arg)
> +{
> +	me4000_ao_context_t *ao_context;
> +
> +	CALL_PDEBUG("me4000_ao_ioctl_sing() is executed\n");
> +
> +	ao_context = file_p->private_data;
> +
> +	if (_IOC_TYPE(service) != ME4000_MAGIC) {
> +		return -ENOTTY;
> +		PDEBUG("me4000_ao_ioctl_sing():Wrong magic number\n");
> +	}
> +
> +	switch (service) {
> +	case ME4000_AO_EX_TRIG_SETUP:
> +		return me4000_ao_ex_trig_set_edge((int *)arg, ao_context);
> +	case ME4000_AO_EX_TRIG_ENABLE:
> +		return me4000_ao_ex_trig_enable(ao_context);
> +	case ME4000_AO_EX_TRIG_DISABLE:
> +		return me4000_ao_ex_trig_disable(ao_context);
> +	case ME4000_AO_PRELOAD:
> +		return me4000_ao_preload(ao_context);
> +	case ME4000_AO_PRELOAD_UPDATE:
> +		return me4000_ao_preload_update(ao_context);
> +	case ME4000_GET_USER_INFO:
> +		return me4000_get_user_info((me4000_user_info_t *) arg,
> +					    ao_context->board_info);
> +	case ME4000_AO_SIMULTANEOUS_EX_TRIG:
> +		return me4000_ao_simultaneous_ex_trig(ao_context);
> +	case ME4000_AO_SIMULTANEOUS_SW:
> +		return me4000_ao_simultaneous_sw(ao_context);
> +	case ME4000_AO_SIMULTANEOUS_DISABLE:
> +		return me4000_ao_simultaneous_disable(ao_context);
> +	case ME4000_AO_SIMULTANEOUS_UPDATE:
> +		return
> +		    me4000_ao_simultaneous_update((me4000_ao_channel_list_t *)
> +						  arg, ao_context);
> +	case ME4000_AO_EX_TRIG_TIMEOUT:
> +		return me4000_ao_ex_trig_timeout((unsigned long *)arg,
> +						 ao_context);
> +	case ME4000_AO_DISABLE_DO:
> +		return me4000_ao_disable_do(ao_context);
> +	default:
> +		printk(KERN_ERR
> +		       "me4000_ao_ioctl_sing():Service number invalid\n");
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ioctl_wrap(struct inode *inode_p, struct file *file_p,
> +				unsigned int service, unsigned long arg)
> +{
> +	me4000_ao_context_t *ao_context;
> +
> +	CALL_PDEBUG("me4000_ao_ioctl_wrap() is executed\n");
> +
> +	ao_context = file_p->private_data;
> +
> +	if (_IOC_TYPE(service) != ME4000_MAGIC) {
> +		return -ENOTTY;
> +		PDEBUG("me4000_ao_ioctl_wrap():Wrong magic number\n");
> +	}
> +
> +	switch (service) {
> +	case ME4000_AO_START:
> +		return me4000_ao_start((unsigned long *)arg, ao_context);
> +	case ME4000_AO_STOP:
> +		return me4000_ao_stop(ao_context);
> +	case ME4000_AO_IMMEDIATE_STOP:
> +		return me4000_ao_immediate_stop(ao_context);
> +	case ME4000_AO_RESET:
> +		return me4000_ao_reset(ao_context);
> +	case ME4000_AO_TIMER_SET_DIVISOR:
> +		return me4000_ao_timer_set_divisor((u32 *) arg, ao_context);
> +	case ME4000_AO_EX_TRIG_SETUP:
> +		return me4000_ao_ex_trig_set_edge((int *)arg, ao_context);
> +	case ME4000_AO_EX_TRIG_ENABLE:
> +		return me4000_ao_ex_trig_enable(ao_context);
> +	case ME4000_AO_EX_TRIG_DISABLE:
> +		return me4000_ao_ex_trig_disable(ao_context);
> +	case ME4000_GET_USER_INFO:
> +		return me4000_get_user_info((me4000_user_info_t *) arg,
> +					    ao_context->board_info);
> +	case ME4000_AO_FSM_STATE:
> +		return me4000_ao_fsm_state((int *)arg, ao_context);
> +	case ME4000_AO_ENABLE_DO:
> +		return me4000_ao_enable_do(ao_context);
> +	case ME4000_AO_DISABLE_DO:
> +		return me4000_ao_disable_do(ao_context);
> +	case ME4000_AO_SYNCHRONOUS_EX_TRIG:
> +		return me4000_ao_synchronous_ex_trig(ao_context);
> +	case ME4000_AO_SYNCHRONOUS_SW:
> +		return me4000_ao_synchronous_sw(ao_context);
> +	case ME4000_AO_SYNCHRONOUS_DISABLE:
> +		return me4000_ao_synchronous_disable(ao_context);
> +	default:
> +		return -ENOTTY;
> +	}
> +	return 0;
> +}
> +
> +static int me4000_ao_ioctl_cont(struct inode *inode_p, struct file *file_p,
> +				unsigned int service, unsigned long arg)
> +{
> +	me4000_ao_context_t *ao_context;
> +
> +	CALL_PDEBUG("me4000_ao_ioctl_cont() is executed\n");
> +
> +	ao_context = file_p->private_data;
> +
> +	if (_IOC_TYPE(service) != ME4000_MAGIC) {
> +		return -ENOTTY;
> +		PDEBUG("me4000_ao_ioctl_cont():Wrong magic number\n");
> +	}
> +
> +	switch (service) {
> +	case ME4000_AO_START:
> +		return me4000_ao_start((unsigned long *)arg, ao_context);
> +	case ME4000_AO_STOP:
> +		return me4000_ao_stop(ao_context);
> +	case ME4000_AO_IMMEDIATE_STOP:
> +		return me4000_ao_immediate_stop(ao_context);
> +	case ME4000_AO_RESET:
> +		return me4000_ao_reset(ao_context);
> +	case ME4000_AO_TIMER_SET_DIVISOR:
> +		return me4000_ao_timer_set_divisor((u32 *) arg, ao_context);
> +	case ME4000_AO_EX_TRIG_SETUP:
> +		return me4000_ao_ex_trig_set_edge((int *)arg, ao_context);
> +	case ME4000_AO_EX_TRIG_ENABLE:
> +		return me4000_ao_ex_trig_enable(ao_context);
> +	case ME4000_AO_EX_TRIG_DISABLE:
> +		return me4000_ao_ex_trig_disable(ao_context);
> +	case ME4000_AO_ENABLE_DO:
> +		return me4000_ao_enable_do(ao_context);
> +	case ME4000_AO_DISABLE_DO:
> +		return me4000_ao_disable_do(ao_context);
> +	case ME4000_AO_FSM_STATE:
> +		return me4000_ao_fsm_state((int *)arg, ao_context);
> +	case ME4000_GET_USER_INFO:
> +		return me4000_get_user_info((me4000_user_info_t *) arg,
> +					    ao_context->board_info);
> +	case ME4000_AO_SYNCHRONOUS_EX_TRIG:
> +		return me4000_ao_synchronous_ex_trig(ao_context);
> +	case ME4000_AO_SYNCHRONOUS_SW:
> +		return me4000_ao_synchronous_sw(ao_context);
> +	case ME4000_AO_SYNCHRONOUS_DISABLE:
> +		return me4000_ao_synchronous_disable(ao_context);
> +	case ME4000_AO_GET_FREE_BUFFER:
> +		return me4000_ao_get_free_buffer((unsigned long *)arg,
> +						 ao_context);
> +	default:
> +		return -ENOTTY;
> +	}
> +	return 0;
> +}
> +
> +static int me4000_ao_start(unsigned long *arg, me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	wait_queue_head_t queue;
> +	unsigned long ref;
> +	unsigned long timeout;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_start() is executed\n");
> +
> +	if (get_user(timeout, arg)) {

?

> +		printk(KERN_ERR
> +		       "me4000_ao_start():Cannot copy data from user\n");
> +		return -EFAULT;
> +	}
> +
> +	init_waitqueue_head(&queue);
> +
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = inl(ao_context->ctrl_reg);
> +	tmp &= ~(ME4000_AO_CTRL_BIT_STOP | ME4000_AO_CTRL_BIT_IMMEDIATE_STOP);
> +	me4000_outl(tmp, ao_context->ctrl_reg);
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	if ((tmp & ME4000_AO_CTRL_BIT_ENABLE_EX_TRIG)) {
> +		if (timeout) {
> +			ref = jiffies;
> +			while (!
> +			       (inl(ao_context->status_reg) &
> +				ME4000_AO_STATUS_BIT_FSM)) {
> +				interruptible_sleep_on_timeout(&queue, 1);
> +				if (signal_pending(current)) {
> +					printk(KERN_ERR
> +					       "ME4000:me4000_ao_start():Wait on start of state machine interrupted\n");
> +					return -EINTR;
> +				}
> +				if (((jiffies - ref) > (timeout * HZ / USER_HZ))) {	// 2.6 has diffrent definitions for HZ in user and kernel space
> +					printk(KERN_ERR
> +					       "ME4000:me4000_ao_start():Timeout reached\n");
> +					return -EIO;
> +				}
> +			}
> +		}
> +	} else {
> +		me4000_outl(0x8000, ao_context->single_reg);
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_stop(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	wait_queue_head_t queue;
> +	unsigned long flags;
> +
> +	init_waitqueue_head(&queue);
> +
> +	CALL_PDEBUG("me4000_ao_stop() is executed\n");
> +
> +	/* Set the stop bit */
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = inl(ao_context->ctrl_reg);
> +	tmp |= ME4000_AO_CTRL_BIT_STOP;
> +	me4000_outl(tmp, ao_context->ctrl_reg);
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	while (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +		interruptible_sleep_on_timeout(&queue, 1);
> +		if (signal_pending(current)) {
> +			printk(KERN_ERR
> +			       "me4000_ao_stop():Wait on state machine after stop interrupted\n");
> +			return -EINTR;
> +		}
> +	}
> +
> +	/* Clear the stop bit */
> +	//tmp &= ~ME4000_AO_CTRL_BIT_STOP;
> +	//me4000_outl(tmp, ao_context->ctrl_reg);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_immediate_stop(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	wait_queue_head_t queue;
> +	unsigned long flags;
> +
> +	init_waitqueue_head(&queue);
> +
> +	CALL_PDEBUG("me4000_ao_immediate_stop() is executed\n");
> +
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = inl(ao_context->ctrl_reg);
> +	tmp |= ME4000_AO_CTRL_BIT_STOP | ME4000_AO_CTRL_BIT_IMMEDIATE_STOP;
> +	me4000_outl(tmp, ao_context->ctrl_reg);
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	while (inl(ao_context->status_reg) & ME4000_AO_STATUS_BIT_FSM) {
> +		interruptible_sleep_on_timeout(&queue, 1);
> +		if (signal_pending(current)) {
> +			printk(KERN_ERR
> +			       "me4000_ao_immediate_stop():Wait on state machine after stop interrupted\n");
> +			return -EINTR;
> +		}
> +	}
> +
> +	/* Clear the stop bits */
> +	//tmp &= ~(ME4000_AO_CTRL_BIT_STOP | ME4000_AO_CTRL_BIT_IMMEDIATE_STOP);
> +	//me4000_outl(tmp, ao_context->ctrl_reg);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_timer_set_divisor(u32 * arg,
> +				       me4000_ao_context_t * ao_context)
> +{
> +	u32 divisor;
> +	u32 tmp;
> +
> +	CALL_PDEBUG("me4000_ao_timer set_divisor() is executed\n");
> +
> +	if (get_user(divisor, arg))
> +		return -EFAULT;
> +
> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_timer_set_divisor():Can't set timer while DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	PDEBUG("me4000_ao_timer set_divisor():Divisor from user = %d\n",
> +	       divisor);
> +
> +	/* Check if the divisor is right. ME4000_AO_MIN_TICKS is the lowest */
> +	if (divisor < ME4000_AO_MIN_TICKS) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_timer set_divisor():Divisor to low\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Fix bug in Firmware */
> +	divisor -= 2;
> +
> +	PDEBUG("me4000_ao_timer set_divisor():Divisor to HW = %d\n", divisor);
> +
> +	/* Write the divisor */
> +	me4000_outl(divisor, ao_context->timer_reg);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ex_trig_set_edge(int *arg,
> +				      me4000_ao_context_t * ao_context)
> +{
> +	int mode;
> +	u32 tmp;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_ex_trig_set_edge() is executed\n");
> +
> +	if (get_user(mode, arg))
> +		return -EFAULT;

?

> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_ex_trig_set_edge():Can't set trigger while DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	if (mode == ME4000_AO_TRIGGER_EXT_EDGE_RISING) {
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp &=
> +		    ~(ME4000_AO_CTRL_BIT_EX_TRIG_EDGE |
> +		      ME4000_AO_CTRL_BIT_EX_TRIG_BOTH);
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +	} else if (mode == ME4000_AO_TRIGGER_EXT_EDGE_FALLING) {
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp &= ~ME4000_AO_CTRL_BIT_EX_TRIG_BOTH;
> +		tmp |= ME4000_AO_CTRL_BIT_EX_TRIG_EDGE;
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +	} else if (mode == ME4000_AO_TRIGGER_EXT_EDGE_BOTH) {
> +		spin_lock_irqsave(&ao_context->int_lock, flags);
> +		tmp = me4000_inl(ao_context->ctrl_reg);
> +		tmp |=
> +		    ME4000_AO_CTRL_BIT_EX_TRIG_EDGE |
> +		    ME4000_AO_CTRL_BIT_EX_TRIG_BOTH;
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +		spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +	} else {
> +		printk(KERN_ERR
> +		       "me4000_ao_ex_trig_set_edge():Invalid trigger mode\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ex_trig_enable(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_ex_trig_enable() is executed\n");
> +
> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_ex_trig_enable():Can't enable trigger while DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = me4000_inl(ao_context->ctrl_reg);
> +	tmp |= ME4000_AO_CTRL_BIT_ENABLE_EX_TRIG;
> +	me4000_outl(tmp, ao_context->ctrl_reg);
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ex_trig_disable(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_ex_trig_disable() is executed\n");
> +
> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_ex_trig_disable():Can't disable trigger while DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = me4000_inl(ao_context->ctrl_reg);
> +	tmp &= ~ME4000_AO_CTRL_BIT_ENABLE_EX_TRIG;
> +	me4000_outl(tmp, ao_context->ctrl_reg);
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_simultaneous_disable(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +
> +	CALL_PDEBUG("me4000_ao_simultaneous_disable() is executed\n");
> +
> +	/* Check if the state machine is stopped */
> +	/* Be careful here because this function is called from
> +	   me4000_ao_synchronous disable */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_simultaneous_disable():Can't disable while DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	tmp &= ~(0x1 << ao_context->index);	// Disable preload bit
> +	tmp &= ~(0x1 << (ao_context->index + 16));	// Disable hw simultaneous bit
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_simultaneous_ex_trig(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +
> +	CALL_PDEBUG("me4000_ao_simultaneous_ex_trig() is executed\n");
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	tmp |= (0x1 << ao_context->index);	// Enable preload bit
> +	tmp |= (0x1 << (ao_context->index + 16));	// Enable hw simultaneous bit
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_simultaneous_sw(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +
> +	CALL_PDEBUG("me4000_ao_simultaneous_sw() is executed\n");
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	tmp |= (0x1 << ao_context->index);	// Enable preload bit
> +	tmp &= ~(0x1 << (ao_context->index + 16));	// Disable hw simultaneous bit
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_preload(me4000_ao_context_t * ao_context)
> +{
> +	CALL_PDEBUG("me4000_ao_preload() is executed\n");
> +	return me4000_ao_simultaneous_sw(ao_context);
> +}
> +
> +static int me4000_ao_preload_update(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	u32 ctrl;
> +	struct list_head *entry;
> +
> +	CALL_PDEBUG("me4000_ao_preload_update() is executed\n");
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	list_for_each(entry, &ao_context->board_info->ao_context_list) {
> +		/* The channels we update must be in the following state :
> +		   - Mode A
> +		   - Hardware trigger is disabled
> +		   - Corresponding simultaneous bit is reset
> +		 */
> +		ctrl = me4000_inl(ao_context->ctrl_reg);
> +		if (!
> +		    (ctrl &
> +		     (ME4000_AO_CTRL_BIT_MODE_0 | ME4000_AO_CTRL_BIT_MODE_1 |
> +		      ME4000_AO_CTRL_BIT_ENABLE_EX_TRIG))) {
> +			if (!
> +			    (tmp &
> +			     (0x1 <<
> +			      (((me4000_ao_context_t *) entry)->index + 16)))) {
> +				tmp &=
> +				    ~(0x1 <<
> +				      (((me4000_ao_context_t *) entry)->index));
> +			}
> +		}
> +	}
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_simultaneous_update(me4000_ao_channel_list_t * arg,
> +					 me4000_ao_context_t * ao_context)
> +{
> +	int err;
> +	int i;
> +	u32 tmp;
> +	me4000_ao_channel_list_t channels;
> +
> +	CALL_PDEBUG("me4000_ao_simultaneous_update() is executed\n");
> +
> +	/* Copy data from user */
> +	err = copy_from_user(&channels, arg, sizeof(me4000_ao_channel_list_t));
> +	if (err) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_simultaneous_update():Can't copy command\n");
> +		return -EFAULT;
> +	}
> +
> +	channels.list =
> +	    kmalloc(sizeof(unsigned long) * channels.count, GFP_KERNEL);
> +	if (!channels.list) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_simultaneous_update():Can't get buffer\n");
> +		return -ENOMEM;
> +	}
> +	memset(channels.list, 0, sizeof(unsigned long) * channels.count);

kzalloc

> +	/* Copy channel list from user */
> +	err =
> +	    copy_from_user(channels.list, arg->list,
> +			   sizeof(unsigned long) * channels.count);
> +	if (err) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_simultaneous_update():Can't copy list\n");
> +		kfree(channels.list);
> +		return -EFAULT;
> +	}
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	for (i = 0; i < channels.count; i++) {
> +		if (channels.list[i] >
> +		    ao_context->board_info->board_p->ao.count) {
> +			spin_unlock(&ao_context->board_info->preload_lock);
> +			kfree(channels.list);
> +			printk(KERN_ERR
> +			       "ME4000:me4000_ao_simultaneous_update():Invalid board number specified\n");
> +			return -EFAULT;
> +		}
> +		tmp &= ~(0x1 << channels.list[i]);	// Clear the preload bit
> +		tmp &= ~(0x1 << (channels.list[i] + 16));	// Clear the hw simultaneous bit
> +	}
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +	kfree(channels.list);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_synchronous_ex_trig(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_synchronous_ex_trig() is executed\n");
> +
> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR
> +		       "me4000_ao_synchronous_ex_trig(): DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	tmp &= ~(0x1 << ao_context->index);	// Disable synchronous sw bit
> +	tmp |= 0x1 << (ao_context->index + 16);	// Enable synchronous hw bit
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	/* Make runnable */
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = me4000_inl(ao_context->ctrl_reg);
> +	if (tmp & (ME4000_AO_CTRL_BIT_MODE_0 | ME4000_AO_CTRL_BIT_MODE_1)) {
> +		tmp &=
> +		    ~(ME4000_AO_CTRL_BIT_STOP |
> +		      ME4000_AO_CTRL_BIT_IMMEDIATE_STOP);
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +	}
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_synchronous_sw(me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	unsigned long flags;
> +
> +	CALL_PDEBUG("me4000_ao_synchronous_sw() is executed\n");
> +
> +	/* Check if the state machine is stopped */
> +	tmp = me4000_inl(ao_context->status_reg);
> +	if (tmp & ME4000_AO_STATUS_BIT_FSM) {
> +		printk(KERN_ERR "me4000_ao_synchronous_sw(): DAC is running\n");
> +		return -EBUSY;
> +	}
> +
> +	spin_lock(&ao_context->board_info->preload_lock);
> +	tmp = me4000_inl(ao_context->preload_reg);
> +	tmp |= 0x1 << ao_context->index;	// Enable synchronous sw bit
> +	tmp &= ~(0x1 << (ao_context->index + 16));	// Disable synchronous hw bit
> +	me4000_outl(tmp, ao_context->preload_reg);
> +	spin_unlock(&ao_context->board_info->preload_lock);
> +
> +	/* Make runnable */
> +	spin_lock_irqsave(&ao_context->int_lock, flags);
> +	tmp = me4000_inl(ao_context->ctrl_reg);
> +	if (tmp & (ME4000_AO_CTRL_BIT_MODE_0 | ME4000_AO_CTRL_BIT_MODE_1)) {
> +		tmp &=
> +		    ~(ME4000_AO_CTRL_BIT_STOP |
> +		      ME4000_AO_CTRL_BIT_IMMEDIATE_STOP);
> +		me4000_outl(tmp, ao_context->ctrl_reg);
> +	}
> +	spin_unlock_irqrestore(&ao_context->int_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_synchronous_disable(me4000_ao_context_t * ao_context)
> +{
> +	return me4000_ao_simultaneous_disable(ao_context);
> +}
> +
> +static int me4000_ao_get_free_buffer(unsigned long *arg,
> +				     me4000_ao_context_t * ao_context)
> +{
> +	unsigned long c;
> +	int err;
> +
> +	c = me4000_buf_space(ao_context->circ_buf, ME4000_AO_BUFFER_COUNT);
> +
> +	err = copy_to_user(arg, &c, sizeof(unsigned long));
> +	if (err) {
> +		printk(KERN_ERR
> +		       "ME4000:me4000_ao_get_free_buffer():Can't copy to user space\n");
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static int me4000_ao_ex_trig_timeout(unsigned long *arg,
> +				     me4000_ao_context_t * ao_context)
> +{
> +	u32 tmp;
> +	wait_queue_head_t queue;
> +	unsigned long ref;
> +	unsigned long timeout;
> +
> +	CALL_PDEBUG("me4000_ao_ex_trig_timeout() is executed\n");
> +
> +	if (get_user(timeout, arg)) {
> +		printk(KERN_ERR
> +		       "me4000_ao_ex_trig_timeout():Cannot copy data from user\n");
> +		return -EFAULT;
> +	}

erm.  Exactly what is the userspace interface which this driver is
implementing?

> +#define ME4000_BOARD_VERSIONS (sizeof(me4000_boards) / sizeof(me4000_board_t) - 1)

Kill this altogether, use open-coded ARRAY_SIZE


<can't take any more, stops there>
