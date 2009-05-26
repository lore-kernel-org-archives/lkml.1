Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZEZAUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZEZAUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZEZAUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:20:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:33751 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZEZAUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Snvn358Z+qiFm5ZSSx696fhWo8vufMIALC5iuusmfAnBrW4kqa/c3bSCIlQSX2xUvp
         xLPNohaTYnWzo5XAWYRRdZ2K7Mk6ZvgISRppiSWlfcy5BpFi7FJseNUkQVSZS6SsBTSu
         xoLsv85hgDxtfOHDYAJQDtza4VZ0JKxHCYxIM=
MIME-Version: 1.0
Reply-To: mark.asselstine@windriver.com
In-Reply-To: <5c43c2d40905220627g4036fd80n6f0ef8469e48aa1f@mail.gmail.com>
References: <5c43c2d40905220627g4036fd80n6f0ef8469e48aa1f@mail.gmail.com>
Date: Mon, 25 May 2009 20:20:04 -0400
X-Google-Sender-Auth: 6c4b627cc785c5f4
Message-ID: <919fe2b30905251720n24837f56xf24a93ca7bdf89ae@mail.gmail.com>
Subject: Re: [PATCH] oss: Remove void casts
From: Mark Asselstine <mark.asselstine@windriver.com>
To: =?ISO-8859-1?Q?Andr=E9_Lopes?= <andre.neo.net@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       askulysh@image.kiev.ua
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/22 André Lopes <andre.neo.net@gmail.com>:
> This trivial patch just remove void cats from sound/oss/sh_dac_audio.c

darn cats got out again :P

s/void cats/void pointer casts/

Regards,
Mark

>
> Signed-off-by: André Lopes <andre.neo.net@gmail.com>
>
> ---
>  sound/oss/sh_dac_audio.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
> index 78cfb66..7247ea1 100755
> --- a/sound/oss/sh_dac_audio.c
> +++ b/sound/oss/sh_dac_audio.c
> @@ -200,21 +200,21 @@ static ssize_t dac_audio_write(struct file
> *file, const char *buf, size_t count,
>        if (count > free)
>                count = free;
>        if (buffer_begin > buffer_end) {
> -               if (copy_from_user((void *)buffer_end, buf, count))
> +               if (copy_from_user(buffer_end, buf, count))
>                        return -EFAULT;
>
>                buffer_end += count;
>        } else {
>                nbytes = data_buffer + BUFFER_SIZE - buffer_end;
>                if (nbytes > count) {
> -                       if (copy_from_user((void *)buffer_end, buf, count))
> +                       if (copy_from_user(buffer_end, buf, count))
>                                return -EFAULT;
>                        buffer_end += count;
>                } else {
> -                       if (copy_from_user((void *)buffer_end, buf, nbytes))
> +                       if (copy_from_user(buffer_end, buf, nbytes))
>                                return -EFAULT;
>                        if (copy_from_user
> -                           ((void *)data_buffer, buf + nbytes, count - nbytes))
> +                           (data_buffer, buf + nbytes, count - nbytes))
>                                return -EFAULT;
>                        buffer_end = data_buffer + count - nbytes;
>                }
> @@ -322,7 +322,7 @@ static void __exit dac_audio_exit(void)
>        free_irq(TIMER1_IRQ, 0);
>
>        unregister_sound_dsp(device_major);
> -       kfree((void *)data_buffer);
> +       kfree(data_buffer);
>  }
>
>  module_init(dac_audio_init);
> --
> 1.5.6.5
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
