Return-Path: <linux-kernel-owner+w=401wt.eu-S1765694AbXLQXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765694AbXLQXMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbXLQXMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:12:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:19335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761339AbXLQXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y6c3PHTU0bIt12ZM7f1KvmUAXhgI0LefjgIgYRHG6ajsS3Kit7bMgnnYSkg8dHbxN3+bMPESjLqyI1xj3i7S/3zyDj96Nvkt12CKQhiffnd8hjVk/PfeVuAUFYQGu2KRX8tK4uwQKbU7fbXodBAo/IPy6oVB5O9bAFFRVEUHS4A=
Message-ID: <520b60a90712171512vcab7fb6of7732466ccb85996@mail.gmail.com>
Date: Mon, 17 Dec 2007 18:12:30 -0500
From: mvtodevnull@gmail.com
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712172345.20710.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <520b60a90712170235p4c0bc0f5ybf64da0853f06d6@mail.gmail.com>
	 <520b60a90712171404v647d3d62h69e61d223040779b@mail.gmail.com>
	 <200712172345.20710.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 5:45 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> Ehm, excuse me.
> What are you doing exactly? In this thread you told me you have
> a device which requires b43:
>

Well, I'm not sure what you mean by "requires" b43, but I did say that
the device uses the b43 driver.

> > I don't know what happened before, but after a reboot, I can't repeat
> > the 200 kB/s speed. It's back down to 40 kB/s, just like originally. I
> > didn't move the laptop, or the ap, the only thing I can think of that
> > might have changed is the noise level. FWIW, link quality is
> > consistently the same or better with b43.
>
> How the hell can you now "force it to use b43legacy"??
>

Sorry, I should have been more specific. I figured since the device
could use bcm43xx, it could also use b43legacy, so I copied the
entries in b43_ssb_tbl[] to b43legacy_ssb_tbl[] and rebuilt the
b43legacy driver. I removed the b43 and ssb modules, and inserted the
b43legacy module. Afterwards, I noticed b43 had still been autoloaded,
so I removed it (I checked dmesg and only b43legacy had initialized
anyway) , and proceeded to use the b43legacy driver with the version 3
firmware. And like I said, it works exactly like the b43 driver with
the version 4 firmware.

I'm not sure if it was the best way to go about it, but it worked.
