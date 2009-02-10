Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZBJUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZBJUYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZBJUYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:24:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50654 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZBJUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:24:37 -0500
Date: Tue, 10 Feb 2009 21:24:29 +0100
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
       alan@lxorguk.ukuu.org.uk, Corentin Chary <corentincj@iksaif.net>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 33/41] asus-laptop: Fix the led behavior with value > 1
Message-ID: <20090210202429.GC1382@ucw.cz>
References: <20090204184029.881610776@mini.kroah.org> <20090204184654.GH25246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204184654.GH25246@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-04 10:46:54, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Corentin Chary <corentincj@iksaif.net>
> 
> commit e3deda9c87ac5eef2b5d18cd0b5511370979ca26 upstream.
> 
> Fix http://bugzilla.kernel.org/show_bug.cgi?id=11613 .
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/misc/asus-laptop.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/misc/asus-laptop.c
> +++ b/drivers/misc/asus-laptop.c
> @@ -351,7 +351,7 @@ static void write_status(acpi_handle han
>  	static void object##_led_set(struct led_classdev *led_cdev,	\
>  				     enum led_brightness value)		\
>  	{								\
> -		object##_led_wk = value;				\
> +		object##_led_wk = (value > 0) ? 1 : 0;			\

"= !!value" is standard  way to do that.... for unsigned value.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
