Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYIZUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYIZUH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYIZUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:07:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYIZUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:07:13 -0400
Message-ID: <48DD40EF.4000107@zytor.com>
Date: Fri, 26 Sep 2008 13:07:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joris van Rantwijk <jorispubl@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Inflation of vmlinux by linker on x86_64
References: <20080926124222.GA49837@xs4all.nl> <48DD2F68.6000609@zytor.com> <eb34240721c0b92818908672eccecf62@xs4all.nl>
In-Reply-To: <eb34240721c0b92818908672eccecf62@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joris van Rantwijk wrote:
> 
> On 26 sep 2008, at 20:52, H. Peter Anvin wrote:
>> Instead of adding a comment like this, we should simply rename it 
>> memmove().
> 
> Yes. I tried, but it clashed with an existing memmove declaration in 
> asm-x86/string_32.h.
> 
> What is the accepted solution for this?
> Redefining memmove should be allowed, but then it could no longer be a 
> static function.
> Using the memmove implementation from the main kernel would be painful 
> and ugly.
> We could also define "__memmove()" plus "#define memmove __memmove", 
> which would also be ugly.
> 
>> Furthermore, we probably spend enough time copying that using a real 
>> memmove() implementation, using string instructions, would be good.
> 
> Are string instructions that much faster?
> We can also get some speedup by copying ints instead of chars.
> 

String instructions are indeed very much faster, especially on recent 
hardware where they are optimized in microcode.

In this case, I think the easiest thing to do is to provide an optimized 
memmove and not making it a static function.  I have a reasonably 
optimized memmove in 32-bit assembly at:

http://git.kernel.org/?p=boot/syslinux/syslinux.git;a=blob;f=com32/lib/memmove.S;hb=HEAD

A 64-bit implementation can be done on similar principles.

	-hpa

