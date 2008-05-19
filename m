Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbYESNnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbYESNnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763749AbYESNkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:40:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38944 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763533AbYESNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:40:08 -0400
Date: Mon, 19 May 2008 15:40:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: align i2c_device_id
Message-ID: <20080519134045.GA20394@uranus.ravnborg.org>
References: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 03:18:44PM +0200, Jiri Slaby wrote:
> Align i2c_device_id.driver_data to 8 bytes to not fail on crossbuilds.
> 
> (Added in d2653e92732bd3911feff6bee5e23dbf959381db.)
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  include/linux/mod_devicetable.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index a37db57..1fd03e7 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -384,7 +384,8 @@ struct virtio_device_id {
>  
>  struct i2c_device_id {
>  	char name[I2C_NAME_SIZE];
> -	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	kernel_ulong_t driver_data	/* Data private to the driver */
> +			__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };

Thanks Jiri.

	Sam
