Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZJ1XQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZJ1XQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZJ1XQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:16:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbZJ1XQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:16:23 -0400
Date: Wed, 28 Oct 2009 16:16:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Jan Dumon <j.dumon@option.com>
Subject: Re: [PATCH] hso: fix debug routines
Message-Id: <20091028161617.26a58618.akpm@linux-foundation.org>
In-Reply-To: <1256653615.3591.113.camel@nomovok.homedomain>
References: <1256200578.3057.113.camel@nomovok.homedomain>
	<20091026171550.GA24910@kroah.com>
	<1256585855.3591.52.camel@nomovok.homedomain>
	<20091026194058.GA25263@kroah.com>
	<1256653615.3591.113.camel@nomovok.homedomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 16:26:55 +0200
Antti Kaijanmäki <antti.kaijanmaki@nomovok.com> wrote:

> On Mon, 2009-10-26 at 12:40 -0700, Greg KH wrote:
> > Yes, that should be a new patch, especially as it would not be needed
> > to fix older kernels for the original bug.
> > 
> > So, care to send 2 patches?  The debug one isn't needed to be sent to
> > the stable@kernel.org address.
> 
> 
> Signed-off-by: Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
> ---
>  drivers/net/usb/hso.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index fa4e581..746839b 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -378,7 +378,7 @@ static void dbg_dump(int line_count, const char *func_name, unsigned char *buf,
>  }
>  
>  #define DUMP(buf_, len_)	\
> -	dbg_dump(__LINE__, __func__, buf_, len_)
> +	dbg_dump(__LINE__, __func__, (unsigned char *)buf_, len_)
>  
>  #define DUMP1(buf_, len_)			\
>  	do {					\
> @@ -1527,7 +1527,7 @@ static void tiocmget_intr_callback(struct urb *urb)
>  		dev_warn(&usb->dev,
>  			 "hso received invalid serial state notification\n");
>  		DUMP(serial_state_notification,
> -		     sizeof(hso_serial_state_notifation))
> +		     sizeof(struct hso_serial_state_notification));
>  	} else {
>  
>  		UART_state_bitmap = le16_to_cpu(serial_state_notification->

This patch has no changelog, and I'm not seeing any description of what
it fixes and how it fixes it up-thread.
