Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZJCHT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZJCHT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 03:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZJCHT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 03:19:27 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39036 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZJCHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 03:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=yBaOIqOSQY0npVwlL731gOFMgOq2xUKQCWVaAcajptbbMgL2TS5GOnCyvLv80+RBBH
         jBB4KMR1sIbuzJbJbv/HyvWe1Zot1WzcgNX2zDQWwaEoWOnGJBs8lAyFndobhA12PQLx
         Xj+raYMhJt4FB0/3L+K2ARs/4kMBqPCdoeA3o=
From: Corentin Chary <corentincj@iksaif.net>
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [Resend][PATCH] eeepc-laptop: Properly annote eeepc_enable_camera().
Date: Sat, 3 Oct 2009 09:20:18 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-gentoo; KDE/4.3.1; x86_64; ; )
Cc: acpi4asus-user@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <b9df5fa10910022324u1d91b4d0oe051ef45dd347cbc@mail.gmail.com>
In-Reply-To: <b9df5fa10910022324u1d91b4d0oe051ef45dd347cbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910030920.18591.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 October 2009 08:24:53 Rakib Mullick wrote:
>  Currently the annotation for function eeepc_enable_camera() is
> __init, and refers to a
> function eeepc_hotk_add() which is non-init. Use __devinit for both
> functions which is
> more appropriate and fixes a section mismatch warning.
> 
>  We were warned by the following warning:
> 
>   LD      drivers/platform/x86/built-in.o
> WARNING: drivers/platform/x86/built-in.o(.text+0x12e1): Section
> mismatch in reference from the function eeepc_hotk_add() to the
> function .init.text:eeepc_enable_camera()
> The function eeepc_hotk_add() references
> the function __init eeepc_enable_camera().
> This is often because eeepc_hotk_add lacks a __init
> annotation or the annotation of eeepc_enable_camera is wrong.
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/drivers/platform/x86/eeepc-laptop.c	2009-10-03
> 12:44:40.000000000 +0600
> +++ rakib/drivers/platform/x86/eeepc-laptop.c	2009-10-03
> 12:48:42.000000000 +0600
> @@ -350,7 +350,7 @@ static const struct rfkill_ops eeepc_rfk
>  	.set_block = eeepc_rfkill_set,
>  };
> 
> -static void __init eeepc_enable_camera(void)
> +static void __devinit eeepc_enable_camera(void)
>  {
>  	/*
>  	 * If the following call to set_acpi() fails, it's because there's no
> @@ -1189,7 +1189,7 @@ static int eeepc_input_init(struct devic
>  	return 0;
>  }
> 
> -static int eeepc_hotk_add(struct acpi_device *device)
> +static int __devinit eeepc_hotk_add(struct acpi_device *device)
>  {
>  	struct device *dev;
>  	int result;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hi,
The patch is broken again, 
The section 
> --- linus/drivers/platform/x86/eeepc-laptop.c	2009-10-03
> 12:44:40.000000000 +0600
> +++ rakib/drivers/platform/x86/eeepc-laptop.c	2009-10-03
> 12:48:42.000000000 +0600
is line-wrapped by mail client when you send it. It happens because 
rakib/drivers/platform/x86/eeepc-laptop.c is a very long patch.

The Signed-off-by also should be before ---

Anyway I fixed it and applied your patch in acpi4asus tree.
I'll try to get it merged into 2.6.32.

Please read Documentation/email-clients.txt to fix your mail client
or just use git send-email.

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
