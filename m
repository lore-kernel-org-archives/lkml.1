Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYLFO6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYLFO6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYLFO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:58:10 -0500
Received: from stinky.trash.net ([213.144.137.162]:49582 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYLFO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:58:08 -0500
Message-ID: <493A92FD.3060302@trash.net>
Date: Sat, 06 Dec 2008 15:58:05 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: m m <olsajiri@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: netlink - notify when the socket gets closed
References: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com> <20081205195624.95ea1866.akpm@linux-foundation.org>
In-Reply-To: <20081205195624.95ea1866.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc netdev@vger.kernel.org)
> 
> On Fri, 5 Dec 2008 09:17:51 +0100 "m m" <olsajiri@gmail.com> wrote:
>> I'm using netlink in my module. Based on the communication,
>> this module dynamically creates some internal structure, which
>> needs to be destroyed when the user level socket is closed (or
>> the application dies).
>>
>> I found I could use the netlink_register_notifier function to register
>> NETLINK_URELEASE callback during the netlink_release function.
>> But since my module uses the multicast netlink socket communication,
>> it wont be called:
>>
>> [...]
>> Whats the reason this callback is not called for multicast sockets?
>>
>> To workaround it I created simple misc device which the user application
>> opens before creating the netlink socket. This way I get some callbacks
>> inside the module when the application dies, at least.. pretty ugly :)
>>
>> Is there a netlink mechanism to be notified when the netlink socket is
>> closed on the user level side? (when using multicast communication)
>>
>> Or is there any other design I could use, since I think I'm not alone in
>> using internal module data which needs to be removed once the application dies.


That doesn't make sense. When you use multicast, multiple applications
can be listening to the messages. If you really need state for a single
listener and exchange messages in both directions, it sounds like you
should use unicast.

