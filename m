Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZBSR1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZBSR1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZBSR1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:27:24 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:14188 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZBSR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:27:24 -0500
Date: Thu, 19 Feb 2009 18:27:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com,
       Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH] hwmon/hdaps: remove redundant sysfs invert
Message-ID: <20090219182714.423757a9@hyperion.delvare>
In-Reply-To: <499D543B.6050703@suse.de>
References: <499569A9.5030202@suse.de>
	<499807B4.1050606@suse.de>
	<4998120C.3030808@suse.de>
	<20090215153735.25ee8b05@hyperion.delvare>
	<499D543B.6050703@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Thu, 19 Feb 2009 13:44:43 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Get rid of sysfs attribute "invert" as its
> redundant to module parameter.

It seems it isn't that easy:

> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/hwmon/hdaps.c |   24 ------------------------
>  1 file changed, 24 deletions(-)
> 
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -428,28 +428,6 @@ static ssize_t hdaps_calibrate_store(str
>  	return count;
>  }
>  
> -static ssize_t hdaps_invert_show(struct device *dev,
> -				 struct device_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%u\n", hdaps_invert);
> -}
> -
> -static ssize_t hdaps_invert_store(struct device *dev,
> -				  struct device_attribute *attr,
> -				  const char *buf, size_t count)
> -{
> -	int invert;
> -
> -	if (sscanf(buf, "%d", &invert) != 1 ||
> -	    invert < 0 || invert > HDAPS_BOTH_AXES)
> -		return -EINVAL;
> -
> -	hdaps_invert = invert;
> -	hdaps_calibrate();

Apparently recalibration is necessary when you change the inversion
settings. The module parameter, which you made writable in a previous
patch, does _not_ recalibrate when changed.

So it was probably not such a good idea to make the module parameter
writable, and that should be reverted. Which in turn means that the
sysfs attribute "invert" has to stay.

> -
> -	return count;
> -}
> -
>  static DEVICE_ATTR(position, 0444, hdaps_position_show, NULL);
>  static DEVICE_ATTR(variance, 0444, hdaps_variance_show, NULL);
>  static DEVICE_ATTR(temp1, 0444, hdaps_temp1_show, NULL);
> @@ -457,7 +435,6 @@ static DEVICE_ATTR(temp2, 0444, hdaps_te
>  static DEVICE_ATTR(keyboard_activity, 0444, hdaps_keyboard_activity_show, NULL);
>  static DEVICE_ATTR(mouse_activity, 0444, hdaps_mouse_activity_show, NULL);
>  static DEVICE_ATTR(calibrate, 0644, hdaps_calibrate_show,hdaps_calibrate_store);
> -static DEVICE_ATTR(invert, 0644, hdaps_invert_show, hdaps_invert_store);
>  
>  static struct attribute *hdaps_attributes[] = {
>  	&dev_attr_position.attr,
> @@ -467,7 +444,6 @@ static struct attribute *hdaps_attribute
>  	&dev_attr_keyboard_activity.attr,
>  	&dev_attr_mouse_activity.attr,
>  	&dev_attr_calibrate.attr,
> -	&dev_attr_invert.attr,
>  	NULL,
>  };
>  


-- 
Jean Delvare
