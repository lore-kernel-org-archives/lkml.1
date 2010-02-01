Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0BAN4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:56:37 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:34379 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0BAN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:56:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bb1BxC5YXzS4Z7Ze0OCpe1Ji2lTp+LWyGfrCRTWfKXGHyGba0zsTJBVlRww33/39WI
         PdwsCexec5IE5J35zIFseiagkqo5NlA8PiZaipalFvPsSCAGVj8rKjemRwpqwrscJ0ad
         VIS9SLf6TslYwnuSZMZyjwqTVUNuPx5H2Eddc=
Subject: Re: [PATCH] af_key: fix netns ops ordering on module load/unload
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <68676e01002010550l2654208dged864973a996c381@mail.gmail.com>
References: <20100129094822.GA8294@nb-core2.darkstar.lan>
	 <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
	 <1264778549.3184.28.camel@edumazet-laptop>
	 <1264782806.3184.42.camel@edumazet-laptop> <20100130125327.GA4258@x200>
	 <68676e01002010550l2654208dged864973a996c381@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 14:56:30 +0100
Message-ID: <1265032590.2848.40.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 14:50 +0100, Luca Tettamanti a écrit :
> On Sat, Jan 30, 2010 at 1:53 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > [PATCH] af_key: fix netns ops ordering on module load/unload
> >
> > 1. After sock_register() returns, it's possible to create sockets,
> >   even if module still not initialized fully (blame generic module code
> >   for that!)
> > 2. Consequently, pfkey_create() can be called with pfkey_net_id still not
> >   initialized which will BUG_ON in net_generic():
> >        kernel BUG at include/net/netns/generic.h:43!
> > 3. During netns shutdown, netns ops should be unregistered after
> >   key manager unregistered because key manager calls can be triggered
> >   from xfrm_user module:
> >
> >        general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >        pfkey_broadcast+0x111/0x210 [af_key]
> >        pfkey_send_notify+0x16a/0x300 [af_key]
> >        km_state_notify+0x41/0x70
> >        xfrm_flush_sa+0x75/0x90 [xfrm_user]
> > 4. Unregister netns ops after socket ops just in case and for symmetry.
> >
> > Reported by Luca Tettamanti.
> >
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Tested-by: Luca Tettamanti <kronos.it@gmail.com>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>



