Return-Path: <linux-kernel-owner+w=401wt.eu-S965409AbXIGLw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbXIGLw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965227AbXIGLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:52:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39347 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226AbXIGLww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:52:52 -0400
Date: Fri, 7 Sep 2007 13:52:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Miller <davem@davemloft.net>
cc: anders.blomdell@control.lth.se, linux-kernel@vger.kernel.org
Subject: Re: Stray nulls when reading from AF_UNIX sockets
In-Reply-To: <20070906.122345.74744962.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0709071350040.25942@fbirervta.pbzchgretzou.qr>
References: <46E02137.8030600@control.lth.se> <20070906.122345.74744962.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 6 2007 12:23, David Miller wrote:
>>     return copied ? : err;
>>   }
>> 
>> Shouldn't this read:
>> 
>>     return copied ? copied : err;
>> 
>> Or am I missing something?
>
>These two statements are equivalent, the first version is
>a shorthand allowed by gcc.

Not only that. With x?x:z, x is evaluated twice,
while with x?:z, x is only evaluated once. That's for stuff when you 
want to, say [dumb example follows],

size_t my_read(..) {
    return read(..) ? : -1
}

and the only other way would be to use a temporary,

size_t my_read(..) {
	size_t x = read(..);
	return x ? x : -1;
}

gcc should be smart enough to also do optimization in the second case..


	Jan
-- 
