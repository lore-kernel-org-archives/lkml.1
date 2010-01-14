Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077Ab0ANLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0ANLty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0ANLtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:49:53 -0500
Received: from poutre.nerim.net ([62.4.16.124]:56040 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0ANLtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:49:52 -0500
Date: Thu, 14 Jan 2010 12:49:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [patch] hwmon/amc6821: double unlock bug
Message-ID: <20100114124948.79c9d4d3@hyperion.delvare>
In-Reply-To: <20100114103020.GA4939@bicker>
References: <20100114103020.GA4939@bicker>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 13:30:20 +0300, Dan Carpenter wrote:
> The mutex gets unlocked after we goto EXIT.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/drivers/hwmon/amc6821.c	2010-01-14 13:22:23.000000000 +0300
> +++ devel/drivers/hwmon/amc6821.c	2010-01-14 13:22:30.000000000 +0300
> @@ -686,7 +686,6 @@ static ssize_t set_fan1_div(
>  		data->fan1_div = 4;
>  		break;
>  	default:
> -		mutex_unlock(&data->update_lock);
>  		count = -EINVAL;
>  		goto EXIT;
>  	}

Good catch. Applied, thanks.

-- 
Jean Delvare
