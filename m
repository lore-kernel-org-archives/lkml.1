Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbXEVPQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbXEVPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXEVPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:16:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:55788 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbXEVPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EQwnTj4+QqwPofZEScMQ9A+kIbe8qoiNWsa60D58cCxp0EJgCO5x9bM9HWBelD3iWjmTCcEIdEsJTQy/XM+3g1vQEgfTtfs2Hz1LztDwfzEPnXd5WQfKQvc36BypZWZ22Xj5pchb+R/q8nYg87A1Ww7TkL/H2Qjy1ZRW8naJC3w=
Message-ID: <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
Date: Tue, 22 May 2007 11:16:47 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <20070522155439.20bf509f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <465228E2.1030405@garzik.org>
	 <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
	 <200705211856.56228.jbarnes@virtuousgeek.org>
	 <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
	 <20070522155439.20bf509f@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > you display text in graphics mode entirely in kernel context. The
> > driver should also attempt to stop the GPU to try and make sure it
> > doesn't erase the OOPS display.
>
> If we know how yes. Probably the X server needs to provide us with a
> simple list of operations to perform or failing that write 128K of null
> to the display then print the characters (the 128K should ensure any
> running FIFO for commands is stuffed and we get back to the framebuffer)
>
> > Another simple thing that needs to be built is a mechanism to run the
> > VBIOS in x86 mode when the driver is first loaded. This can be
>
> We don't want to touch the video bios for most cards, its not as good as
> the X mode switcher code, nor for that matter does it work in a lot of
> cases as they use IRQ and DMA functions sometimes.

The only reason the VBIOS is run is to initially reset the card. Once
we get the card reset it isn't used any more. For almost all cards
this is the only way to reset them, we have insufficient information
to write this ourselves.


>
> Alan
>


-- 
Jon Smirl
jonsmirl@gmail.com
