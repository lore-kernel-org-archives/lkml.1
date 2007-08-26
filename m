Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXHZQFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXHZQFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXHZQFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:05:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58360 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbXHZQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:05:07 -0400
X-Greylist: delayed 1727 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 12:05:06 EDT
Date: Sun, 26 Aug 2007 18:36:18 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] atyfb: remove dead code
Message-ID: <20070826153618.GB6003@sci.fi>
Mail-Followup-To: Olaf Hering <olaf@aepfle.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
References: <20070826091237.GA17667@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070826091237.GA17667@aepfle.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2007 at 11:12:37AM +0200, Olaf Hering wrote:
> Remove dead code.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  drivers/video/aty/atyfb_base.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- a/drivers/video/aty/atyfb_base.c
> +++ b/drivers/video/aty/atyfb_base.c
> @@ -2767,8 +2767,7 @@ static int atyfb_blank(int blank, struct
>  	if (par->lock_blank || par->asleep)
>  		return 0;
>  
> -#ifdef CONFIG_FB_ATY_BACKLIGHT
> -#elif defined(CONFIG_FB_ATY_GENERIC_LCD)
> +#ifdef CONFIG_FB_ATY_GENERIC_LCD
>  	if (par->lcd_table && blank > FB_BLANK_NORMAL &&
>  	    (aty_ld_lcd(LCD_GEN_CNTL, par) & LCD_ON)) {
>  		u32 pm = aty_ld_lcd(POWER_MANAGEMENT, par);

This will change the behavior of the code. I basically agree with the
change because the current code will not control the backlight when the
kernel is built with CONFIG_FB_ATY_BACKLIGHT but the system doesn't
support the backlight interface (ie. non-pmac system). However someone
should check that it doesn't cause problems for pmac users.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
