Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYH0IGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYH0IGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH0IGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:06:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35739 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYH0IGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:06:10 -0400
Date: Wed, 27 Aug 2008 10:06:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: ibmpex.c remove inline wrapper of be16_to_cpup
Message-ID: <20080827100601.79abc0c6@hyperion.delvare>
In-Reply-To: <1219790755.6069.41.camel@brick>
References: <1219790755.6069.41.camel@brick>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

On Tue, 26 Aug 2008 15:45:55 -0700, Harvey Harrison wrote:
> Sparse noticed the helper was missing a cast:
> drivers/hwmon/ibmpex.c:43:23: warning: incorrect type in argument 1 (different base types)
> drivers/hwmon/ibmpex.c:43:23:    expected restricted __be16 const [usertype] *p
> drivers/hwmon/ibmpex.c:43:23:    got unsigned short [usertype] *<noident>
> 
> Just open-code the helper as it didn't add anything.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/hwmon/ibmpex.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index 4e9b19c..abc8fb0 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -38,11 +38,6 @@
>  #define PEX_NET_FUNCTION	0x3A
>  #define PEX_COMMAND		0x3C
>  
> -static inline u16 extract_value(const char *data, int offset)
> -{
> -	return be16_to_cpup((u16 *)&data[offset]);
> -}
> -
>  #define TEMP_SENSOR		1
>  #define POWER_SENSOR		2
>  
> @@ -165,7 +160,7 @@ static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
>  		 "v%d.%d %d-%02d-%02d on interface %d\n",
>  		 data->sensor_major,
>  		 data->sensor_minor,
> -		 extract_value(data->rx_msg_data, 2),
> +		 be16_to_cpup((__be16 *)&data->rx_msg_data[2]),
>  		 data->rx_msg_data[4],
>  		 data->rx_msg_data[5],
>  		 data->interface);
> @@ -247,11 +242,11 @@ static void ibmpex_update_device(struct ibmpex_bmc_data *data)
>  		if (err)
>  			continue;
>  		data->sensors[i].values[0] =
> -			extract_value(data->rx_msg_data, 16);
> +			be16_to_cpup((__be16 *)&data->rx_msg_data[16]);
>  		data->sensors[i].values[1] =
> -			extract_value(data->rx_msg_data, 18);
> +			be16_to_cpup((__be16 *)&data->rx_msg_data[18]);
>  		data->sensors[i].values[2] =
> -			extract_value(data->rx_msg_data, 20);
> +			be16_to_cpup((__be16 *)&data->rx_msg_data[20]);
>  	}
>  
>  	data->last_updated = jiffies;

Please send this patch to the lm-sensors list (as specified in
MAINTAINERS) and to the driver author (Darrick J. Wong) so that it can
get review and testing.

Thanks,
-- 
Jean Delvare
