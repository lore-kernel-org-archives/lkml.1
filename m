Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYF3Tsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYF3Tsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYF3Tsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:48:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:64295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYF3Tse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JiGU/1jRaTbyLcr/Jn6lBPBAXextvtsKDMtwmwUkxJWW9CCS73dsuXc5VSfWG/YwaU
         GLz4plJICh7FFqYG6oAR7US+cD86ESbFj7lHciJMD6ypoTvw2S8JtfDkrwIdWH7lxXCd
         HN2UVk1SEn3z9yUZZ6IfmUfW66mzSKnixE7bs=
Message-ID: <4869380B.5020409@gmail.com>
Date: Mon, 30 Jun 2008 21:46:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [PATCH 11/13] viafb: viafbdev.c, viafbdev.h
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7895@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7895@exchtp03.taipei.via.com.tw>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2008 09:46 AM, JosephChan@via.com.tw wrote:
> Initialization, remove and some other important functions of viafb.
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> --- a/drivers/video/via/viafbdev.c	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/viafbdev.c	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,2659 @@
[...]
> +#ifdef MODULE
> +#include <linux/module.h>
> +#endif

don't ifdef it

> +#define _MASTER_FILE
[...]
> +static void get_panel_max_scal_size(struct _panel_size_pos_info
> +	*p_max_size)
> +{
> +	switch (p_max_size->device_type) {
> +	case DVI_Device:
> +		p_max_size->x = p_max_size->y = 0;
> +		break;
> +	default:
> +		p_max_size->x = p_max_size->y = 0;
> +	}
> +}
> +static void get_panel_max_scal_pos(struct _panel_size_pos_info *p_para)
> +{
> +	switch (p_para->device_type) {
> +	case DVI_Device:
> +		p_para->x = p_para->y = 0;
> +		break;
> +	default:
> +		p_para->x = p_para->y = 0;
> +	}
> +}
> +
> +static void get_panel_scal_pos(struct _panel_size_pos_info *p_para)
> +{
> +	switch (p_para->device_type) {
> +	case DVI_Device:
> +		p_para->x = p_para->y = 0;
> +		break;
> +	default:
> +		p_para->x = p_para->y = 0;
> +	}
> +}
> +static void get_panel_scal_size(struct _panel_size_pos_info *p_para)
> +{
> +	switch (p_para->device_type) {
> +	case DVI_Device:
> +		p_para->x = p_para->y = 0;
> +		break;
> +	default:
> +		p_para->x = p_para->y = 0;
> +	}

why all the swicthes?

> +}
> +
> +static void set_panel_scal_pos(struct _panel_size_pos_info *p_para)
> +{
> +	switch (p_para->device_type) {
> +	case DVI_Device:
> +		break;
> +	default:
> +		;
> +	}
> +}
> +
> +static void set_panel_scal_size(struct _panel_size_pos_info *p_para)
> +{
> +	switch (p_para->device_type) {
> +	case DVI_Device:
> +		break;
> +	default:
> +		;
> +	}

Sorry?

> +}
[...]
> +static int viafb_get_cmap_len(struct fb_var_screeninfo *var)

inline candidate?

> +{
> +	DEBUG_MSG(KERN_INFO "viafb_get_cmap_len!\n");
> +
> +	return (var->bits_per_pixel == 8) ? 256 : 16;
> +}
[...]
> +static int viafb_pan_display(struct fb_var_screeninfo *var,
> +	struct fb_info *info)
> +{
> +	unsigned int offset = 0;

do not init it.

> +
> +	DEBUG_MSG(KERN_INFO "viafb_pan_display!\n");
> +
> +	offset = (var->xoffset + (var->yoffset * var->xres)) *
> +	    var->bits_per_pixel / 16;
> +
> +	DEBUG_MSG(KERN_INFO "\nviafb_pan_display,offset =%d ", offset);
> +
> +	viafb_write_reg_mask(0x48, 0x3d4, ((offset >> 24) & 0x3), 0x3);
> +	viafb_write_reg_mask(0x34, 0x3d4, ((offset >> 16) & 0xff), 0xff);
> +	viafb_write_reg_mask(0x0c, 0x3d4, ((offset >> 8) & 0xff), 0xff);
> +	viafb_write_reg_mask(0x0d, 0x3d4, (offset & 0xff), 0xff);
> +
> +	return 0;
> +}
[...]
> +static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
> +{

I haven't measured this, but how big are these variables?
4*256 + plenty of non-pointers seems like stack-unfriendly code.


> +	struct viafb_ioctl_info viainfo;
> +	struct viafb_ioctl_mode viamode;
> +	struct viafb_ioctl_samm viasamm;
> +	struct viafb_driver_version driver_version;
> +	struct fb_var_screeninfo sec_var;
> +	struct _panel_size_pos_info panel_pos_size_para;
> +	u32 state_info = 0;
> +	u32 viafb_gamma_table[256];
> +	char driver_name[10] = "viafb\0";

the nul-termination is implicit

> +
> +	u32 __user *argp = (u32 __user *) arg;
> +	u32 gpu32 = 0, ss;
> +	u32 video_dev_info = 0;
> +	struct viafb_ioctl_setting viafb_setting;
> +	struct device_t active_dev;

you can use "= { }" instead of memsets

> +	ss = sizeof(active_dev);
> +	memset(&active_dev, 0, ss);
> +	memset(&viafb_setting, 0, sizeof(viafb_setting));
> +
> +	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
> +

This should be unlocked_ioctl ready, I suppose.

> +	switch (cmd) {
> +	case VIAFB_GET_CHIP_INFO:	/*struct chip_information chip_info ; */
> +	if (copy_to_user((void __user *)arg, viaparinfo->chip_info,

some bad alignment, use argp

> +		sizeof(struct chip_information)))
> +		return -EFAULT;
> +		break;
> +	case VIAFB_GET_INFO_SIZE:
> +		return put_user(sizeof(viainfo), argp);
> +	case VIAFB_GET_INFO:
> +		return viafb_ioctl_get_viafb_info(arg);
> +	case VIAFB_HOTPLUG:
> +		return put_user((u32)

cast unneeded

> +				viafb_ioctl_hotplug(info->var.xres,
> +					      info->var.yres,
> +					      info->var.bits_per_pixel), argp);
> +		break;

break unneeded

> +	case VIAFB_SET_HOTPLUG_FLAG:
> +		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
> +			return -EFAULT;
> +		via_fb_hotplug = (gpu32) ? 1 : 0;
> +		break;
> +	case VIAFB_GET_RESOLUTION:
> +		viamode.xres = (u32) via_fb_hotplug_Xres;
> +		viamode.yres = (u32) via_fb_hotplug_Yres;
> +		viamode.refresh = (u32) via_fb_hotplug_refresh;
> +		viamode.bpp = (u32) via_fb_hotplug_bpp;
> +		if (viafb_SAMM_ON == 1) {
> +			viamode.xres_sec = viafb_second_xres;
> +			viamode.yres_sec = viafb_second_yres;
> +			viamode.virtual_xres_sec = viafb_second_virtual_xres;
> +			viamode.virtual_yres_sec = viafb_second_virtual_yres;
> +			viamode.refresh_sec = viafb_refresh1;
> +			viamode.bpp_sec = via_fb_bpp1;
> +		} else {
> +			viamode.xres_sec = 0;
> +			viamode.yres_sec = 0;
> +			viamode.virtual_xres_sec = 0;
> +			viamode.virtual_yres_sec = 0;
> +			viamode.refresh_sec = 0;
> +			viamode.bpp_sec = 0;
> +		}
> +		if (copy_to_user((void __user *)arg,

argp

> +			&viamode, sizeof(viamode)))
> +			return -EFAULT;
> +		break;
> +	case VIAFB_GET_SAMM_INFO:
> +		viasamm.samm_status = viafb_SAMM_ON;
> +
> +		if (viafb_SAMM_ON == 1) {
> +			if (viafb_dual_fb) {
> +				viasamm.size_prim = viaparinfo->fbmem_free;
> +				viasamm.size_sec = viaparinfo1->fbmem_free;
> +			} else {
> +				if (viafb_second_size) {
> +					viasamm.size_prim =
> +					    viaparinfo->fbmem_free -
> +					    viafb_second_size * 1024 * 1024;
> +					viasamm.size_sec =
> +					    viafb_second_size * 1024 * 1024;
> +				} else {
> +					viasamm.size_prim =
> +					    viaparinfo->fbmem_free >> 1;
> +					viasamm.size_sec =
> +					    (viaparinfo->fbmem_free >> 1);
> +				}
> +			}
> +			viasamm.mem_base = viaparinfo->fbmem;
> +			viasamm.offset_sec = viafb_second_offset;
> +		} else {
> +			viasamm.size_prim =
> +			    viaparinfo->memsize - viaparinfo->fbmem_used;
> +			viasamm.size_sec = 0;
> +			viasamm.mem_base = viaparinfo->fbmem;
> +			viasamm.offset_sec = 0;
> +		}
> +
> +		if (copy_to_user((void __user *)arg,

...

> +			&viasamm, sizeof(viasamm)))
> +			return -EFAULT;
> +
> +		break;
> +	case VIAFB_TURN_ON_OUTPUT_DEVICE:
> +		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
> +			return -EFAULT;
> +		if (gpu32 & CRT_Device)
> +			viafb_crt_enable();
> +		if (gpu32 & DVI_Device)
> +			viafb_dvi_enable();
> +		if (gpu32 & LCD_Device)
> +			viafb_lcd_enable();
> +		break;
> +	case VIAFB_TURN_OFF_OUTPUT_DEVICE:
> +		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
> +			return -EFAULT;
> +		if (gpu32 & CRT_Device)
> +			viafb_crt_disable();
> +		if (gpu32 & DVI_Device)
> +			viafb_dvi_disable();
> +		if (gpu32 & LCD_Device)
> +			viafb_lcd_disable();
> +		break;
> +	case VIAFB_SET_DEVICE:
> +		if (copy_from_user(&active_dev, (void *)argp, ss))

sparse unfriendly cast

> +			return -EFAULT;
> +		viafb_set_device(active_dev);
> +		viafb_set_par(info);
> +		break;
> +	case VIAFB_GET_DEVICE:
> +		active_dev.crt = viafb_CRT_ON;
> +		active_dev.dvi = viafb_DVI_ON;
> +		active_dev.lcd = viafb_LCD_ON;
> +		active_dev.samm = viafb_SAMM_ON;
> +		active_dev.primary_dev = viafb_primary_dev;
> +
> +		active_dev.lcd_dsp_cent = viafb_lcd_dsp_method;
> +		active_dev.lcd_panel_id = viafb_lcd_panel_id;
> +		active_dev.lcd_mode = viafb_lcd_mode;
> +
> +		active_dev.xres = via_fb_hotplug_Xres;
> +		active_dev.yres = via_fb_hotplug_Yres;
> +
> +		active_dev.xres1 = viafb_second_xres;
> +		active_dev.yres1 = viafb_second_yres;
> +
> +		active_dev.bpp = via_fb_bpp;
> +		active_dev.bpp1 = via_fb_bpp1;
> +		active_dev.refresh = viafb_refresh;
> +		active_dev.refresh1 = viafb_refresh1;
> +
> +		active_dev.epia_dvi = viafb_platform_epia_dvi;
> +		active_dev.lcd_dual_edge = viafb_device_lcd_dualedge;
> +		active_dev.bus_width = via_bus_width;
> +
> +		if (copy_to_user((void __user *)arg, &active_dev, ss))

jsut argp

> +			return -EFAULT;
> +		break;
> +
> +	case VIAFB_GET_DRIVER_VERSION:
> +		driver_version.iMajorNum = VERSION_MAJOR;
> +		driver_version.iKernelNum = VERSION_KERNEL;
> +		driver_version.iOSNum = VERSION_OS;
> +		driver_version.iMinorNum = VERSION_MINOR;
> +
> +		if (copy_to_user
> +		    ((void __user *)arg, &driver_version,

... and so on

> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
[...]
> +static u8 is_duoview(void)
> +{
> +	if (0 == viafb_SAMM_ON) {
> +		if (viafb_LCD_ON + viafb_LCD2_ON +
> +			viafb_DVI_ON + viafb_CRT_ON == 2)
> +			return TRUE;
> +		return FALSE;
> +	} else {
> +		return FALSE;
> +	}

use already defined true and false.

> +}
[...]
> +static int parse_port(char *opt_str, int *output_interface)
> +{
> +	if (!strncmp(opt_str, "DVP0", 4))
> +		*output_interface = INTERFACE_DVP0;
> +	else if (!strncmp(opt_str, "DVP1", 4))
> +		*output_interface = INTERFACE_DVP1;
> +	else if (!strncmp(opt_str, "DFP_HIGHLOW", 11))
> +		*output_interface = INTERFACE_DFP;
> +	else if (!strncmp(opt_str, "DFP_HIGH", 8))
> +		*output_interface = INTERFACE_DFP_HIGH;
> +	else if (!strncmp(opt_str, "DFP_LOW", 8))

7?

> +		*output_interface = INTERFACE_DFP_LOW;
> +	else
> +		*output_interface = INTERFACE_NONE;
> +	return 0;
> +}
[...]
> +static int __devinit via_pci_probe(void)
> +{
> +
> +	/*unsigned char revision; */
> +	unsigned int default_xres, default_yres;
> +	char *tmpc, *tmpm;
> +	char *tmpc_sec, *tmpm_sec;
> +	int vmode_index;
> +    u32 tmds_length, lvds_length, crt_length, chip_length, viafb_par_length;
> +
> +	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
> +
> +#define BYTES_PER_LONG (BITS_PER_LONG/8)
> +#define PADDING(A) (BYTES_PER_LONG - (sizeof(A) % BYTES_PER_LONG))

Is this ALIGN() reimplementation?

> +	viafb_par_length = sizeof(struct viafb_par) + PADDING(struct viafb_par);
> +	tmds_length = sizeof(struct tmds_setting_information) +
> +		PADDING(struct tmds_setting_information);
> +	lvds_length = sizeof(struct lvds_setting_information) +
> +		PADDING(struct lvds_setting_information);
> +	crt_length = sizeof(struct crt_setting_information) +
> +		PADDING(struct crt_setting_information);
> +	chip_length = sizeof(struct chip_information) +
> +		PADDING(struct chip_information);
> +#undef PADDING
> +#undef BYTES_PER_LONG
[...]
> +static void __devexit via_pci_remove(void)
> +{
> +	DEBUG_MSG(KERN_INFO "via_pci_remove!\n");
> +	fb_dealloc_cmap(&viafbinfo->cmap);
> +	unregister_framebuffer(viafbinfo);
> +	if (viafb_dual_fb)
> +		unregister_framebuffer(viafbinfo1);
> +	iounmap((void *)viaparinfo->fbmem_virt);

I suppose io_virt is unmapped somewhere else?

> +
> +	framebuffer_release(viafbinfo);
> +	if (viafb_dual_fb)
> +		framebuffer_release(viafbinfo1);
> +
> +	viafb_remove_proc(viaparinfo->proc_entry);
> +}
> +
> +int __init viafb_init(void)

static

> +{
> +	DEBUG_MSG(KERN_INFO "viafb_init!\n");

Is this useful?

> +	printk(KERN_INFO
> +       "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
> +	       VERSION_MAJOR, VERSION_MINOR);
> +#ifndef MODULE
> +	char *option = NULL;

mixing decl and code. put this code into { }

> +	if (fb_get_options("viafb", &option))
> +		return -ENODEV;
> +	viafb_setup(option);
> +#endif
> +	return via_pci_probe();
> +}
> +
> +void __exit viafb_exit(void)
> +{
> +	DEBUG_MSG(KERN_INFO "viafb_exit!\n");
> +	if (timer_on) {
> +		del_timer(&timer_for3D);

del_timer_sync. You don't need to test for timer_on, do you?

> +		timer_on = 0;
> +	}
> +	via_pci_remove();
> +}
> +
> +int __init viafb_setup(char *options)

static

> +{
> +	char *this_opt;
> +	DEBUG_MSG(KERN_INFO "viafb_setup!\n");
> +
> +	if (!options || !*options)
> +		return 0;
> +
> +	while ((this_opt = strsep(&options, ",")) != NULL) {
> +		if (!*this_opt)
> +			continue;
> +
> +		if (!strncmp(this_opt, "viafb_mode=", 11)) {
> +			viafb_mode = kmalloc(strlen(this_opt + 5), GFP_KERNEL);
> +			strcpy(viafb_mode, this_opt + 11);

kstrdup + checks for NULL and so further...

> +		} else if (!strncmp(this_opt, "viafb_mode1=", 12)) {
> +			viafb_mode1 = kmalloc(strlen(this_opt + 11),
> +				GFP_KERNEL);
> +			strcpy(viafb_mode1, this_opt + 12);
> +		} else if (!strncmp(this_opt, "via_fb_bpp=", 11))
> +			strict_strtoul(this_opt + 11, 0,
> +				(unsigned long *)&via_fb_bpp);
