Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0CBX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:27:52 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:42490 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0CBX1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GvUgQh278EBWgjvBuAO+t8ffE0v8zYHr7VqOSQlU5Osq44kThKqFoxQFH/TrBZ47HF
         MrkfNLVl5+OK/wsimUg9EZSdBY+46DyzUxdWPhC5wrmKl17jaGZgswUHHSVLrBnz6l01
         1nQc9tTGd0eyXUFhvrtOQhWfsHWQt5D83+jJw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
	 <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>
	 <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie>
Date: Wed, 3 Mar 2010 09:27:48 +1000
Message-ID: <21d7e9971003021527t41268786q302a218ffe410763@mail.gmail.com>
Subject: Re: [git pull] drm request 2
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0/3/3 Dave Airlie <airlied@linux.ie>:
>>
>> Never mind. I've unpulled the whole effin' mess since it doesn't even
>> compile:
>>
>>       drivers/gpu/drm/nouveau/nouveau_acpi.c:191: error: redefinition of ‘nouveau_register_dsm_handler’
>>       drivers/gpu/drm/nouveau/nouveau_drv.h:859: note: previous definition of ‘nouveau_register_dsm_handler’ was here
>>       drivers/gpu/drm/nouveau/nouveau_acpi.c:202: error: redefinition of ‘nouveau_unregister_dsm_handler’
>>       drivers/gpu/drm/nouveau/nouveau_drv.h:860: note: previous definition of ‘nouveau_unregister_dsm_handler’ was here
>>
>> because not only was that VGA_SWITCHEROO Kconfig default the wrong way
>> around, the thing had clearly never ever been tested at all.
>>
>> Why does sh*t like this even make it to me? Was this ever at all in -next?
>> I assume not, since that would have picked up on basic compile failures.
>>
>> Grr. Things like this is what makes me go "Ok, there's always the next
>> merge window, maybe it will have gotten some testing by then".
>
> Linux next didn't pick up this build failure, wierdly neither did the
> powerpc build I did with this turned off, because ACPI was also off on
> ppc, it was in linux-next for at least 2 days, and from what I can see
> that found the ppc problems, it never found the x86 option since it was on
> by default.
>
> I'm going to just rip the nouveau bits out of the patch, btw nouveau is in
> staging, so you are being a bit OTT, calm down.\

Anyways sfr just confirmed linux-next doesn't build CONFIG_STAGING
drivers so again that wouldn't have helped. So you made us pull nouveau
into staging, now you are giving out because staging drivers have issues?

In any case I've fixed the default y and the STAGING build in my tree.

Did I mention that driver is in STAGING?

Dave.
