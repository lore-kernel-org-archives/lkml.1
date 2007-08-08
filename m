Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXHHPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXHHPwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXHHPwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:52:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:15862 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbXHHPwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OABvZn0/pgY7fYticdniOiUpiAYHg3zss39k3v0ttplQDqTrHuXBhQonVB0HlEuJT90InuJh5xwQuoQyUkl7xcZkx7TVcjkvAixqI1ynDcAFlC9Xb5lQLMtd9iWWy1O8/sbOmv1AoQYrdLRu/klu4wjLZGNCY4i8i7O8J2E6qiE=
Message-ID: <f56c1ba00708080852p5a87a106gdb5d1be6ce247638@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:52:23 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: PAT support for i386 and x86_64
Cc: "Loic Prylli" <loic@myri.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, brice@myri.com,
       cedric.augonnet@ens-lyon.org
In-Reply-To: <20070808101441.GA12861@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com>
	 <20070807083004.GB30085@one.firstfloor.org>
	 <46B97E39.3020905@myri.com>
	 <20070808101441.GA12861@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Apologize for the double-post, messed up with my mailer... ]

2007/8/8, Andi Kleen <andi@firstfloor.org>:
> > I don't see why we have to worry about cache corruption in the case at
> > hand. Write-combining is needed to map io (typically pci-mem regions)
> > which are never mapped cachable anywhere, including in the linear map.
>
> If we WC them using PAT then there would be a UC<->WC conflict with
> the direct mapping and possibly others. That's already undefined
> and not allowed.
>
> After some very bad experiences in the past I'm not going to take
> chances on this.
>
> We really need to keep all possible mappings synchronized.
>
> -Andi
>
>

Hi,

First thanks for your reactions.

Andi, what i don't understand is, if we only put a minimal patch, like only
modifying the register, perhaps we may avoid having all vendors doing
their own recipe, possibly all messing the one the other. As you said ,
changing this register is absolutely not the actual issue with PAT, but don't
you think such a first step is needed to avoid conflicts since people _do_
already set that register from their driver.

I agree there is work for a comprehensive support of PAT, especially when
dealing with ioremap, but even though we only handle a smallish portion
of the problem yet, perhaps it's time to at least modify that register ?

Of course there is no problem for that being dependant on a CONFIG_PAT.

Kind regards,
Cédric
