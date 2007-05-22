Return-Path: <linux-kernel-owner+w=401wt.eu-S966205AbXEVQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966205AbXEVQCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763990AbXEVQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:02:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:38429 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185AbXEVQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m8QkhxZZhJUvHh64fOXhK+Q9csXlKqZHiPrCT5Ec0xec8gw951WQwFF9exiL5lh1XB09z5XZ4iK0ubaXFFInjBfT4qZOScqFk7PSh6VCvSWG9v3njjN/KyS/xx2nYI5elKoewFtZxK7ilIOb1N6Z5/odtyBCwuso3JicJ8bhZ1E=
Message-ID: <9e4733910705220902y151d1922s7e478de041062aa4@mail.gmail.com>
Date: Tue, 22 May 2007 12:02:12 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705220846.53664.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <20070522155439.20bf509f@the-village.bc.nu>
	 <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
	 <200705220846.53664.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tuesday, May 22, 2007, Jon Smirl wrote:
> > On 5/22/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > you display text in graphics mode entirely in kernel context. The
> > > > driver should also attempt to stop the GPU to try and make sure it
> > > > doesn't erase the OOPS display.
> > >
> > > If we know how yes. Probably the X server needs to provide us with a
> > > simple list of operations to perform or failing that write 128K of
> > > null to the display then print the characters (the 128K should ensure
> > > any running FIFO for commands is stuffed and we get back to the
> > > framebuffer)
> > >
> > > > Another simple thing that needs to be built is a mechanism to run
> > > > the VBIOS in x86 mode when the driver is first loaded. This can be
> > >
> > > We don't want to touch the video bios for most cards, its not as good
> > > as the X mode switcher code, nor for that matter does it work in a lot
> > > of cases as they use IRQ and DMA functions sometimes.
> >
> > The only reason the VBIOS is run is to initially reset the card. Once
> > we get the card reset it isn't used any more. For almost all cards
> > this is the only way to reset them, we have insufficient information
> > to write this ourselves.
>
> We should aim to get away from this though.  For Intel and VIA chips, we
> have enough info to do full card setup ourselves.  IIRC there's some early
> code to do the same for ATI chips (not sure about other chips though).  If
> we can avoid using the VBIOS, our drivers will be far more portable and
> featureful than they'd be otherwise.  For example, current ATI drivers
> simply can't do full multihead on many setups because it relies on the
> BIOS to setup external DAC chips, and in many cases the BIOS doesn't.  In
> order to address that, we need to learn how to do it ourselves...  So if
> at all possible, I'd like to avoid baking any assumptions about VBIOS POST
> into this design.

I've talked to an ATI engineer about VBIOS initialization. The chips
may have different steppings. They flash the right VBIOS that matches
the chip into the ROM on the card.  Given all the various steppings
this is the only sane way to initialize the hardware. I don't believe
generic initialization code that can handle all of the various
steppings exists for any hardware.

-- 
Jon Smirl
jonsmirl@gmail.com
