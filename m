Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0BBPXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:23:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab0BBPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:23:19 -0500
Message-ID: <4B684361.2020009@infradead.org>
Date: Tue, 02 Feb 2010 13:23:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] drivers/media/video/uvc: Use %pUl to print UUIDs
References: <1255471594.18975.79.camel@Joe-Laptop.home>	 <20091013151652.5d2a49b7.akpm@linux-foundation.org> <1255476919.18975.127.camel@Joe-Laptop.home>
In-Reply-To: <1255476919.18975.127.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

I'm reviewing all patches marked as under review at Patchwork and I noticed
that this one were never applied, nor I found any nack at linux-media ML.

What's the status for it?

Cheers,
Mauro.

Joe Perches wrote:
> On Tue, 2009-10-13 at 15:16 -0700, Andrew Morton wrote:
>> Please either send an incremental patch or send a new patch.  Not this.
> 
> Sure thing.
> 
> This patch includes some changes that Laurent originally
> commented on as well as the Buffer[5]/buffer[5] correction.
> 
> http://lkml.org/lkml/2009/9/30/399
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  drivers/media/video/uvc/uvc_ctrl.c   |   74 +++++++++++++++------------------
>  drivers/media/video/uvc/uvc_driver.c |    9 ++--
>  drivers/media/video/uvc/uvcvideo.h   |   10 -----
>  3 files changed, 38 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index c3225a5..4536c3e 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1092,10 +1092,9 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
>  	}
>  
>  	if (!found) {
> -		uvc_trace(UVC_TRACE_CONTROL,
> -			"Control " UVC_GUID_FORMAT "/%u not found.\n",
> -			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
> -			xctrl->selector);
> +		uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u not found.\n",
> +			  entity->extension.guidExtensionCode,
> +			  xctrl->selector);
>  		return -EINVAL;
>  	}
>  
> @@ -1171,9 +1170,9 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
>  			    (ctrl->info->flags & UVC_CONTROL_RESTORE) == 0)
>  				continue;
>  
> -			printk(KERN_INFO "restoring control " UVC_GUID_FORMAT
> -				"/%u/%u\n", UVC_GUID_ARGS(ctrl->info->entity),
> -				ctrl->info->index, ctrl->info->selector);
> +			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
> +			       ctrl->info->entity,
> +			       ctrl->info->index, ctrl->info->selector);
>  			ctrl->dirty = 1;
>  		}
>  
> @@ -1227,47 +1226,44 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
>  		ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id,
>  			dev->intfnum, info->selector, (__u8 *)&size, 2);
>  		if (ret < 0) {
> -			uvc_trace(UVC_TRACE_CONTROL, "GET_LEN failed on "
> -				"control " UVC_GUID_FORMAT "/%u (%d).\n",
> -				UVC_GUID_ARGS(info->entity), info->selector,
> -				ret);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "GET_LEN failed on control %pUl/%u (%d).\n",
> +				  info->entity, info->selector, ret);
>  			return;
>  		}
>  
>  		if (info->size != le16_to_cpu(size)) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control " UVC_GUID_FORMAT
> -				"/%u size doesn't match user supplied "
> -				"value.\n", UVC_GUID_ARGS(info->entity),
> -				info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u size doesn't match user supplied value.\n",
> +				  info->entity, info->selector);
>  			return;
>  		}
>  
>  		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
>  			dev->intfnum, info->selector, &inf, 1);
>  		if (ret < 0) {
> -			uvc_trace(UVC_TRACE_CONTROL, "GET_INFO failed on "
> -				"control " UVC_GUID_FORMAT "/%u (%d).\n",
> -				UVC_GUID_ARGS(info->entity), info->selector,
> -				ret);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "GET_INFO failed on control %pUl/%u (%d).\n",
> +				  info->entity, info->selector, ret);
>  			return;
>  		}
>  
>  		flags = info->flags;
>  		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
>  		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u flags don't match "
> -				"supported operations.\n",
> -				UVC_GUID_ARGS(info->entity), info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u flags don't match supported operations.\n",
> +				  info->entity, info->selector);
>  			return;
>  		}
>  	}
>  
>  	ctrl->info = info;
>  	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
> -	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
> -		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
> -		ctrl->info->selector, dev->udev->devpath, entity->id);
> +	uvc_trace(UVC_TRACE_CONTROL,
> +		  "Added control %pUl/%u to device %s entity %u\n",
> +		  ctrl->info->entity, ctrl->info->selector,
> +		  dev->udev->devpath, entity->id);
>  }
>  
>  /*
> @@ -1293,17 +1289,16 @@ int uvc_ctrl_add_info(struct uvc_control_info *info)
>  			continue;
>  
>  		if (ctrl->selector == info->selector) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u is already defined.\n",
> -				UVC_GUID_ARGS(info->entity), info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u is already defined.\n",
> +				  info->entity, info->selector);
>  			ret = -EEXIST;
>  			goto end;
>  		}
>  		if (ctrl->index == info->index) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Control "
> -				UVC_GUID_FORMAT "/%u would overwrite index "
> -				"%d.\n", UVC_GUID_ARGS(info->entity),
> -				info->selector, info->index);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Control %pUl/%u would overwrite index %d.\n",
> +				  info->entity, info->selector, info->index);
>  			ret = -EEXIST;
>  			goto end;
>  		}
> @@ -1344,10 +1339,9 @@ int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping)
>  			continue;
>  
>  		if (info->size * 8 < mapping->size + mapping->offset) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' would "
> -				"overflow control " UVC_GUID_FORMAT "/%u\n",
> -				mapping->name, UVC_GUID_ARGS(info->entity),
> -				info->selector);
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Mapping '%s' would overflow control %pUl/%u\n",
> +				  mapping->name, info->entity, info->selector);
>  			ret = -EOVERFLOW;
>  			goto end;
>  		}
> @@ -1366,9 +1360,9 @@ int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping)
>  
>  		mapping->ctrl = info;
>  		list_add_tail(&mapping->list, &info->mappings);
> -		uvc_trace(UVC_TRACE_CONTROL, "Adding mapping %s to control "
> -			UVC_GUID_FORMAT "/%u.\n", mapping->name,
> -			UVC_GUID_ARGS(info->entity), info->selector);
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Adding mapping %s to control %pUl/%u.\n",
> +			  mapping->name, info->entity, info->selector);
>  
>  		ret = 0;
>  		break;
> diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
> index 8756be5..21d5077 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -328,11 +328,10 @@ static int uvc_parse_format(struct uvc_device *dev,
>  				sizeof format->name);
>  			format->fcc = fmtdesc->fcc;
>  		} else {
> -			uvc_printk(KERN_INFO, "Unknown video format "
> -				UVC_GUID_FORMAT "\n",
> -				UVC_GUID_ARGS(&buffer[5]));
> -			snprintf(format->name, sizeof format->name,
> -				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
> +			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
> +				   &buffer[5]);
> +			snprintf(format->name, sizeof format->name, "%pUl",
> +				 &buffer[5]);
>  			format->fcc = 0;
>  		}
>  
> diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
> index e7958aa..9f4a437 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -555,16 +555,6 @@ extern unsigned int uvc_trace_param;
>  #define uvc_printk(level, msg...) \
>  	printk(level "uvcvideo: " msg)
>  
> -#define UVC_GUID_FORMAT "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-" \
> -			"%02x%02x%02x%02x%02x%02x"
> -#define UVC_GUID_ARGS(guid) \
> -	(guid)[3],  (guid)[2],  (guid)[1],  (guid)[0], \
> -	(guid)[5],  (guid)[4], \
> -	(guid)[7],  (guid)[6], \
> -	(guid)[8],  (guid)[9], \
> -	(guid)[10], (guid)[11], (guid)[12], \
> -	(guid)[13], (guid)[14], (guid)[15]
> -
>  /* --------------------------------------------------------------------------
>   * Internal functions.
>   */
> 
> 


-- 

Cheers,
Mauro
