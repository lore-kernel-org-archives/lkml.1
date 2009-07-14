Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZGNRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZGNRRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZGNRRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:17:25 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:15170 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbZGNRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nO9RUDNRzcr2wsz9I9VATsePK75XRGSpFAxRK1+SftSaVpLoCfngOvlDQalNGdrJyG
         jDy41mGgN45zUt65CSAbwEU/syiNb+nwc+0aGrzJ5demO1XQMuX4zTP8zga2JTNKdnl1
         o3lx56NsHd5DcUbRcdc/OZV4OkjaWqJkuazKY=
MIME-Version: 1.0
In-Reply-To: <20090404.170539.148727646.davem@davemloft.net>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
	 <20090404.170539.148727646.davem@davemloft.net>
Date: Tue, 14 Jul 2009 14:17:21 -0300
Message-ID: <ce0170d90907141017h732c2cd7ja5990303093b6edd@mail.gmail.com>
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: Sergio Luis <eeeesti@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: amluto@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Sat, Apr 4, 2009 at 9:05 PM, David Miller<davem@davemloft.net> wrote:
> From: Andrew Lutomirski <amluto@gmail.com>
> Date: Wed, 1 Apr 2009 11:40:06 -0400
>
>> When a network driver registers a new interface, linkwatch will not notice,
>> and hence not set the rfc2863 operstate, until netif_carrier_on gets called.
>> If the new interface has no carrier when it is connected, then a status of
>> "unknown" is reported to userspace, which confuses various tools
>> (NetworkManager, for example).
>>
>> This fires a linkwatch event for all new interfaces, so that operstate
>> gets set reasonably quickly.
>>
>> Signed-off-by: Andrew Lutomirski <amluto@gmail.com>
>
> The default assumed state for a freshly registered network
> device is that the link is up.
>
> If that disagrees from reality, the driver should make the
> appropriate netif_carrier_off() call.
>
> I'm sure you'll find that the e1000 driver is not doing this
> and that is what causes the bug you are seeing.
> --

is this patch incorrect, though? with the linkwatch_fire_event() call,
the rfc2863 operstate will be set for everyone at device register
time.
in here I am having the interface operstate as 'unknown', but I do
ifconfig down and up or unplug/plug the cable again it will finally
set the correct rfc2863 operstate.

or should this be fixed on a per-driver basis, like it apparently was
in this case, for his e1000? (drivers/net/skge.c in here).

thanks,
sergio
