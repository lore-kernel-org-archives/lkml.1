Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbZD3PYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbZD3PYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZD3PYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:24:42 -0400
Received: from h155.mvista.com ([63.81.120.155]:45669 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbZD3PYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:24:41 -0400
Message-ID: <49F9C305.9020103@ru.mvista.com>
Date: Thu, 30 Apr 2009 19:25:57 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-usb@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] USB: Provide USB boot device availability notification
References: <20090430000948.GA3408@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090430000948.GA3408@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David VomLehn wrote:

> From: Alan Stern <stern@rowland.harvard.edu>

> Use boot device discovery infrastructure to report availability of USB
> devices.

> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>

[...]

> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index be86ae3..01a9b76 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -37,6 +37,20 @@
>  #endif
>  #endif
>  
> +/* The mask of possible USB boot devices depends on what drivers and
> + * options have been configured into the kernel.  There are too many
> + * USB network config options to list here, so just assume it is always
> + * possible to have a USB network device.
> + */
> +static int usb_bootdev_mask = 0
> +#ifdef CONFIG_USB_SERIAL_CONSOLE
> +				| BOOTDEV_CONSOLE_MASK
> +#endif
> +#if defined(CONFIG_USB_STORAGE) | defined(CONFIG_BLK_DEV_UB)

    It should be ||, not bitwise | here, no?

WBR, Sergei
