Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYDWUOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYDWUOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYDWUO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:14:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:16162 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYDWUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BC4vaOw5rgdPNrfzRHHk9vezrq4ljMKOuNHoRYy9VwN30RZ+uTn5M1q8JMk6w67Bi0d8f7GgKFItZSGKWlqiZHueTemzp1L8cgSiTDlmX17RROvA6AcU+LPH4lneEg9VAvifb0EAGvBwXeX51rXSLvtQDh2iYBzuuPXImOl8JIs=
Message-ID: <74d0deb30804231314v32303b54q3f6765d354c2f8b2@mail.gmail.com>
Date: Wed, 23 Apr 2008 22:14:26 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208895950.24124.9.camel@brick>
	 <20080422203334.GA9809@flint.arm.linux.org.uk>
	 <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 11:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Tue, 22 Apr 2008, Russell King wrote:
>  >
>
> > That was my initial approach as well, which got shot down by Andrew
>  > Morton and others as being unacceptable.
>
>  Hmm. While I in general support the notion of trying to compile drivers on
>  as wide a variety as hardware as possible, if that HTC_PASIC3 thing really
>  is a PXA-only piece of hardware, I don't really see the point of not
>  making the config file accurately represent that.
>
>  That said, as far as I can tell, the compile failure is because of this
>  line:
>
>         #include <asm/arch/pxa-regs.h>
>
>  and I cannot for the life of me see _why_ it tries to include that header
>  file. It seems to compile fine on x96-64 if you just remove that include,
>  and while I still think it should depend on ARCH_PXA just because it makes
>  no sense _not_ to, I do wonder why that include is there in the first
>  place.
>
>  Hmm?

I'm embarrased to say, this is a left-over from a clean-up that
happened a long time ago. I probably forgot to double-check the
includes of this file before submitting to Russell. And this
superfluous include was never pointed out to me because I only
compiled that driver for ARM/PXA.
It seems having the driver enabled for x86 builds had its benefits (a
bug was found :)). I guess now it could just as well be made to depend
on ARCH_PXA, because although it does not really depend on pxa, it is
not of much use on any other architecture.

regards
Philipp
