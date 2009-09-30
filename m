Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZI3VWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZI3VWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZI3VWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:22:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50607 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZI3VWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xQjLEfDx8pE7A9txFp1s8ahgyg5IiWwNnBXPgSDtEM1PVUIp05HV9NAdmigMFN8m6l
         8wCEIcDvkhl4WJy6HZeiV/qwDPjwEaGTprufpDKuLNUGxU6LhLuyjwtCXaJ9O+ew5AKc
         6MSh+JR3Q9AYMuG2BeKv22oiCzSiPSVCakQ6A=
Date: Wed, 30 Sep 2009 23:22:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Feuerer <peter@piie.net>, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: Limit modalias matching to supported boards
Message-ID: <20090930212233.GB17712@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Peter Feuerer <peter@piie.net>,
	Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org
References: <4AC34B83.6090402@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AC34B83.6090402@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:13:55PM +0200, Stefan Bader wrote:
> We got reports of acerhdf issuing warnings on Acer laptops other
> than Aspire Ones. Looking at the dmi match this sounds a bit to
> generic. IOW the module gets loaded on any Acer laptop. After the
> following patch the module gets still loaded on my Aspire One but
> not on the reported other laptop.
> The same change might be helpful for the other two dmi matches, but
> I had no way of testing.

Yeah, we might need someone with such a machine to give us
/sys/class/dmi/id/modalias content. Peter, do you have any users with
such machines?

> From 389f61f7e66ce615dc6418cb856e167edaa74b42 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Mon, 28 Sep 2009 17:11:29 +0000
> Subject: [PATCH] UBUNTU: acerhdf: Limit modalias matching to supported boards
> 
> BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958
> 
> The module alias currently matches any Acer computer but when loaded the
> BIOS checks will only succeed on Aspire One models. This causes a invalid
> BIOS warning for all other models (seen on Aspire 4810T).
> This is not fatal but worries users that see this message. Limiting the
> moule alias to models starting with AOA. Probably the same change should be
> made for the two other entries.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

> ---
>  drivers/platform/x86/acerhdf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index aa298d6..763f233 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -629,7 +629,7 @@ static void __exit acerhdf_exit(void)
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Peter Feuerer");
>  MODULE_DESCRIPTION("Aspire One temperature and fan driver");
> -MODULE_ALIAS("dmi:*:*Acer*:*:");
> +MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
>  MODULE_ALIAS("dmi:*:*Gateway*:*:");
>  MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
>  
> -- 
> 1.5.4.5
> 


-- 
Regards/Gruss,
    Boris.
