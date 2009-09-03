Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZICOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZICOfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZICOfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:35:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39233 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZICOfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oXtiSVhafipj+QqTIsWgweX1eZfgg03mqC7sCbL1ELHxeEK+EAnXa7VN6A0+mEeE5b
         Cba49MM7jJ8n9h3eL8QFSUcH12rJOaZk2ZsCIqe01wrP8szJrX/xnrtVYoAQNFsFOU+P
         kMlsw4csAO6su3cdmGEzLvMBIuxLZu+jfP3Ns=
MIME-Version: 1.0
In-Reply-To: <4A9FC8B1.904@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>
	 <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>
	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
	 <c4e36d110909030628j53cc0abfq6c1eef7e5e97565b@mail.gmail.com>
	 <4A9FC8B1.904@gmail.com>
Date: Thu, 3 Sep 2009 16:35:08 +0200
Message-ID: <c4e36d110909030735q338efd00m2f6fe0b973c68e7b@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/3 Eric Dumazet <eric.dumazet@gmail.com>:
> Zdenek Kabelac a écrit :
>> 2009/9/3 Eric Dumazet <eric.dumazet@gmail.com>:
>>> Zdenek Kabelac a écrit :
>>>> Well I'm not noticing any ill behavior - also note - rcu_barrier() is
>>>> there before the cache is destroyed.
>>>> But as I said - it's just my shot into the dark - which seems to work for me...
>>>>
>>> Reading again your traces, I do believe there are two bugs in slub
>>>
>>> Maybe not explaining your problem, but worth to fix !
>>>
>>> Thank you
>>>
>>> [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
>>>
>>
>>
>> Ok - I can confirm that this patch fixes my reboot problem.
>>
>> Thanks
>>
>> Zdenek
>
> Good news !
>
> Hmm... but you had a problem with a 2.6.29.something kernel if I remember well ?
>
> At that time, conntrack did not use SLAB_DESTROY_BY_RCU yet.

Yes - but it was also giving different error message - which even not
loaded ftp conntrack module. Basically it has been fine until
conntrack started to use rcu. From that moment various errors started
to appear with slub and some kernel debugging options - slab was fine.
With your recent patch it's the first time I do not see oops with nf
after 2.6.29 kernel.

Zdenek
