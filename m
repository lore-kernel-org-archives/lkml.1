Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZJ2I1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZJ2I1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZJ2I1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:27:22 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42051 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZJ2I1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=KCFAKiU4H7OTXC6XgmDY4k2+Lj6QSPnbYYMdvwT7cgbJB2MOaWIV/105j1ubpperrq
         deRJUAEFEQkMt5G0XCQupuOtfIFq8ooSwr1oTKV45eTxwkwVmvXbgRuTwr01fw9mPY+b
         FdZL+8l7TQnMtHMk6mobRhfhMbFnZ3oVZCkSE=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: is avoiding compat ioctls possible?
Date: Thu, 29 Oct 2009 09:27:18 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       David Miller <davem@davemloft.net>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <20091028031904.GA7744@basil.fritz.box> <alpine.LFD.2.00.0910282055330.9323@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.0910282055330.9323@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910290927.18436.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, Maciej W. Rozycki wrote:
> 
> On Wed, 28 Oct 2009, Andi Kleen wrote:
> 
> > > I'm just amazed that compat_ioctl should be required for all new code.
> > > 
> > > DrNick on irc suggested just doing:
> > > if (is_compat_task()) ptr &= 0x00000000FFFFFFFF;
> > 
> > Such hacks often have problems on BE.
> 
>  And then some platforms (i.e. MIPS) require sign-extension rather than 
> zero-extension, that is:
> 
> if (is_compat_task()) ptr = ((ptr & 0xffffffff) ^ 0x80000000) - 0x80000000;
> 
> if doing this explicitly (with compat stuff hardware will do the right 
> thing automagically).

Such conversion should *only* ever take place in compat_ptr().

	Arnd <><
