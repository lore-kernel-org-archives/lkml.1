Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750Ab0AGDrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0AGDrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731Ab0AGDrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:47:10 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:48422 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0AGDrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FbkhxOKDjmTkCPZIAjY6mzrcsGAz1ubwUbaLIzUtYViDw2Yz5Q1e1KoDwHg6w8XYJG
         i/LAg+RM6I1AjV2F9+ILCYbdpjrXCtrIREh1z9g3cWoxxBo1azonWtipWMw8huByDXX2
         Min+UCPVPEEKLiIZsXhHx76nFBoHK0FhlJ7n8=
MIME-Version: 1.0
In-Reply-To: <1262136291.8733.35.camel@ICE-BOX>
References: <1262136291.8733.35.camel@ICE-BOX>
Date: Thu, 7 Jan 2010 13:47:07 +1000
Message-ID: <21d7e9971001061947k16ef1367k3c331a8849ce0109@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/r100.c: check for invalid family
From: Dave Airlie <airlied@gmail.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:24 AM, Darren Jenkins
<darrenrjenkins@gmail.com> wrote:
> If there is an invalid family the fw_name is NULL and causes an
> NULL pointer dereference.
> This just adds a check for something unexpected.

NAK.

This can't happen, only gpus with those families set can call this function,
so we can't get in here without the correct family, and if we did it would be
due to developer error, so oopsing is very appropriate.

Dave.

>
> Coverity CID: 13251
>
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
>
> diff --git drivers/gpu/drm/radeon/r100.c drivers/gpu/drm/radeon/r100.c
> index 7172746..e4b9770 100644
> --- drivers/gpu/drm/radeon/r100.c
> +++ drivers/gpu/drm/radeon/r100.c
> @@ -584,6 +584,8 @@ static int r100_cp_init_microcode(struct radeon_device *rdev)
>                   (rdev->family == CHIP_RV570)) {
>                DRM_INFO("Loading R500 Microcode\n");
>                fw_name = FIRMWARE_R520;
> +       } else {
> +               return -EINVAL;
>        }
>
>        err = request_firmware(&rdev->me_fw, fw_name, &pdev->dev);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
