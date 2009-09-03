Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZICNrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZICNrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZICNrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:47:20 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:47156 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZICNrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:47:17 -0400
Message-ID: <4A9FC8B1.904@gmail.com>
Date: Thu, 03 Sep 2009 15:46:25 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>	 <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com>	 <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>	 <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>	 <4A9EEF07.5070800@gmail.com>	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>	 <4A9F1620.2080105@gmail.com> <c4e36d110909030628j53cc0abfq6c1eef7e5e97565b@mail.gmail.com>
In-Reply-To: <c4e36d110909030628j53cc0abfq6c1eef7e5e97565b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Sep 2009 15:46:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac a écrit :
> 2009/9/3 Eric Dumazet <eric.dumazet@gmail.com>:
>> Zdenek Kabelac a écrit :
>>> Well I'm not noticing any ill behavior - also note - rcu_barrier() is
>>> there before the cache is destroyed.
>>> But as I said - it's just my shot into the dark - which seems to work for me...
>>>
>> Reading again your traces, I do believe there are two bugs in slub
>>
>> Maybe not explaining your problem, but worth to fix !
>>
>> Thank you
>>
>> [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
>>
> 
> 
> Ok - I can confirm that this patch fixes my reboot problem.
> 
> Thanks
> 
> Zdenek

Good news !

Hmm... but you had a problem with a 2.6.29.something kernel if I remember well ?

At that time, conntrack did not use SLAB_DESTROY_BY_RCU yet.

