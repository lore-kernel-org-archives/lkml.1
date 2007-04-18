Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXDRI1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXDRI1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXDRI1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:27:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18618 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030AbXDRI1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:27:41 -0400
Message-ID: <4625D7A8.5030209@sw.ru>
Date: Wed, 18 Apr 2007 12:32:40 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Patrick McHardy <kaber@trash.net>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
References: <4625D3D2.9030507@sw.ru> <20070418081707.GA29267@2ka.mipt.ru>
In-Reply-To: <20070418081707.GA29267@2ka.mipt.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Apr 18, 2007 at 12:16:18PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
>> Sorry, I forgot to put netdev and David in Cc when I first sent it.
>>
>> There is a race between netlink_dump_start() and netlink_release()
>> that can lead to the situation when a netlink socket with non-zero
>> callback is freed.
> 
> Out of curiosity, why not to fix a netlink_dump_start() to remove
> callback in error path, since in 'no-error' path it removes it in

Error path is not relevant here. The problem is that we
keep a calback on a socket that is about to be freed.

> netlink_dump().
> 
> And, btw, can release method be called while socket is being used, I
> thought about proper reference counters should prevent this, but not
> 100% sure with RCU dereferencing of the descriptor.
> 

