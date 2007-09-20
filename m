Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXITGMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXITGMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXITGL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:11:59 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:37355 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXITGL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:11:57 -0400
Message-ID: <46F20F24.1020900@cosmosbay.com>
Date: Thu, 20 Sep 2007 08:11:48 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Nagendra Tomar <tomer_iisc@yahoo.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
References: <331107.71046.qm@web53704.mail.re2.yahoo.com>
In-Reply-To: <331107.71046.qm@web53704.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 20 Sep 2007 08:11:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nagendra Tomar a écrit :
> --- Davide Libenzi <davidel@xmailserver.org> wrote:
> 
>> On Wed, 19 Sep 2007, David Miller wrote:
>>
>>> From: Nagendra Tomar <tomer_iisc@yahoo.com>
>>> Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
>>>
>>>> With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
>>>> not return, even when the incoming acks free the buffers.
>>>>         Note that this patch assumes that the SOCK_NOSPACE check in
>>>> tcp_check_space is a trivial optimization which can be safely removed.
>>> I already replied to your patch posting explaining that whatever is
>>> not setting SOCK_NOSPACE should be fixed instead.
>>>
>>> Please address that, thanks.
>> You're not planning of putting the notion of a SOCK_NOSPACE bit inside a 
>> completely device-unaware interface like epoll, I hope?
>>
> 
> Definitely not ! 
> 
> The point is that the "tcp write space available" 
> wakeup does not get called if SOCK_NOSPACE bit is not set. This was
> fine when the wakeup was merely a wakeup (since SOCK_NOSPACE bit 
> indicated that someone really cared abt the wakeup). Now after the
> introduction of callback'ed wakeups, we might have some work to
> do inside the callback even if there is nobody interested in the wakeup
> at that point of time. 
> 
> In this particular case the ep_poll_callback is not getting called and
> hence the socket fd is not getting added to the ready list.
> 

Does it means that with your patch each ACK on a ET managed socket will 
trigger an epoll event   ?

Maybe your very sensitive high throuput appication needs to set a flag or 
something at socket level to ask for such a behavior.

The default should stay as is. That is an event should be sent only if someone 
cared about the wakeup.

