Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbXGaKTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbXGaKTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXGaKTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:19:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:44607 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbXGaKTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D4eJWT969y4qW6NVSnT9hd0W57QX1yZb/7vtfXjy7obe6AAsB+hm4KUTDtMWcBv9isuUo4XOj+qa0mfNt9o/BAetX5wEpYOFJHp4RtJZrcbBagS1KblJbUeHt+S4nxikgr+lNoMfR5rj2soQA9mC1Tn3mhZZ0dpVct3CCtrAEaU=
Message-ID: <46AF0B8C.7070006@googlemail.com>
Date: Tue, 31 Jul 2007 12:14:36 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com,
       amitkale@linsyssoft.com
Subject: Re: NETPOLL=y , NETDEVICES=n compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070731083210.GA1797@ff.dom.local>
In-Reply-To: <20070731083210.GA1797@ff.dom.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 28-07-2007 20:42, Gabriel C wrote:
>> Andrew Morton wrote:
>>> On Sat, 28 Jul 2007 17:44:45 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> I got this compile error with a randconfig ( http://194.231.229.228/MM/randconfig-auto-82.broken.netpoll.c ).
>>>>
>>>> ...
>>>>
>>>> net/core/netpoll.c: In function 'netpoll_poll':
>>>> net/core/netpoll.c:155: error: 'struct net_device' has no member named 'poll_controller'
>>>> net/core/netpoll.c:159: error: 'struct net_device' has no member named 'poll_controller'
>>>> net/core/netpoll.c: In function 'netpoll_setup':
>>>> net/core/netpoll.c:670: error: 'struct net_device' has no member named 'poll_controller'
>>>> make[2]: *** [net/core/netpoll.o] Error 1
>>>> make[1]: *** [net/core] Error 2
>>>> make: *** [net] Error 2
>>>> make: *** Waiting for unfinished jobs....
>>>>
>>>> ...
>>>>
>>>>
>>>> I think is because KGDBOE selects just NETPOLL.
>>>>
>>> Looks like it.
>>>
>>> Select went and selected NETPOLL and NETPOLL_TRAP but things like
>>> CONFIG_NETDEVICES and CONFIG_NET_POLL_CONTROLLER remain unset.  `select'
>>> remains evil.
> ...
>> I think there may be a logical issue ( again if I got it right ).
>> We need some ethernet card to work with kgdboe right ? but we don't have any if !NETDEVICES && !NET_ETHERNET.
>>
>> So maybe some ' depends on ... && NETDEVICES!=n && NET_ETHERNET!=n ' is needed too ? 
> 
> IMHO, the only logical issue here is netpoll.c mustn't use 
> CONFIG_NET_POLL_CONTROLLER code without #ifdef if it doesn't
> add this dependency itself.
> 

Well it does if NETDEVICES && if NET_ETHERNET which booth are N when !NETDEVICES is why KGDBOE uses select and not depends on.

Now KGDBOE just selects NETPOLL and NETPOLL_TRAP.
Adding 'select CONFIG_NET_POLL_CONTROLLER' let kgdboe compiles but the question is does it work without any ethernet card ?

> Cheers,
> Jarek P. 
> 


Gabriel
