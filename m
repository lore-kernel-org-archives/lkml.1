Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXF2KbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXF2KbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 06:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXF2Ka6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 06:30:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:48341 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756196AbXF2Ka5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 06:30:57 -0400
X-Authenticated: #4399952
X-Provags-ID: V01U2FsdGVkX1/g7CVuv5bgKD7Lal1oft/+ydTYWvS/z2GgURgq2D
	oiwZLNGhBQji0I
From: Florian Schmidt <mista.tapas@gmx.net>
To: Anton Petrusevich <casus@casus.us>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Fri, 29 Jun 2007 12:30:54 +0200
User-Agent: KMail/1.9.6
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       alsa-devel@lists.sourceforge.net
References: <200706281442.05239.casus@casus.us> <4683CD9F.5030202@gmail.com> <200706281834.16564.casus@casus.us>
In-Reply-To: <200706281834.16564.casus@casus.us>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?utf-8?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291230.54175.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007, Anton Petrusevich wrote:
> > > I have ICE1724, a very good sound card to my taste, works like a charm.
> > > But with ALSA I had a really hard time to configure it properly, wanna
> > > see my .asoundrc?
> >
> > Not particularly. I don't count as a great fan of the config file syntax
> > and don't use any configuration myself.
>
> Do you have an SPDIF out? If you don't then you don't need .asoundrc of
> course.

With  a properly coded ALSA app, one doesn't need a .asoundrc. You would 
enter "plug:spdif" [or something similar] into the pcm device name entry text 
field.

Or if you want to point all apps to that device you actually could add this to 
your .asoundrc:

pcm.!default {
	type plug
	slace.pcm "spdif"
}

[or something similar. Too lazy to look up the exact syntax now]. And then 
every app using the ALSA API _correctly_ should use that device [if 
configured to use the default device, which should be the _default_ ;)]

Sadly it seems pretty much everyone, especially closed source apps get this 
wrong (but to be fair: loads of open source software gets it wrong, too, 
ekiga for example).

What they do wrong is that they try to present a list of devices to the user 
from which he can choose [which isn't bad in itself] and also do _not_ offer 
any way to specify an arbitrary PCM device name.

Sadly, the ALSA api docs do not stress this point often enough, so it gets 
missed pretty often.

I once posted an [not original, i suppose people before me got that idea, too] 
idea to the alsa-dev list a while back, proposing a way to be able 
to "register" pcm devices defined in .asoundrc/asound.conf, so that apps that 
want to present a list to the user can simply ask ALSA for a list of devices 
nd hav the user defined ones included. Sadly i don't think it ever went 
anywhere..

> Because I want to route it differently, sometimes to spdif, sometimes to
> headphones, sometimes to mix sounds from different apps. Well, my config
> may be a bit ancient as it was written when dmix was not default.

Well, like i said, the application in question should allow you to enter any 
pcm name you want. If it doesn't it's broken.

> I have read some advices for ice1724 already. The main reason I wrote to
> lkml -- I hate .asounrc and reading docs about it. I hate "flexebility"
> that requires restarting apps after changing sound routes.

I own a ice1712, too, but i only use it for JACK and it works brilliantly 
there. But i know it can be a bitch to configure since it sports a 10/12 
channel device which can be too complicated for some ALSA apps making 
assumptions about the device they get ;)

> I perfectly know this one. I would like to use some really user-friendly
> tool.

I don't know of any. But any text editor will do. 

> > > I want to be able to hear sound from flashplayer on my reciever or in
> > > my headphones -- how?
> >
> > Not sure? Is your receiver on an analog output and are your headphones
>
> My receiver is on spdif out.

The flashplayer has been another one of these badly coded apps ;) Maybe that 
has changed in recent releases.

> > It's not working without an .asoundrc?
>
> Looks like it's not working with. As skype is not so informative.

But skype is a piece of crap anyways. It also doesn't get any sounds out of my 
other [non ice1712] card. Neither in OSS nor in ALSA mode. Not a beep. And 
yeah, the device is available [and even has hardware multiplexing]..

> I am not about ice1724 or .asounrc here. I am trying to talk about
> user-friendliness of ALSA. It's very unfriendly.

I agree. ALSA is not very userfriendly. Especially the missing proper device 
enumeration support is a problem.

But 99.9% of problems people have with ALSA are due to badly coded apps..

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
