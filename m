Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYGUQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYGUQXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYGUQXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:23:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbYGUQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:23:00 -0400
Message-ID: <4884B7C3.9040801@linux-foundation.org>
Date: Mon, 21 Jul 2008 11:22:27 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI> <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu> <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com> <20080721100627.GA5953@2ka.mipt.ru>
In-Reply-To: <20080721100627.GA5953@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Not that obvious...
> skb->next is cleared in lots of places, in xmit network helper
> for example, but since rest of the packet was not modified, it
> means given skb was not freed, so it will not help.
>
>   

The skb was definitely freed. 6b is written over an object when it is 
freed. Something else retained a pointer to the skb and was confident 
that the skb still exists.


