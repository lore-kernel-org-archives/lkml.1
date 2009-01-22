Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZAVOtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZAVOtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZAVOtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:49:36 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2182 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZAVOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:49:35 -0500
Message-ID: <52420.62.70.2.252.1232635748.squirrel@webmail.xs4all.nl>
Date: Thu, 22 Jan 2009 15:49:08 +0100 (CET)
Subject: Re: [PATCH] V4L/DVB: fix 
     v4l2_device_call_all/v4l2_device_call_until_err macro
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Roel Kluin" <roel.kluin@gmail.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-media@vger.kernel.org, video4linux-list@redhat.com,
       "lkml" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When these macros aren't called with 'grp_id' this will result in a
> build failure.

Hi Roel,

Thanks, however it is fixed already in the v4l-dvb repo so it should
appear upstream as soon as Mauro prepares the next pull request.

Regards,

       Hans

>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 9bf4ccc..ad86caa 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -94,16 +94,16 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev
> *sd);
>  /* Call the specified callback for all subdevs matching grp_id (if 0,
> then
>     match them all). Ignore any errors. Note that you cannot add or delete
>     a subdev while walking the subdevs list. */
> -#define v4l2_device_call_all(dev, grp_id, o, f, args...) 		\
> +#define v4l2_device_call_all(dev, _grp_id, o, f, args...) 		\
>  	__v4l2_device_call_subdevs(dev, 				\
> -			!(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
> +			!(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
>
>  /* Call the specified callback for all subdevs matching grp_id (if 0,
> then
>     match them all). If the callback returns an error other than 0 or
>     -ENOIOCTLCMD, then return with that error code. Note that you cannot
>     add or delete a subdev while walking the subdevs list. */
> -#define v4l2_device_call_until_err(dev, grp_id, o, f, args...) 		\
> +#define v4l2_device_call_until_err(dev, _grp_id, o, f, args...) 		\
>  	__v4l2_device_call_subdevs_until_err(dev,			\
> -		       !(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
> +		       !(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
>
>  #endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

