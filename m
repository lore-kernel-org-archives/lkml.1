Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYIZT52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYIZT52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYIZT5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:57:21 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2311 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYIZT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:57:20 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 15:57:20 EDT
In-Reply-To: <48DD2F68.6000609@zytor.com>
References: <20080926124222.GA49837@xs4all.nl> <48DD2F68.6000609@zytor.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <eb34240721c0b92818908672eccecf62@xs4all.nl>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
From: Joris van Rantwijk <jorispubl@xs4all.nl>
Subject: Re: Inflation of vmlinux by linker on x86_64
Date: Fri, 26 Sep 2008 21:50:11 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26 sep 2008, at 20:52, H. Peter Anvin wrote:
> Instead of adding a comment like this, we should simply rename it 
> memmove().

Yes. I tried, but it clashed with an existing memmove declaration in 
asm-x86/string_32.h.

What is the accepted solution for this?
Redefining memmove should be allowed, but then it could no longer be a 
static function.
Using the memmove implementation from the main kernel would be painful 
and ugly.
We could also define "__memmove()" plus "#define memmove __memmove", 
which would also be ugly.

> Furthermore, we probably spend enough time copying that using a real 
> memmove() implementation, using string instructions, would be good.

Are string instructions that much faster?
We can also get some speedup by copying ints instead of chars.

Joris.

