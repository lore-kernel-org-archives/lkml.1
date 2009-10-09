Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbZJIW3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbZJIW3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934696AbZJIW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:29:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34254 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934692AbZJIW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bbYfsOyrF05V0xHlkgObcxukvqPa8V8f9p5d3jEeYoDbS6/H7AhbGORAodPeP4jjOT
         MKxwQyPpjW6/5j/csFgAwCY4nGsBZIHtY68e2HfWaAr9nSU7sH2PN4nh5Cw48twNe26T
         jPpE6QthjcXqUj8F4mSAGIJmmPNIsF50MSK5I=
Message-ID: <4ACFB908.6070708@gmail.com>
Date: Sat, 10 Oct 2009 00:28:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bruce Beare <bbeare1@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack
 frame size > 2048 (added a kmalloc/kfree), style/formatting errors, incorrect
 include files
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
In-Reply-To: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 11:11 PM, Bruce Beare wrote:
> -		struct config_t dig_in_config[32];
> -		struct config_t dig_out_config[32];
> -		struct config_t chan_in_config[32];
> -		struct config_t chan_out_config[32];
>  		int i;
> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);

And possibly switch this to kzalloc and remove the for below. (As a
separate patch.)

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
