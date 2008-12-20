Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYLTAqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYLTAqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 19:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYLTApx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 19:45:53 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3777 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYLTApx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 19:45:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH -next/mmotm] media/video/tuner: fix tuner_ioctl build error
Date: Sat, 20 Dec 2008 01:45:07 +0100
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200812192254.mBJMsfia029162@imap1.linux-foundation.org> <494C3E20.1070800@oracle.com>
In-Reply-To: <494C3E20.1070800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812200145.08394.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 01:36:48 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix drivers/media/video/tuner-core.c so that it will build when
> CONFIG_VIDEO_ALLOW_V4L1=n:
>
> drivers/media/video/tuner-core.c:1111: error: 'tuner_ioctl' undeclared
> here (not in a function)
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> cc: v4l-dvb-maintainer@linuxtv.org
> cc: video4linux-list@redhat.com
> ---
>  drivers/media/video/tuner-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- mmotm-2008-1219-1438.orig/drivers/media/video/tuner-core.c
> +++ mmotm-2008-1219-1438/drivers/media/video/tuner-core.c
> @@ -919,6 +919,11 @@ static int tuner_ioctl(struct v4l2_subde
>  	}
>  	return -ENOIOCTLCMD;
>  }
> +#else
> +static int tuner_ioctl(struct v4l2_subdev *sd, int cmd, void *arg)
> +{
> +	return -ENOIOCTLCMD;
> +}
>  #endif
>
>  static int tuner_s_config(struct v4l2_subdev *sd, const struct
> v4l2_priv_tun_config *cfg)

NAK. I've already made a better fix for this and asked Mauro to pull this 
from my tree. The tuner_ioctl function pointer should have been under the 
CONFIG_VIDEO_ALLOW_V4L1 #ifdef as well avoiding the need to make an empty 
function.

Nevertheless, thanks for the effort!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
