Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZA3JOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZA3JOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZA3JNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:13:48 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41967 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZA3JNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:13:47 -0500
Subject: Re: [PATCH] w35und: fix registration with wlan stack
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@suse.cz>
Cc: Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Bruno Randolf <br1@einfach.org>
In-Reply-To: <20090130090525.GA1997@elf.ucw.cz>
References: <497E1F3A.1060604@cs.helsinki.fi> <497E2EC4.5030302@gmail.com>
	 <497E35A1.8080301@cs.helsinki.fi> <497F5FEA.7020203@gmail.com>
	 <20090127200602.GA16444@elf.ucw.cz> <4980B2DD.307@gmail.com>
	 <4980BB9A.2020309@cs.helsinki.fi> <4980C028.2030709@gmail.com>
	 <4980C035.4070105@cs.helsinki.fi> <4980DB5D.6010906@gmail.com>
	 <20090130090525.GA1997@elf.ucw.cz>
Date: Fri, 30 Jan 2009 11:13:44 +0200
Message-Id: <1233306825.13655.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 10:05 +0100, Pavel Machek wrote:
> Initialize few more fields in wireless device structure so that
> wireless core actually accepts our registration.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Looking at the changes, lets see if we can get some more review on this:

> ---
> commit 87290671d60a4f0e734f389a266b13d71c275ce4
> tree c8e312a3ef0b0d250c1e605ce86bff94c0254847
> parent e6de9be58f118cba6ccfef28830db701b8cc9f46
> author Pavel <pavel@suse.cz> Fri, 30 Jan 2009 09:08:36 +0100
> committer Pavel <pavel@suse.cz> Fri, 30 Jan 2009 09:08:36 +0100
> 
>  drivers/staging/winbond/wbusb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index b003f9a..49f1bf0 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -369,9 +369,11 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
>  	}
>  
>  	dev->extra_tx_headroom = 12;	/* FIXME */
> -	dev->flags = 0;
> +	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
> +	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);

The wiphy->interface_modes thing is probably fall-out from commit
8dffff216fcac4f79078478085e86d68db64922e ("mac80211: only create default
STA interface if supported"). I'm cc'ing Johannes.

>  
>  	dev->channel_change_time = 1000;
> +	dev->max_signal = 100;

And the IEEE80211_HW_SIGNAL_UNSPEC and ->max_signal from commit
566bfe5a8bcde13188a356f77666f8115813cf31 ("mac80211: use hardware flags
for signal/noise units"). Lets cc Bruno.

>  	dev->queues = 1;
>  
>  	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &wbsoft_band_2GHz;

