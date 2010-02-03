Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0BCVwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:52:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:46702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932657Ab0BCVwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:52:42 -0500
X-Authenticated: #2283611
X-Provags-ID: V01U2FsdGVkX19S1B0HcpdSiEZofsVqhNASWbsmKebF9pG2kBc2xw
	O1BC5c7SZPeMH2
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
Date: Wed, 3 Feb 2010 22:52:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4B69D2F5.2050100@gmail.com>
In-Reply-To: <4B69D2F5.2050100@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002032252.36514.tobias.lorenz@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roel,

no, the default value of retval makes no difference to the function.

Retval is set by si470x_disconnect_check and si470x_set_register.
After each call, retval is checked.
There is no need to reset it passed.

The only reason, there is a default value is my static code checker, saying variables should have default values.
Setting it to -EINVAL seems more reasonable to me than setting it 0.
In fact the patch would bring up the warning on setting default values again.

Bye,
Toby

Am Mittwoch 03 Februar 2010 20:48:05 schrieb Roel Kluin:
> The -EINVAL was overwritten by the si470x_disconnect_check().
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this needed?
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
> index 4da0f15..65b4a92 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -748,12 +748,13 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
>  		struct v4l2_tuner *tuner)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = -EINVAL;
> +	int retval;
>  
>  	/* safety checks */
>  	retval = si470x_disconnect_check(radio);
>  	if (retval)
>  		goto done;
> +	retval = -EINVAL;
>  
>  	if (tuner->index != 0)
>  		goto done;
> 
