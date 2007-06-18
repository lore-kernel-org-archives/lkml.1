Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXFRO1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXFRO1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762004AbXFRO1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:27:30 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:29242 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXFRO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:27:29 -0400
Date: Mon, 18 Jun 2007 08:27:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
In-reply-to: <fa.tGqwq8EAmSwz5rSn2D2AkvD+yt0@ifi.uio.no>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@infradead.org>,
       Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       rmk@arm.linux.org.uk
Message-id: <46769643.7010106@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.Xa4Tv0RVV3kUIdHC69Jp/LpQPcg@ifi.uio.no>
 <fa.D5W5QzyAnzzOD5Ln35+YDQKzWsE@ifi.uio.no>
 <fa.XhJVn2uLXM0A6yjcYTr2E44DELQ@ifi.uio.no>
 <fa.tGqwq8EAmSwz5rSn2D2AkvD+yt0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Mon, 2007-06-18 at 01:24 +0200, Arnd Bergmann wrote:
>> On Monday 18 June 2007, Arjan van de Ven wrote:
>>> On Sun, 2007-06-17 at 18:33 -0400, Mike Frysinger wrote:
>>>> This changes asm() to __asm__() and volatile to __volatile__ so that these
>>>> headers can be used with gcc's -std=c99.
>>> hmm but the kernel doesn't use -std=c99...
>> The byteorder headers are exported to user space through
>> include/asm-generic/Kbuild.asm, and they are used by a number
>> of other exported headers, so they should work with any
>> gcc flags that a user might want to use. 
> 
> Even those headers which are exported are _still_ kernel headers¹. The
> 'caveat emptor' principle still applies to them, and we don't have to be
> _that_ anal about it. GNU extensions (and proper C types, for that
> matter) should be acceptable, surely?

If we expect userspace apps to include them, then I would vote for no, 
not for anything outside of #ifdef __KERNEL__ in exported headers. Keep 
in mind also that C++ apps may need to include these as well and those 
extensions don't always play well in C++ mode. (Last instance I ran into 
was the ioctl argument checking macros _IOR, _IOW, etc. that create 
non-compiling code if you use them in a C++ program.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

