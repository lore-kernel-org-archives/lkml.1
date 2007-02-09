Return-Path: <linux-kernel-owner+w=401wt.eu-S2992453AbXBIRsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992453AbXBIRsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992456AbXBIRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:48:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:47525 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992453AbXBIRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r3rJK1HG8WHTr6WIi34yewl2CAt7tmDigodnoNqdObKKevUpinBKbIcqpYILU925lEUd+cmUV+MuozIuEt5SuYQP4XS6FdGLPz5fRUCrj5HDOAxcshAMjLQggl81O4PbfYGaaqbZR9rzLfHtdIVYgPp7Jm8CJX5HP9db4GM/d2s=
Message-ID: <512afbf90702090948v403b6e2fmedfb938645415928@mail.gmail.com>
Date: Fri, 9 Feb 2007 09:48:10 -0800
From: "Kristen Accardi" <kristen.kml@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] wrong order of kzalloc arguments
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1HFYFH-0004qI-0v@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HFYFH-0004qI-0v@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/acpi/bay.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
> index 667fa1d..91082ce 100644
> --- a/drivers/acpi/bay.c
> +++ b/drivers/acpi/bay.c
> @@ -296,7 +296,7 @@ static int bay_add(acpi_handle handle, int id)
>         /*
>          * Initialize bay device structure
>          */
> -       new_bay = kzalloc(GFP_ATOMIC, sizeof(*new_bay));
> +       new_bay = kzalloc(sizeof(*new_bay), GFP_ATOMIC);
>         INIT_LIST_HEAD(&new_bay->list);
>         new_bay->handle = handle;
>         new_bay->name = (char *)nbuffer.pointer;
> --
> 1.5.0-rc2.GIT
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Oops.  thanks for taking the time to review and fix this.

Kristen
