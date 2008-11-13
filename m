Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbYKMO7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbYKMO7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYKMO7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:59:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:29386 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbYKMO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:59:16 -0500
Message-ID: <491C40C2.7000302@ru.mvista.com>
Date: Thu, 13 Nov 2008 17:59:14 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Kevin Hao <kexin.hao@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Alan Cox <alan@redhat.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] add device function for usb serial console
References: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com> <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com> <2fdffab7c5a36049b81ec63f2ee1fbdd4dd25a8a.1226366228.git.kexin.hao@windriver.com>
In-Reply-To: <2fdffab7c5a36049b81ec63f2ee1fbdd4dd25a8a.1226366228.git.kexin.hao@windriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kevin Hao wrote:

> Add device funtion for usb serial console, so we can open /dev/console
> when we use a usb serial device as console.

> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>

> diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
> index 5b95009..1dbb203 100644
> --- a/drivers/usb/serial/console.c
> +++ b/drivers/usb/serial/console.c
> @@ -241,12 +241,25 @@ static void usb_console_write(struct console *co,
>  	}
>  }
>  
> +static struct tty_driver *usb_console_device(struct console *co, int *index)
> +{
> +	struct tty_driver **p = (struct tty_driver **)co->data;
> +
> +	if (!*p)
> +		return NULL;
> +
> +	*index = co->index;
> +	return (struct tty_driver *)(*p);

    Type cast not needed here.

WBR, Sergei
