Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYLMN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYLMN2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYLMN2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:28:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:60724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYLMN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dHbm9eqZ8hLZsJJnI+2fbJo6nccoWOesSb/avjcPxGq9tAYbpGb7ryhn6ij6MR7IZM
         vFR+DmGz7Zyb79lF98awtJmfv81UubcKf7/afrNaiRGigJ5LwaCU6/YaltotgjJjVcWL
         UTfAQFPIasRPORD0PWdYDu6n6f3GyBxdJYp0M=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:28:24 +0200
Message-Id: <1229174904.4964.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 00:12 +0200, Nick Kossifidis wrote:
> 2008/11/10 Maxim Levitsky <maximlevitsky@gmail.com>:
> > Bob Copeland wrote:
> >> On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
> >>> default in ubuntu...
> >>> wireless more or less works, but kernel log is full of backtraces.
> >>
> >> As you've seen, these should at least be gone now...
> >>
> >>> Was able to connect to my WPA2 access point.
> >>> Sometimes wireless fails completely, especially after suspend to ram.
> >>
> >> Did you get noise calibration failures in dmesg at this point?  Felix posted
> >> a patch recently that handles them better.
> > Yep, but they seems to be gone in latest -git too.
> > Wireless work fine now, it seems like my iwl3945.
> >
> >>
> >>> Advanced features like monitor/injection work, but when I changed the card's
> >>> mac address it stopped working.
> >>> I also noticed that if I then start airodump, then wireless works with new
> >>> mac.
> > Why it doesn't accept new mac?, can this be fixed?
> >
> >
> >>
> >>> ** 4 - wireless led doesn't work.
> >>> ath5k devs, can you fix this?
> >>
> >> Currently all the LED code we have in there is for setting a particular gpio
> >> for particular laptops (and they differ between models).  We only have quirks
> >> for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
> >> strategy for 2425 chips.  I can try to hack up some code for you to test.
> >>
> >
> > I have seen on the web that madwifi did support the led with some gpio settings
> >
> > sysctl -w dev.wifi0.ledpin=3
> > sysctl -w dev.wifi0.softled=1
> >
> > from https://help.ubuntu.com/community/AspireOne
> >
> > Best regards,
> >        Maxim Levitsky
> 
> i think that some led settings are stored on EEPROM, let me check it out...


Hi,

Indeed gpio #3 controls the led.
I patched ath5k to use it, and led works now fine.


What I dislike is the way led blinks:

While nether I like constant rate blinking implemented in windows
driver, I don't like the fact that led blinks too fast, sometimes the
blink time is so short that led doesn't show full brightness.

I think there should be a minimal interval for blinking.

Also I don't know what is assumed better, when led is always on, but
turns off when active of vise versa?
(Due to short intervals, when I set it for first option, it is almost
always on, and I almost don't see the interval when it is off)


Best regards,
	Maxim Levitsky





