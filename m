Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZBJVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZBJVsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZBJVsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:48:35 -0500
Received: from mx1.suse.de ([195.135.220.2]:42933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZBJVse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:48:34 -0500
Date: Tue, 10 Feb 2009 12:57:52 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@suse.cz>
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
Message-ID: <20090210205752.GA3044@suse.de>
References: <20090204184029.881610776@mini.kroah.org> <20090204184654.GH25246@kroah.com> <20090210202429.GC1382@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210202429.GC1382@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 09:24:29PM +0100, Pavel Machek wrote:
> On Wed 2009-02-04 10:46:54, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Corentin Chary <corentincj@iksaif.net>
> > 
> > commit e3deda9c87ac5eef2b5d18cd0b5511370979ca26 upstream.
> > 
> > Fix http://bugzilla.kernel.org/show_bug.cgi?id=11613 .
> > 
> > Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Cc: Thomas Renninger <trenn@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/misc/asus-laptop.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/misc/asus-laptop.c
> > +++ b/drivers/misc/asus-laptop.c
> > @@ -351,7 +351,7 @@ static void write_status(acpi_handle han
> >  	static void object##_led_set(struct led_classdev *led_cdev,	\
> >  				     enum led_brightness value)		\
> >  	{								\
> > -		object##_led_wk = value;				\
> > +		object##_led_wk = (value > 0) ? 1 : 0;			\
> 
> "= !!value" is standard  way to do that.... for unsigned value.

No dispute here, but that's what is upstream :)

thanks,

greg k-h
