Return-Path: <linux-kernel-owner+w=401wt.eu-S935326AbXEVPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935326AbXEVPrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbXEVPrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:47:12 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:36421 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757186AbXEVPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:47:11 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Tue, 22 May 2007 08:46:53 -0700
User-Agent: KMail/1.9.6
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <20070522155439.20bf509f@the-village.bc.nu> <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
In-Reply-To: <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220846.53664.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007, Jon Smirl wrote:
> On 5/22/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > you display text in graphics mode entirely in kernel context. The
> > > driver should also attempt to stop the GPU to try and make sure it
> > > doesn't erase the OOPS display.
> >
> > If we know how yes. Probably the X server needs to provide us with a
> > simple list of operations to perform or failing that write 128K of
> > null to the display then print the characters (the 128K should ensure
> > any running FIFO for commands is stuffed and we get back to the
> > framebuffer)
> >
> > > Another simple thing that needs to be built is a mechanism to run
> > > the VBIOS in x86 mode when the driver is first loaded. This can be
> >
> > We don't want to touch the video bios for most cards, its not as good
> > as the X mode switcher code, nor for that matter does it work in a lot
> > of cases as they use IRQ and DMA functions sometimes.
>
> The only reason the VBIOS is run is to initially reset the card. Once
> we get the card reset it isn't used any more. For almost all cards
> this is the only way to reset them, we have insufficient information
> to write this ourselves.

We should aim to get away from this though.  For Intel and VIA chips, we 
have enough info to do full card setup ourselves.  IIRC there's some early 
code to do the same for ATI chips (not sure about other chips though).  If 
we can avoid using the VBIOS, our drivers will be far more portable and 
featureful than they'd be otherwise.  For example, current ATI drivers 
simply can't do full multihead on many setups because it relies on the 
BIOS to setup external DAC chips, and in many cases the BIOS doesn't.  In 
order to address that, we need to learn how to do it ourselves...  So if 
at all possible, I'd like to avoid baking any assumptions about VBIOS POST 
into this design.

Jesse
