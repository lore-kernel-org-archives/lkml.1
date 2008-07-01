Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYGAM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYGAM4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYGAM4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:56:31 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:43435 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYGAM4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:56:30 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Tue, 1 Jul 2008 14:55:55 +0200
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807011249.40551.mb@bu3sch.de> <20080701110436.GA32365@elte.hu>
In-Reply-To: <20080701110436.GA32365@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807011455.56273.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 980F93EDDCF.AA1EE
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael, Ingo,

Le Tuesday 01 July 2008 13:04:37 Ingo Molnar, vous avez écrit :
> * Michael Buesch <mb@bu3sch.de> wrote:
> > So this adds user-configurable GPIO support through gpiolib on
> > subarchitectures that do not implement a GPIO implementation, yet.
> > Currently that's everything except X86_RDC321X.

The only reason RDC321x is not yet converted to using gpiolib is the small 
number of actually accessible GPIOs, anyway, I will do the conversion soon.

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

This code is inherited from MIPS/ARM before GPIO lib, where generic assembly 
headers provide prototypes for the usual GPIO functions. Boards override 
those functions with their own copy of these GPIO functions.

>  #ifdef CONFIG_X86_ELAN
>  #  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
>  #elif defined(CONFIG_X86_RDC321X)
>  #  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
>  #else
>  #  define PIT_TICK_RATE 1193182 /* Underlying HZ */
>  #endif
>
> ... once that is made dynamic/quirkable we are there.

Yes, I did not have time to investigate this, and am still wondering if we can 
have dynamic tick rate settings in early board setup code.
-- 
Cordialement, Florian Fainelli
------------------------------
