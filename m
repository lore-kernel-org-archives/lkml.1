Return-Path: <linux-kernel-owner+w=401wt.eu-S935639AbYBTQio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbYBTQio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934467AbYBTQ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:28:07 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:59041 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934461AbYBTQ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:28:02 -0500
Message-ID: <47BC54FB.2050508@trash.net>
Date: Wed, 20 Feb 2008 17:27:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 3/8] [NET]: uninline dev_alloc_skb, de-bloats a lot
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi> <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi> <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi> <Pine.LNX.4.64.0802201651580.26109@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802201651580.26109@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 20 2008 15:47, Ilpo Järvinen wrote:
>> -23668  392 funcs, 104 +, 23772 -, diff: -23668 --- dev_alloc_skb
>>
>> -static inline struct sk_buff *dev_alloc_skb(unsigned int length)
>> -{
>> -	return __dev_alloc_skb(length, GFP_ATOMIC);
>> -}
>> +extern struct sk_buff *dev_alloc_skb(unsigned int length);
> 
> Striking. How can this even happen? A callsite which calls
> 
> 	dev_alloc_skb(n)
> 
> is just equivalent to
> 
> 	__dev_alloc_skb(n, GFP_ATOMIC);
> 
> which means there's like 4 (or 8 if it's long) bytes more on the
> stack. For a worst case, count in another 8 bytes for push and pop or mov on
> the stack. But that still does not add up to 23 kb.


__dev_alloc_skb() is also an inline function which performs
some extra work. Which raises the question - if dev_alloc_skb()
is uninlined, shouldn't __dev_alloc_skb() be uninline as well?
