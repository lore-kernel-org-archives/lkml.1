Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXDRJRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXDRJRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXDRJRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:17:10 -0400
Received: from stinky.trash.net ([213.144.137.162]:54710 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXDRJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:17:07 -0400
Message-ID: <4625E202.8040604@trash.net>
Date: Wed, 18 Apr 2007 11:16:50 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Pavel Emelianov <xemul@sw.ru>, David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
References: <4625D3D2.9030507@sw.ru> <20070418081707.GA29267@2ka.mipt.ru> <4625D637.2040308@trash.net> <20070418084206.GA4241@2ka.mipt.ru> <4625DBE2.5090402@trash.net> <20070418090720.GA25070@2ka.mipt.ru>
In-Reply-To: <20070418090720.GA25070@2ka.mipt.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Apr 18, 2007 at 10:50:42AM +0200, Patrick McHardy (kaber@trash.net) wrote:
> 
>>>I thought that with releasing a socket, which will have a callback
>>>attached only results in a leak of the callback? In that case we can
>>>just free it in dump() just like it is done in no-error path already.
>>>Or do I miss something additional?
>>
>>That would only work if there is nothing to dump (cb->dump returns 0).
>>Otherwise it is not freed.
> 
> 
> That is what I referred to as error path. Btw, with positive return
> value we end up in subsequent call to input which will free callback
> under lock as expected.


No, nothing is going to call netlink_dump after the initial call since
the socket is gone.

