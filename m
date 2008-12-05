Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYLEM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYLEM7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYLEM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:59:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52157 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYLEM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:59:08 -0500
Date: Fri, 5 Dec 2008 13:58:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [patch 011/104] fbdev: clean the penguins dirty feet
Message-ID: <20081205125855.GA1750@ucw.cz>
References: <20081203193901.715896543@mini.kroah.org> <20081203194838.GL8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203194838.GL8950@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed 2008-12-03 11:48:38, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Clemens Ladisch <clemens@ladisch.de>
> 
> commit cf7ee554f3a324e98181b0ea249d9d5be3a0acb8 upstream.
> 
> When booting in a direct color mode, the penguin has dirty feet, i.e.,
> some pixels have the wrong color.  This is caused by
> fb_set_logo_directpalette() which does not initialize the last 32 palette
> entries.

Heh, funny, but... is this really bad enough bug to go to stable?

									Pavel

> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/video/fbmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -232,7 +232,7 @@ static void fb_set_logo_directpalette(st
>  	greenshift = info->var.green.offset;
>  	blueshift = info->var.blue.offset;
>  
> -	for (i = 32; i < logo->clutsize; i++)
> +	for (i = 32; i < 32 + logo->clutsize; i++)
>  		palette[i] = i << redshift | i << greenshift | i << blueshift;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
