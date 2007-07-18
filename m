Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXGRGPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXGRGPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXGRGPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:15:39 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61045 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010AbXGRGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:15:39 -0400
Date: Wed, 18 Jul 2007 08:15:36 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: cbe-oss-dev@ozlabs.org, "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@infradead.org>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: fbdev: make fb_append_extra_logo() depend on fb=y
In-Reply-To: <200707180052.04659.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0707180811580.18423@pademelon.sonytel.be>
References: <20070716135550.010775000@pademelon.sonytel.be>
 <20070716135950.895120000@pademelon.sonytel.be> <200707180052.04659.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1929967979-1184739308=:18423"
Content-ID: <Pine.LNX.4.62.0707180815110.18423@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1929967979-1184739308=:18423
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707180815111.18423@pademelon.sonytel.be>

On Wed, 18 Jul 2007, Arnd Bergmann wrote:
> We can't show the extra logo from boot code if FB is built as
> a module. Make the FB_LOGO_EXTRA depend on FB=y.

Bummer...

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> Reported by Al Viro. I don't know how this ended up in the final
> patch, as I'm pretty sure we talked about this scenario before
> and had a solution...

It happened because introducing CONFIG_FB_LOGO_EXTRA was done in the last
iteration (before the code was protected by #ifdef CONFIG_FB), and I got
bitten by the weird Kconfig logic again.

> diff --git a/drivers/video/logo/Kconfig b/drivers/video/logo/Kconfig
> index da219c0..9de1c11 100644
> --- a/drivers/video/logo/Kconfig
> +++ b/drivers/video/logo/Kconfig
> @@ -12,7 +12,7 @@ if LOGO
>  
>  config FB_LOGO_EXTRA
>  	bool
> -	depends on FB
> +	depends on FB=y
>  	default y if SPU_BASE
>  
>  config LOGO_LINUX_MONO

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1929967979-1184739308=:18423--
