Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbZGNXbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbZGNXbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZGNXbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:31:52 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:65000 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZGNXbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qa6VEa5NCZFV6/eJC2024P8WXINkPjcO7ZPWVxGMkuXkv9pK7GchmOlkUfB5a72sG2
         mxek0NO/M35GUgYAQubaL+a+tV70NyLNcjb5fyCjsv96k6erkLDqPorjZ2JNK5SoxiER
         UOOiQYXvN5HtJnS+cKnjfQjZE2z9ER4oHMVDA=
MIME-Version: 1.0
In-Reply-To: <200907142228.n6EMSh1C001441@pilspetsen.it.uu.se>
References: <200907142228.n6EMSh1C001441@pilspetsen.it.uu.se>
Date: Wed, 15 Jul 2009 09:25:27 +1000
Message-ID: <21d7e9970907141625x4530dcb6o25ab6c11a65d6171@mail.gmail.com>
Subject: Re: [PATCH] DRM_RADEON should not select FB stuff
From: Dave Airlie <airlied@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 8:28 AM, Mikael Pettersson<mikpe@it.uu.se> wrote:
> Commit 771fe6b912fca54f03e8a72eb63058b582775362 changed the DRM_RADEON
> Kconfig entry to select a bunch of framebuffer options. However, the
> driver doesn't actually use any of those things, so these selects are
> bogus. This patch reverts them.
>
> I'm running this right now. drm and radeon loaded, acceleration works,
> nothing anywhere is complaining about missing the FB stuff.

NAK, the code is only enabled under staging at the moment but it will use these.

Dave.

>

> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
>
> diff -rupN linux-2.6.31-rc3/drivers/gpu/drm/Kconfig linux-2.6.31-rc3.radeon-dont-select-fb-dammit/drivers/gpu/drm/Kconfig
> --- linux-2.6.31-rc3/drivers/gpu/drm/Kconfig    2009-07-14 13:42:51.000000000 +0200
> +++ linux-2.6.31-rc3.radeon-dont-select-fb-dammit/drivers/gpu/drm/Kconfig       2009-07-14 14:03:03.000000000 +0200
> @@ -44,11 +44,6 @@ config DRM_R128
>  config DRM_RADEON
>        tristate "ATI Radeon"
>        depends on DRM && PCI
> -       select FB_CFB_FILLRECT
> -       select FB_CFB_COPYAREA
> -       select FB_CFB_IMAGEBLIT
> -       select FB
> -       select FRAMEBUFFER_CONSOLE if !EMBEDDED
>        help
>          Choose this option if you have an ATI Radeon graphics card.  There
>          are both PCI and AGP versions.  You don't need to choose this to
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
