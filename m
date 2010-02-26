Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555Ab0BZIPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:15:24 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65141 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kQ3htwSyR5/gVs+9rFdEArTumDQvHFmE3MnJNpUC3HowhiiGpN3i8mjNb79Mes/OYg
         ERixteQjuH7e2/3qRjdZU6LwBzYTRISM7IzJRqHlDw6/MGGHzozLSQbYE3phqHZn3Wb4
         xDKMNs37o/RTh8TAF9KF5+cjCPhWDOYDIR0XQ=
Date: Fri, 26 Feb 2010 00:15:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Message-ID: <20100226081514.GB17444@core.coreip.homeip.net>
References: <20100221002001.0a7e05a7@neptune.home>
 <20100224170049.0d04af3c@neptune.home>
 <alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:07:38PM +0100, Jiri Kosina wrote:
> On Wed, 24 Feb 2010, Bruno Prémont wrote:
> 
> > +/* Update fb_vbitmap from the screen_base and send changed tiles to device */
> > +static void picolcd_fb_update(struct picolcd_data *data)
> > +{
> > +	int chip, tile;
> > +
> > +	spin_lock(&data->lock);
> > +	if (!(data->status & PICOLCD_READY_FB)) {
> > +		spin_unlock(&data->lock);
> > +		picolcd_fb_reset(data->hdev, 0);
> > +	} else
> > +		spin_unlock(&data->lock);
> 
> Please put the brackets to the else branch as well.
> 
Well, it looks like it can be rewritten as:

	spin_lock(&data->lock);
	need_reset = !(data->status & PICOLCD_READY_FB);
	spin_unlock(&data->lock);

	if (need_reset)
		picolcd_fb_reset(data->hdev, 0);

Which plainly shows that the locking here is bogus.

-- 
Dmitry
