Return-Path: <linux-kernel-owner+w=401wt.eu-S1764806AbXJONYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764806AbXJONYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760852AbXJONY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:24:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:22262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbXJONYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uYpsdSVsI0y1qMJNbNmPDiCnw0jzbZ9qqZKtyqyXDlJs1HXyGGtfUuukn6/FApLA03vkjJuuzWzMmjYYzkbxrd6nJpvLodxEWidMQiJOJBYKjzSehwwYe4C3aB8m4FSKgZhiDPYYAcLivLIwBdIDDgtMzXfFdfZmDCo4i3D7NwE=
Message-ID: <d120d5000710150624p25a87bb0k19e21b8bec914be2@mail.gmail.com>
Date: Mon, 15 Oct 2007 09:24:23 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [patch 1/8] m68k: Atari input drivers cleanup
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       "Michael Schmitz" <schmitz@biophys.uni-duesseldorf.de>
In-Reply-To: <20071013123412.197946192@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071013123123.085686856@mail.of.borg>
	 <20071013123412.197946192@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 10/13/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> m68k: Atari input drivers cleanup:
>  - memleak on failed init/register of input devices fixed
>  - correct keycodes table (Atari keycodes are almost, but not entirely, equal
>    to Linux keycodes).
>
> Signed-off-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Looks much better, thank you.

>
> -       input_register_device(atakbd_dev);
> +       /* error check */
> +       if (input_register_device(atakbd_dev)) {
> +               input_free_device(atakbd_dev);
> +               return -ENOMEM;
> +       }
>

I'd be more happy if we returned real error reported by
input_register_device() instead of substituting it with -ENOMEM.

-- 
Dmitry
