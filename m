Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYIYJSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYIYJSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYIYJSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:18:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYIYJSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:18:35 -0400
Message-ID: <48DB5610.4020208@zytor.com>
Date: Thu, 25 Sep 2008 02:12:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: spock@gentoo.org
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       krzysztof.h1@poczta.fm, Andrew Morton <akpm@linux-foundation.org>,
       bonbons@linux-vserver.org
Subject: Re: [PATCH v2] fbdev: ignore VESA modes if framebuffer does not	support
 them
References: <20080924190832.GA19141@spock.one.pl>
In-Reply-To: <20080924190832.GA19141@spock.one.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Januszewski wrote:
> Currently, it is possible to set a graphics VESA mode at boot time via
> the vga= parameter even when no framebuffer driver supporting this is
> configured.  This could lead to the system booting with a black screen,
> without a usable console.
> diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
> index 1ee2c05..20fdc2f 100644
> --- a/include/linux/screen_info.h
> +++ b/include/linux/screen_info.h
> @@ -76,6 +76,10 @@ extern struct screen_info screen_info;
>  #define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
>  #define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
>  #define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
> +
> +#define FB_SUPPORTS_BOOT_VESA (defined(CONFIG_FB_VESA) || \
> +		defined(CONFIG_FB_SIS) || defined(CONFIG_FB_IMAC) || \
> +		defined(CONFIG_FB_INTEL))
>  #endif /* __KERNEL__ */
>  
>  #endif /* _SCREEN_INFO_H */

I'm *REALLY* skeptical to burying this in screen_info like this, it 
would probably be better to put it in Kconfig, or it is unlikely to get 
updated properly.

	-hpa
