Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbYHUPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbYHUPT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYHUPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:19:13 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:23771 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476AbYHUPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:19:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/3] Introduce interface to report BIOS bugs
Date: Thu, 21 Aug 2008 09:19:07 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, len.brown@intel.com,
       arjan@linux.intel.com, linux-acpi@vger.kernel.org,
       Christian Kornacker <ckornacker@suse.de>
References: <1219251726-24746-1-git-send-email-trenn@suse.de> <200808201237.43338.bjorn.helgaas@hp.com> <200808211552.06054.trenn@suse.de>
In-Reply-To: <200808211552.06054.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210919.07642.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 07:52:04 am Thomas Renninger wrote:
> On Wednesday 20 August 2008 20:37:42 Bjorn Helgaas wrote:

> > Maybe even something as simple as:
> >
> >     #define FW_BUG	"[FW bug]: "
> >
> > would be sufficient, with the idea that people could do this:
> >
> >     dev_err(&dev->dev, FW_BUG "interrupts left enabled\n");
> >
> > I think the user-space value derives from having a consistent string
> > to grep for, so this gives you that.  I'm not sure what value we get
> > from adding the new FW_PRINT_CRIT()/FW_PRINT_WARN() interfaces in the
> > kernel.
> 
> What about this one:
> pr_fw_err() or dev_fw_err() on harmful firmware bugs
> and
> pr_fw_info() on non-harmful but ugly BIOS constructs
> which should not exist, violate the spec or could make
> trouble in the future (maybe Firmware is really better...):
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index d24a47f..3204cea 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -538,6 +538,9 @@ extern const char *dev_driver_string(struct device *dev);
>  #define dev_info(dev, format, arg...)		\
>  	dev_printk(KERN_INFO , dev , format , ## arg)
>  
> +#define dev_fw_err(dev, format, arg...)		\
> +	dev_printk(KERN_ERR "[BIOS Bug] ", dev , format , ## arg)
> +
>  #ifdef DEBUG
>  #define dev_dbg(dev, format, arg...)		\
>  	dev_printk(KERN_DEBUG , dev , format , ## arg)
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2651f80..b20f618 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -303,6 +303,12 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>  #define pr_info(fmt, arg...) \
>  	printk(KERN_INFO fmt, ##arg)
>  
> +#define pr_fw_err(fmt, arg...) \
> +	printk(KERN_ERR "[BIOS Bug]" fmt, ##arg)
> +
> +#define pr_fw_info(fmt, arg...) \
> +	printk(KERN_INFO "[BIOS]" fmt, ##arg)
> +
>  #ifdef DEBUG
>  /* If you are writing a driver, please use dev_dbg instead */
>  #define pr_debug(fmt, arg...) \

What value do we gain by defining dev_fw_err(), pr_fw_err(), and
pr_fw_info(), versus just defining FW_BUG?  If they're useful
for something, fine; it's just that I don't know yet what they add.

Bjorn
