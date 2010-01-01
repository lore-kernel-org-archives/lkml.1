Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912Ab0AASRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0AASRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 13:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696Ab0AASRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 13:17:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38801 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0AASRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 13:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Ang10AfKJrsHR7IZ6P+3Ls2gsOOamCMT4c/nYGSqIuI/HjR+k01kU+84AfVuh+Qs98
         nMpnpM/DDGIX0CEkieh54An82+p12mp+yt8M63nqP8U0GpsE4H+ogCXkcIgAlCb+WC7O
         se/6lLJhWbcLrs8mhyQmKv/7j0oQsXm+TpI6U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] HVSI: Fix apparently backwards args to time_before() in hvsi.c
Date: Fri, 1 Jan 2010 19:15:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <alpine.LFD.2.00.1001011226020.24958@localhost>
In-Reply-To: <alpine.LFD.2.00.1001011226020.24958@localhost>
MIME-Version: 1.0
Message-Id: <201001011915.47849.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010 06:28:03 pm Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   no appropriate subsystem maintainer listed in MAINTAINERS.

drivers/char/Makefile:
obj-$(CONFIG_HVC_CONSOLE)       += hvc_vio.o hvsi.o

so it should belong to:

HYPERVISOR VIRTUAL CONSOLE DRIVER
L:      linuxppc-dev@ozlabs.org
S:      Odd Fixes
F:      drivers/char/hvc_*

[ Though maybe Ben would be willing to pick this one up directly
  as hvsi is PPC specific thingy and patch is obviously correct. ]

> diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
> index 793b236..71c0fcd 100644
> --- a/drivers/char/hvsi.c
> +++ b/drivers/char/hvsi.c
> @@ -711,7 +711,7 @@ static void hvsi_drain_input(struct hvsi_struct *hp)
>  	uint8_t buf[HVSI_MAX_READ] __ALIGNED__;
>  	unsigned long end_jiffies = jiffies + HVSI_TIMEOUT;
> 
> -	while (time_before(end_jiffies, jiffies))
> +	while (time_before(jiffies, end_jiffies))
>  		if (0 == hvsi_read(hp, buf, HVSI_MAX_READ))
>  			break;
>  }

--
Bartlomiej Zolnierkiewicz
