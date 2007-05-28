Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXE1U5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXE1U5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbXE1U5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:57:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:43086 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbXE1U5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nv5ACbeUX6OXnWYM2Q10cEAgThjUIsN4wcEa2lWB4Z81oAD9ZukkGFuE15giH4tOVchHFUcJxRWk76goA2A5UGp6y16qSQWBMsYKf6VzMkfVNSMByZUf6ImlDQDdwkgYqstsSviUto6dBo2+Z1fIQuL8mHeq4ijF+w+TrdX6JGQ=
Message-ID: <9e4733910705281357x592f0853re9492efdb5ef82e8@mail.gmail.com>
Date: Mon, 28 May 2007 16:57:37 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <20070528201213.GA5840@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <465228E2.1030405@garzik.org>
	 <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
	 <200705211856.56228.jbarnes@virtuousgeek.org>
	 <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
	 <21d7e9970705220735j37bc8eeck87db7193c08c4c24@mail.gmail.com>
	 <9e4733910705220813i479a68faxf365697962317c60@mail.gmail.com>
	 <21d7e9970705221025r2f798dc5x310947db040c6521@mail.gmail.com>
	 <9e4733910705221258v660d8f42j16cc596ca820e8b8@mail.gmail.com>
	 <20070528201213.GA5840@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > >> These are not isolated problems. Linux needs a
> > >properly designed
> > >> graphics subsystem. One way to achieve that is to
> > >design it all on
> > >> paper first so that we can try and locate the
> > >interactions between
> > >> modules. For example the current mode setting design
> > >is definitely
> > >> broken for multi-seat support, that's because you
> > >didn't take that
> > >> feature into account when writing the code.
> > >
> > >No it isn't the code Jesse posted can handle multi-seat
> > >fine in the
> > >areas that it makes sense as we've pointed out to you
> > >you cannot just
> >
> > The code doesn't create one device per CRTC. Missing
> > that feature
> > means that we need a persistent root priv app around
> > that owns the
> > single device and then listens for messages from each
> > seat asking it
> > to do things. That root priv app is not necessary, it is
> > a security
> > risk and it should be eliminated.
>
> Fine, submit a patch. But don't block other people patches just
> because they do not address your favourite problem.

I have already implemented this once and submitted a patch.

Search in the paper for this paragraph:
http://jonsmirl.googlepages.com/graphics.html
DRM also implements the concept of a master user with more
capabilities than normal users. These extra capabilities allow the
graphics device to be initialized and the consumption of GPU resources
to be controlled. The current X server, which runs as root, functions
as the DRM master. There is actually no real requirement that the DRM
master be run as root, and there is a preliminary patch that removes
this requirement.

That paragraphs contains a link to the code that used to be hosted at
freedesktop.org. Maybe they can still find it.

-- 
Jon Smirl
jonsmirl@gmail.com
