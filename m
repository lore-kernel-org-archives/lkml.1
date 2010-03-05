Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0CEU70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:59:26 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:42090 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0CEU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:59:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V018a1K3Wv4i3M2MWrbsPfKniITiztuggjP3KXnm1xvyrF05Dw/USRkeR5YowdeRJC
         yxwbPCWaxWgo1jV0qMwW/xCzTMBMWMjT994MIPkiEGCtdimro5CDEeUWaVmWzTqGLbRz
         C/41RbYwv5sir/5bi8OmN/XBANF47IPOE+DhY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003050814410.3788@localhost.localdomain>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	 <20100305.063718.211238119.davem@davemloft.net>
	 <20100305151754.GB2505@tempa>
	 <20100305.072612.186421758.davem@davemloft.net>
	 <20100305154009.GC2505@tempa>
	 <ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
	 <20100305161311.656711e0@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003050814410.3788@localhost.localdomain>
Date: Fri, 5 Mar 2010 22:59:23 +0200
Message-ID: <94a0d4531003051259i4478f55djc018da003886872f@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Luca Barbieri <luca.barbieri@gmail.com>,
       Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 6:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> The thing I objected to, in the VERY BEGINNING in this thread, i the fact
> that the thing was done in such a way that it's basically impossible to
> support the old/new ABI at all!

[...]

> The way this was done, it's apparently basically impossible for the Fedora
> people to push out packaged that support both the old and the new kernel.

The reason why the nouveau people wanted to leave the driver in
staging is because they wanted to leave open the option of reshuffling
the API. The Fedora guys integrated this stuff on their own risk, and
linux (because of your pressure), also did. At no point in time
nouveau guys agreed to freeze the API.

Now they have done precisely what was expected; there's no surprise there.

The surprise seems to be that you thought (for some reason), that
reshuffling the API wouldn't break the old (or current in F12)
user-space code. Now, how exactly do you think that could have been
achieved? Even if you have both nouveau_drv-0.0.15.so, and
nouveau_drv-0.0.16.so... What piece of could would choose one rather
than the other? There has never been such a piece of code.

If there was no compatibility code for API re-shuffling, and API
re-shuffling was expected, the resulting breakage was doomed to
happen.

Finally, at least it's possible to compile the radeon driver without
support for DRM, so perhaps nouveau (and other drivers), should check
the kernel drm version at run-time instead, and fall-back to non-drm
mode when the version is not compatible. I think that's a sensible
approach, although that might require a considerable amount of code.
However, that's something to consider for the future, as your current
libdrm/nouveau is not prepared to handle  the DRM API re-shuffle that
_must_ happen.

Cheers.

-- 
Felipe Contreras
