Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbZBYOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbZBYOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBYOoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:44:08 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65338 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431AbZBYOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:44:05 -0500
Date: Wed, 25 Feb 2009 15:44:02 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Frank Seidel <fseidel@suse.de>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
       akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
In-Reply-To: <49A55771.1050408@suse.de>
Message-ID: <alpine.LRH.2.00.0902251542010.15476@vixen.sonytel.be>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <20090225142744.GA4331@gondor.apana.org.au> <alpine.LRH.2.00.0902251529440.15476@vixen.sonytel.be> <49A55771.1050408@suse.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Frank Seidel wrote:
> Geert Uytterhoeven wrote:
> > Probably people should be reminded tcrypt can only be a module, not built-in,
> > so it won't waste precious unswappable kernel memory if it's static.
> 
> Thats right, but it also doesn't hurt to simply use kmalloc, does it? :-)

Wel...

Using kmalloc() increases code size, makes the code more complex, and increases
the risk of introducing a memory leak now or later.

> I just stumbled over tcrypt on the make checkstack output and as also
> the kerneljanitors todo advises to reduce this footprint where possible
> i just wanted to help out here.

Reducing stack usage is fine. However, for a loadable test module without
concurrency issues it's far easier to do that by just making the data static.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
