Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031384Ab0B1Enb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 23:43:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39419 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031368Ab0B1Ena convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 23:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fym+3zUrmP2cY3OqgZQZ5a5tRIufesw1wF/WHZtkVh7zdqmPmWai7khNano7dXuilJ
         hFdRy0EA8/3HRkzAopXrqY5KksXW8AWVe1zVD+QdfXfQebD1UHPmCUQmEUjNc9TxYGfp
         7xtI0g4OaZ2nGIn2BE/FuQyKsuweXng4IWhOs=
MIME-Version: 1.0
In-Reply-To: <201002272143.22156.rjw@sisk.pl>
References: <201002272143.22156.rjw@sisk.pl>
Date: Sun, 28 Feb 2010 10:13:29 +0530
Message-ID: <3f9a31f41002272043t59d18d39ga0296ce3f6602c6d@mail.gmail.com>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() 
	messages
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Sun, Feb 28, 2010 at 2:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The messages from _request_firmware() informing that firmware is
> being requested or built-in firmware is going to be used are printed
> at KERN_INFO, which produces lots of noise on systems with huge
> numbers of AMD CPUs.  Reduce the level of these messages to
> KERN_DEBUG to get rid of that noise.
>

Which firmware we are using is very useful information. Because of
huge numbers of CPUs it seems noise then better provide the
information for first cpu and for the rest of the CPUs you can show by
KERN_DEBUG.

Thanks,
--
Jaswinder Singh.

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/firmware_class.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.32-SLE11-SP1/drivers/base/firmware_class.c
> ===================================================================
> --- linux-2.6.32-SLE11-SP1.orig/drivers/base/firmware_class.c
> +++ linux-2.6.32-SLE11-SP1/drivers/base/firmware_class.c
> @@ -487,15 +487,14 @@ _request_firmware(const struct firmware
>             builtin++) {
>                if (strcmp(name, builtin->name))
>                        continue;
> -               dev_info(device, "firmware: using built-in firmware %s\n",
> -                        name);
> +               dev_dbg(device, "firmware: using built-in firmware %s\n", name);
>                firmware->size = builtin->size;
>                firmware->data = builtin->data;
>                return 0;
>        }
>
>        if (uevent)
> -               dev_info(device, "firmware: requesting %s\n", name);
> +               dev_dbg(device, "firmware: requesting %s\n", name);
>
>        retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
>        if (retval)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
