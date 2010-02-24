Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0BXPeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:34:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34640 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab0BXPeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:34:14 -0500
Date: Wed, 24 Feb 2010 16:33:56 +0100
From: Anisse Astier <anisse@astier.eu>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>,
       Matt Chen <machen@novell.com>, Harald Welte <laforge@gnumonks.org>,
       Martin Lucina <mato@kotelna.sk>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       pancho horrillo <pancho@pancho.name>,
       Mike Frysinger <vapier@gentoo.org>,
       Vivek Kutal <vivek.kutal@azingo.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/3] backlight: fix missing/incomplete registration
 failure handling
Message-ID: <20100224163356.7e8c4464@destiny.ordissimo>
In-Reply-To: <20100221133528.GB1840@holoscopio.com>
References: <20100221001049.2f63f5d6@neptune.home>
	<20100221002831.689bace8@neptune.home>
	<20100221133528.GB1840@holoscopio.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010 10:35:29 -0300, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote :

> On Sun, Feb 21, 2010 at 12:28:31AM +0100, Bruno Prémont wrote:
> > Check newly registered backlight_device for error and properly
> > return error to parent
> > 
> > Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> > ---
> >  drivers/platform/x86/classmate-laptop.c |    2 ++
> >  drivers/platform/x86/msi-wmi.c          |    4 +++-
> >  drivers/platform/x86/panasonic-laptop.c |    4 +++-
> >  drivers/usb/misc/appledisplay.c         |    1 +
> >  drivers/video/bf54x-lq043fb.c           |    8 ++++++++
> >  drivers/video/bfin-t350mcqb-fb.c        |    8 ++++++++
> >  6 files changed, 25 insertions(+), 2 deletions(-)
> > 
> 
> I think you should split the patch for every driver. Then, every
> mantainer may ack only its particular section of the patch.
> 

I agree.

> > diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
> > index 5f7cff1..2ffbfcf 100644
> > --- a/drivers/platform/x86/msi-wmi.c
> > +++ b/drivers/platform/x86/msi-wmi.c
> > @@ -251,8 +251,10 @@ static int __init msi_wmi_init(void)
> >  	if (!acpi_video_backlight_support()) {
> >  		backlight = backlight_device_register(DRV_NAME,
> >  				NULL, NULL, &msi_backlight_ops);
> > -		if (IS_ERR(backlight))
> > +		if (IS_ERR(backlight)) {
> > +			err = PTR_ERR(backlight);
> >  			goto err_free_input;
> > +		}
> >  
> >  		backlight->props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
> >  		err = bl_get(NULL);

Anyway, the msi-wmi part looks good to me.


Anisse
