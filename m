Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYCJIQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYCJIQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYCJIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:16:43 -0400
Received: from paperstreet.colino.net ([213.41.244.236]:36963 "EHLO
	paperstreet.colino.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYCJIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:16:42 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 04:16:42 EDT
Date: Mon, 10 Mar 2008 08:46:33 +0100
From: Colin Leroy <colin@colino.net>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
Message-ID: <20080310084633.5246ecfe@paperstreet.colino.net>
In-Reply-To: <47D47B11.1000303@tiscali.nl>
References: <47D47B11.1000303@tiscali.nl>
X-Mailer: Claws Mail 3.3.1cvs17 (GTK+ 2.8.20; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEUAAwASFBYfISMyMTRGRUdaWFdxb2yJhoKrqaPOzMT19Ow5JzfkAAACW0lEQVQ4y6WTP1PbMBjGo6T/RkmmLWxIotCxtkRpmYqVMLAFY2i7AU0DbEDACVOvd6aED9DYnntg61NWCo0tt2N1vpyjn5/30ftIajT+Z4BVLLw3/0w7a+MsVXln8a/5x+E47fXT5FLW55ubP0ZFViTj6KImcXb7l5Pr4XD4JQo3bNDSVdIbLgLhd3ZssLwXHyUXwheACWnXivrx13bHRU3ECHMt6yjsDA8XIWygJsZeBZ5E/mrHBwAgpB9W1XodSw+Dh3cEvA8lODrQVR5i0Q8pTUB0Dq3I3LKTR/3cQyXC5KzM6b1Kugj9+YfI91LxWaUHej1gqsL0vAzkSiUHZqXGFToWuFUTSRHExEiarAsrcO1ThPDUpuVszAC4KgbcI7plQ5q4Cus2Dzh30e72w3ekbCnpSSERXpJGAdhs4Y35ImZiLVNn0y7RyqxzcKvUwDtRKne5JnhuFmJLKXXnZ/p3X0tAZQ4MONUy1UWgAXG1H/rj/HRLA1fbQuCUYN1Ueakp0UkCwMqgW1mhTvFxca67hxDxEoCtvNhHDtd5IQAc65Qs5PcSMbHjasD96iyA+TymlEujcIoza5tfFGlAKOceQm9VYG2/KFRAGeeUoOXUPtRsMupxJrkutTSuXYPonT4MbaNYOq6BlVHAPWEA34O1i5YGQmoPXWsP1a7aeEI5oxRj9LEOtu449SgmBB6FtVpPB9rBDChuagDs8Okg4FVG7Ft7eRKLtmnEWc66Fvg0Wc/boeQu7u6Ovln2PwcL6ZdO2yOrz3ujX6BySA6fpXEovbntcHNwb9x/A34/oQVbOAIKAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 01:04:33 +0100, Roel Kluin wrote:

Hi,

> logical-bitwise & confusion

Looks good to me, but I'm not really maintaining that anymore :-)
I'm not sure who does, Cc:ing Benjamin as he'll probably know.

> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
> index 9587869..8ea7da2 100644
> --- a/drivers/hwmon/adt7473.c
> +++ b/drivers/hwmon/adt7473.c
> @@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(struct device
> *dev, struct i2c_client *client = to_i2c_client(dev);
>  	struct adt7473_data *data = i2c_get_clientdata(client);
>  	int temp = simple_strtol(buf, NULL, 10);
> -	temp = temp && 0xFF;
> +	temp &= 0xFF;
>  
>  	mutex_lock(&data->lock);
>  	data->max_duty_at_overheat = temp;
> 

-- 
Colin
