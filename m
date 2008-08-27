Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYH0WA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYH0WA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYH0WAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:00:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYH0WAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:00:13 -0400
Message-ID: <48B5CE61.8020809@zytor.com>
Date: Wed, 27 Aug 2008 15:00:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
References: <adaod3ef82e.fsf@cisco.com>
In-Reply-To: <adaod3ef82e.fsf@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
> A fairly small test case that I don't understand either is:
> 
> unsigned foo(int x)
> {
> 	return (((x & 0xffffff) | (1 << 30)) & 0xff000000) >> 24;
> }
> 
> just running "gcc -c" (ie no extra warnings enabled) on that produces
> the same:
> 
>     b.c: In function 'foo':
>     b.c:3: warning: integer overflow in expression
> 
> I'm sure there's some promotion rule or something that makes sense of
> this, but it's a mystery to me...
> 

Looks like a gcc bug to me.

0xff000000 is unsigned, like any hexadecimal constant.

unsigned foo(int x)
{
	return ((x & 0xffffff) | (1 << 30)) & 0x80000000;
}

... is enough to reproduce the bug -- explicitly casting either side or 
both of the & operator to unsigned doesn't affect the warning, either.

	-hpa
