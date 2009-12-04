Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZLDAfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZLDAfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZLDAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:35:44 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:56304 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZLDAfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SrC6DWuofqmKuJtDCcUSys0K/N9xW9bnbcYQRIfM8ss8tWs+G9w0adK+2U/t0BpbCV
         riaRP10KalSlYQsKq0aYqTswyQAZmv3CMewmGx3LVpM0i9wQMYQyk9Pt4m+WUs/xOW1F
         m3FpceEvxI77BsZtJGl4aEmguBQOKCv72Va3Q=
MIME-Version: 1.0
In-Reply-To: <1259854318-16907-4-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-4-git-send-email-konrad.wilk@oracle.com>
Date: Fri, 4 Dec 2009 08:35:49 +0800
Message-ID: <45a44e480912031635t331f7433v3003dd36cfd9940@mail.gmail.com>
Subject: Re: [PATCH 3/3] fb-defio: Inhibit VM_IO flag to be set on vmalloc-ed 
	framebuffers.
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: damm@opensource.se, linux-kernel@vger.kernel.org, armbru@redhat.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 11:31 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> The framebuffers (screenbase) these drivers present are actually
> vmalloc-ed pages. There is no need for them to have the VM_IO flag set.
> ---
>  drivers/video/broadsheetfb.c |    2 +-
>  drivers/video/hecubafb.c     |    2 +-
>  drivers/video/metronomefb.c  |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
> index 509cb92..df9ccb9 100644
> --- a/drivers/video/broadsheetfb.c
> +++ b/drivers/video/broadsheetfb.c
> @@ -470,7 +470,7 @@ static int __devinit broadsheetfb_probe(struct platform_device *dev)
>        par->read_reg = broadsheet_read_reg;
>        init_waitqueue_head(&par->waitq);
>
> -       info->flags = FBINFO_FLAG_DEFAULT;
> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>
>        info->fbdefio = &broadsheetfb_defio;
>        fb_deferred_io_init(info);
> diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
> index 0b4bffb..f9d77ad 100644
> --- a/drivers/video/hecubafb.c
> +++ b/drivers/video/hecubafb.c
> @@ -253,7 +253,7 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
>        par->send_command = apollo_send_command;
>        par->send_data = apollo_send_data;
>
> -       info->flags = FBINFO_FLAG_DEFAULT;
> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>
>        info->fbdefio = &hecubafb_defio;
>        fb_deferred_io_init(info);
> diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
> index df1f757..661bfd2 100644
> --- a/drivers/video/metronomefb.c
> +++ b/drivers/video/metronomefb.c
> @@ -700,7 +700,7 @@ static int __devinit metronomefb_probe(struct platform_device *dev)
>        if (retval < 0)
>                goto err_free_irq;
>
> -       info->flags = FBINFO_FLAG_DEFAULT;
> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>
>        info->fbdefio = &metronomefb_defio;
>        fb_deferred_io_init(info);
> --
> 1.6.2.5
>
>


Looks good to me. Thanks.

Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
