Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0BDCLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:11:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50730
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab0BDCLS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:11:18 -0500
Date: Wed, 03 Feb 2010 18:11:32 -0800 (PST)
Message-Id: <20100203.181132.194298727.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: kronos.it@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] af_key: fix netns ops ordering on module load/unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265032590.2848.40.camel@edumazet-laptop>
References: <20100130125327.GA4258@x200>
	<68676e01002010550l2654208dged864973a996c381@mail.gmail.com>
	<1265032590.2848.40.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 01 Feb 2010 14:56:30 +0100

> Le lundi 01 février 2010 à 14:50 +0100, Luca Tettamanti a écrit :
>> On Sat, Jan 30, 2010 at 1:53 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
>> > [PATCH] af_key: fix netns ops ordering on module load/unload
>> >
>> > 1. After sock_register() returns, it's possible to create sockets,
>> >   even if module still not initialized fully (blame generic module code
>> >   for that!)
>> > 2. Consequently, pfkey_create() can be called with pfkey_net_id still not
>> >   initialized which will BUG_ON in net_generic():
>> >        kernel BUG at include/net/netns/generic.h:43!
>> > 3. During netns shutdown, netns ops should be unregistered after
>> >   key manager unregistered because key manager calls can be triggered
>> >   from xfrm_user module:
>> >
>> >        general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> >        pfkey_broadcast+0x111/0x210 [af_key]
>> >        pfkey_send_notify+0x16a/0x300 [af_key]
>> >        km_state_notify+0x41/0x70
>> >        xfrm_flush_sa+0x75/0x90 [xfrm_user]
>> > 4. Unregister netns ops after socket ops just in case and for symmetry.
>> >
>> > Reported by Luca Tettamanti.
>> >
>> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>> 
>> Tested-by: Luca Tettamanti <kronos.it@gmail.com>
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone!
