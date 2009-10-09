Return-Path: <linux-kernel-owner+w=401wt.eu-S934434AbZJIVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbZJIVTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZJIVTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:19:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:54858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZJIVTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:19:30 -0400
Date: Fri, 9 Oct 2009 14:16:10 -0700
From: Greg KH <gregkh@suse.de>
To: Bruce Beare <bbeare1@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument,
 stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors,
 incorrect include files
Message-ID: <20091009211610.GA5005@suse.de>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Try changing one thing at a time per patch please.

There's some bugs in here:

> -		struct config_t dig_in_config[32];
> -		struct config_t dig_out_config[32];
> -		struct config_t chan_in_config[32];
> -		struct config_t chan_out_config[32];
>  		int i;
> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);

Shouldn't that be:
		config_data = kmalloc(sizeof(struct config_data_t)*32, GFP_KERNEL);

Otherwise you overflow your buffer here:
>  
>  		for (i = 0; i < 32; i++) {
> -			dig_in_config[i].kind = 0;
> -			dig_in_config[i].bits = 0;
> -			dig_in_config[i].min = 0;
> -			dig_in_config[i].max = 0;
> -			dig_out_config[i].kind = 0;
> -			dig_out_config[i].bits = 0;
> -			dig_out_config[i].min = 0;
> -			dig_out_config[i].max = 0;
> -			chan_in_config[i].kind = 0;
> -			chan_in_config[i].bits = 0;
> -			chan_in_config[i].min = 0;
> -			chan_in_config[i].max = 0;
> -			chan_out_config[i].kind = 0;
> -			chan_out_config[i].bits = 0;
> -			chan_out_config[i].min = 0;
> -			chan_out_config[i].max = 0;
> +			config_data->dig_in_config[i].kind = 0;
> +			config_data->dig_in_config[i].bits = 0;
> +			config_data->dig_in_config[i].min = 0;
> +			config_data->dig_in_config[i].max = 0;
> +			config_data->dig_out_config[i].kind = 0;
> +			config_data->dig_out_config[i].bits = 0;
> +			config_data->dig_out_config[i].min = 0;
> +			config_data->dig_out_config[i].max = 0;
> +			config_data->chan_in_config[i].kind = 0;
> +			config_data->chan_in_config[i].bits = 0;
> +			config_data->chan_in_config[i].min = 0;
> +			config_data->chan_in_config[i].max = 0;
> +			config_data->chan_out_config[i].kind = 0;
> +			config_data->chan_out_config[i].bits = 0;
> +			config_data->chan_out_config[i].min = 0;
> +			config_data->chan_out_config[i].max = 0;
>  		}

Or am I mistaken?

thanks,

greg k-h
