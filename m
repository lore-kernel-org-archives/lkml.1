Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYFTKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYFTKYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYFTKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:24:05 -0400
Received: from webmail.e-teleport.net ([213.190.83.68]:37642 "EHLO
	mail.imsnet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYFTKYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:24:04 -0400
Message-ID: <485B8542.7060204@e-teleport.net>
Date: Fri, 20 Jun 2008 12:24:02 +0200
From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
 MTU change
References: <20080603134019.df2f51d4.akpm@linux-foundation.org> <20080603215155.GA9712@electric-eye.fr.zoreil.com> <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net> <20080618201012.GA4019@electric-eye.fr.zoreil.com> <48598784.40306@e-teleport.net> <20080619204312.GA2160@electric-eye.fr.zoreil.com>
In-Reply-To: <20080619204312.GA2160@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu a écrit :
> Séguier Régis <rseguier@e-teleport.net> :
>   
>>> I have updated http://userweb.kernel.org/~romieu/via-velocity/2.6.26-rc6/
>>>       
> [...]
>   
>> Patch 0001 doesn't work,
>>
>> if I don't make a mistake skb->len is not modified in skb_pad{,to}when the 
>> padding is applied. In this case, we need to attribute ETH_ZLEN to len.
>>     
>
> Yes, that's what the driver did beforehand.
>
> The updated serie is at the usual place. Does it perform better ?
>
>   
Ok for the mtu change, no error messages, I try multiples mtu 
(1400,2000,4500,9000).

But if I generate a paquet with a size more than around 3825, the driver 
don't send it and no paquet is send after, work again after an interface 
down/up and until no paquet > 3825.

-- 
Régis
