Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0BVUY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:24:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab0BVUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:24:24 -0500
Date: Mon, 22 Feb 2010 12:23:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: radeonfb backlight fix
Message-Id: <20100222122354.50a85575.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1002161817570.23940@casper.infradead.org>
References: <alpine.LFD.2.00.1002161817570.23940@casper.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 18:19:21 +0000 (GMT) James Simmons <jsimmons@infradead.org> wrote:

> 
> A simple patch to allow radeonfb to compile if the backlight option is 
> set.
> 
> diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
> index 6c37e8e..2c01726 100644
> --- a/drivers/video/aty/radeon_base.c
> +++ b/drivers/video/aty/radeon_base.c
> @@ -276,7 +276,7 @@ static int nomtrr = 0;
>  #endif
>  static int force_sleep;
>  static int ignore_devlist;
> -#ifdef CONFIG_PMAC_BACKLIGHT
> +#ifdef CONFIG_FB_RADEON_BACKLIGHT
>  static int backlight = 1;
>  #else
>  static int backlight = 0;

Changelog is very poor.  It doesn't tell us what the error was, nor how
the patch fixes it.

I attempted to reverse-engineer the patch but gave up.

radeonfb_bl_init() is omitted from the link if
CONFIG_FB_RADEON_BACKLIGHT=n.  And this code:

	if (backlight)
		radeonfb_bl_init(rinfo);

will emit a call to radeonfb_bl_init() regardless of the value of
`backlight', so as far as I can tell, there will be a linkage error
with CONFIG_FB_RADEON_BACKLIGHT=n both before and after your patch.

So.  Please resend, with a proper description.  And a Signed-off-by: line.
