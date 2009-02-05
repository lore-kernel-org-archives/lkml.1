Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbZBEQZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbZBEQZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbZBEQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:24:55 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48521 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754185AbZBEQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:24:54 -0500
Date: Thu, 5 Feb 2009 17:24:51 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
In-Reply-To: <20090115030526.GA27726@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Herbert,

On Thu, 15 Jan 2009, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 04:01:34PM +0100, Geert Uytterhoeven wrote:
> > On Wed, 14 Jan 2009, Herbert Xu wrote:
> > > Also, this is something that we'll potentially export to user-space,
> > > so we need to ensure that it is invariant to word length.
> > > 
> > > So something like this would be good
> > > 
> > > 	int (*setup_comp)(struct crypto_pcomp *tfm, const void *params,
> > > 			  unsigned int length);
> > > 	int (*setup_decomp)(struct crypto_pcomp *tfm, const void *params,
> > > 			    unsigned int length);
> > 
> > I assume "length" is the size of the passed params, so the algorithms can
> > return -EINVAL if they're passed the wrong size?
> > 
> > > The actual parameters should be formatted using the netlink helpers
> > > (nla_*).  So each parameter that you want to set should show up as
> > > a netlink attribute.  If a paramter is absent then you'd just use
> > > the default, etc.
>
> > I assume "length" is the size of the passed params, so the algorithms can
> > return -EINVAL if they're passed the wrong size?
> 
> Well with the netlink parameters these can have variable lengths
> depending on how many parameters the user supplies.

How can this be exported to userspace?
How does this variable length parameter passing work? Do you have an example?
Nothing in crypto/ seems to already use nla_*?

> Ah yes because crypto_comp is one of the original types that's
> still built-in.  Because there are so few compression users and
> algorithms (exactly 3 if you include null compression), I think
> we can dispense with the compatibility stuff altogether since
> we'll likely rip out fairly soon anyway.
> 
> So just create the new type, readd deflate using the new type
> alongside the existing deflate algorithm.  The system is capable
> of supporting two algorithms of the same name with different types.

While the core of the crypto system supports two algorithms of the same name
with different types, the testmgr doesn't.

As I removed the backwards-compatility layer at your request, I'll use "zlib"
for the name of the new module. It's more flexible than the fixed "deflate"
one anyway.

Is this OK for you?

Thanks!

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
