Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbYESTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbYESTA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYESTAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:00:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32103 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYESTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:00:13 -0400
Date: Mon, 19 May 2008 21:00:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: align i2c_device_id
Message-ID: <20080519210003.65b65d14@hyperion.delvare>
In-Reply-To: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
References: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 19 May 2008 15:18:44 +0200, Jiri Slaby wrote:
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
>  

Thanks for this patch, it's in my i2c tree now and will be sent to
Linus by the end of the week. I wasn't aware of this possible alignment
issue, sorry.

-- 
Jean Delvare
