Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0BRTQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:16:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:40500 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752068Ab0BRTQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:16:19 -0500
X-Authenticated: #2283611
X-Provags-ID: V01U2FsdGVkX18EwDAv32EEiPYHeeF1jdZQYR2FdkuMEVgo/j0mYY
	F6IxWpYwCHaMTO
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Subject: Re: [PATCH] drivers/media/radio/si470x/radio-si470x-usb.c fix use after free
Date: Thu, 18 Feb 2010 20:16:12 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Douglas Schilling Landgraf <dougsland@redhat.com>,
       linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1265886473.27789.6.camel@ICE-BOX>
In-Reply-To: <1265886473.27789.6.camel@ICE-BOX>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182016.12573.tobias.lorenz@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Darren,

thanks for the patch. It was already pulled into the main repository.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

Am Donnerstag 11 Februar 2010 12:07:53 schrieb Darren Jenkins:
> In si470x_usb_driver_disconnect() radio->disconnect_lock is accessed
> after it is freed. This fixes the problem.
> 
> Coverity CID: 2530
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> ---
>  drivers/media/radio/si470x/radio-si470x-usb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
> index a96e1b9..1588a9d 100644
> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
> @@ -842,9 +842,11 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
>  		kfree(radio->int_in_buffer);
>  		video_unregister_device(radio->videodev);
>  		kfree(radio->buffer);
> +		mutex_unlock(&radio->disconnect_lock);
>  		kfree(radio);
> +	} else {
> +		mutex_unlock(&radio->disconnect_lock);
>  	}
> -	mutex_unlock(&radio->disconnect_lock);
>  }
>  
>  
> 
