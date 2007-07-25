Return-Path: <linux-kernel-owner+w=401wt.eu-S934143AbXGYRc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143AbXGYRc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXGYRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:32:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbXGYRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:32:17 -0400
Message-ID: <46A786C7.9020604@zytor.com>
Date: Wed, 25 Jul 2007 10:22:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725171956.GF27237@ftp.linux.org.uk>
In-Reply-To: <20070725171956.GF27237@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jul 25, 2007 at 09:56:12AM -0700, Linus Torvalds wrote:
>>
>> On Tue, 24 Jul 2007, David Miller wrote:
>>> From: Jeremy Fitzhardinge <jeremy@goop.org>
>>> Date: Tue, 24 Jul 2007 23:24:55 -0700
>>>
>>>> H. Peter Anvin wrote:
>>>>> How far back was __builtin_trap() supported?
>>>> I think its relatively recent, but it might be within our supported
>>>> compiler window.
>>> I'm pretty sure it is.
>> .. and I'm pretty sure it's immaterial.
>>
>> We don't just do the "ud2" instruction - we also do the file and line 
>> number information after it. Which means that __builtin_trap() is useless.
>>
>> So we might as well keep the loop, since both are two-byte instructions 
>> that tell gcc that it will never continue.
> 
> Umm...  Actually, we might be able to do something like
> {
> 	l: __builtin_trap();
> 	static struct ... v __attribute__((section(...))) = { &&l, n, file };
> }
> 
> except that it would need block-local labels and those are ugly (so's
> &&<label>, while we are at it)...

I thought gcc was buggy when it came to passing &&labels to assembly.

	-hpa
