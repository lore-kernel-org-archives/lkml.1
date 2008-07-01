Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYGALOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYGALOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYGALOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:14:24 -0400
Received: from bu3sch.de ([62.75.166.246]:43300 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYGALOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:14:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Tue, 1 Jul 2008 13:13:40 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       florian.fainelli@telecomint.eu,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807011249.40551.mb@bu3sch.de> <20080701110436.GA32365@elte.hu>
In-Reply-To: <20080701110436.GA32365@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011313.40598.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008 13:04:37 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > So this adds user-configurable GPIO support through gpiolib on 
> > subarchitectures that do not implement a GPIO implementation, yet. 
> > Currently that's everything except X86_RDC321X.
> > 
> > The advantage of this is to make it possible to use generic PCI (or 
> > other bus) GPIO extention cards in standard PCs through the standard 
> > GPIO API.
> > 
> > If another subarch implements its own GPIO, it needs to add itself as 
> > an inverted dependency to GPIO_USERSELECTION to make sure the user 
> > does not enable two GPIO API implementations.
> > 
> > About the asm-x86/gpio.h:
> > I'm not sure what this <gpio.h> include currently is.
> > Can somebody explain that to me? Where is this supposed
> > to include a gpio.h file from?
> > 
> > What's your opinion on this?
> 
> ( i've Cc:-ed Florian on this who's maintaining the RDC R-321X bits. )
> 
> The longer-term goal is that we'd like to remove the explicit RDC 
> sub-arch and just support such systems out of box on x86.

nice :)

> ... and thus perhaps your GPIO_USERSELECTION patch should move into 
> drivers/ and be generally accessible, not special to x86?

Yes I'd really like to move it there, too. But currently that
clashes with architectures like MIPS, some PPC flavours and probably
others that implement their own GPIO API.
We should have an ARCH_IMPLEMENT_GPIO or whatever, but currently we
don't seem to have that.

So well. If it's desired to put the user selection into drivers/gpio
(which I'd really prefer), I can try to make a patch that adds
ARCH_IMPLEMENT_GPIO to every arch that implements their own GPIO API
and make GPIO_USERSELECTION depend on !ARCH_IMPLEMENT_GPIO.

-- 
Greetings Michael.
