Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZAWPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZAWPTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZAWPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:19:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:51182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZAWPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:19:07 -0500
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <497670C6.7010304@zytor.com>
References: <1232496257.3123.19.camel@localhost.localdomain>
	 <20090120.161626.93641145.davem@davemloft.net> <497670C6.7010304@zytor.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 20:48:20 +0530
Message-Id: <1232723900.3504.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 16:48 -0800, H. Peter Anvin wrote:
> David Miller wrote:
> > From: Jaswinder Singh Rajput <jaswinder@kernel.org>
> > Date: Wed, 21 Jan 2009 05:34:17 +0530
> > 
> >> usr/include/asm-generic/fcntl.h is giving 2 'make headers_check' warnings:
> >>  usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
> >>  usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid
> >>
> >> usr/include/asm-generic/fcntl.h:
> > ...
> >> #ifndef CONFIG_64BIT will always be true for userspace. So what is the use of #ifndef CONFIG_64BIT ?
> > 
> > Good catch.
> > 
> > This file needs to test for 64-bit'ness using some non-CONFIG_*
> > test.  And the standard built-in CPP macros which can be used
> > to check for that are different on every platform.
> > 
> 
> There are a few ways to check for 64-bitness that are 
> platform-independent, unfortunately each of them have drawbacks.
> 

So who wins the race for CONFIG_64BIT and will be right candidate for
usr/include/asm-generic/fcntl.h:

1. #if BITS_PER_LONG == 64

OR

2. #if __BITS_PER_LONG == 64

OR

3. #ifdef __LP64__

OR

4. #if __SIZEOF_POINTER__ == 8

OR

5. #if LONG_MAX > 2147483647L

OR

6. #ifdef __64BIT


Thanks
--
JSR

