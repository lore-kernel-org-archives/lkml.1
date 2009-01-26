Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZAZPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZAZPyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZAZPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:54:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:62522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZAZPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:54:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Date: Mon, 26 Jan 2009 16:53:32 +0100
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <1232496257.3123.19.camel@localhost.localdomain> <497670C6.7010304@zytor.com> <1232723900.3504.4.camel@localhost.localdomain>
In-Reply-To: <1232723900.3504.4.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261653.32856.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1//RhqMK+3dKkTeXiT2EISXw3juDE6HDHRqb2+
 bw1UEVS2zv+lcMSuxXRsl2BVAicVFaHEczODcS8yvvMEGNNrZ4
 NcQKKYuMWeeaUoKweIURw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2009, Jaswinder Singh Rajput wrote:
> 
> So who wins the race for CONFIG_64BIT and will be right candidate for
> usr/include/asm-generic/fcntl.h:
> 
> 1. #if BITS_PER_LONG == 64

namespace pollution => doesn't work

> OR
> 
> 2. #if __BITS_PER_LONG == 64

my suggestion, looks good

> 
> OR
> 
> 3. #ifdef __LP64__

Should work, but not sure if all compilers get it right

> 
> OR
> 
> 4. #if __SIZEOF_POINTER__ == 8

Never heard of this, but seems fine, probably __SIZEOF_LONG__
would be more logical (but with identical results)

> 
> OR
> 
> 5. #if LONG_MAX > 2147483647L

requires #include <stdint.h>, which pollutes the namespace => doesn't work


> OR
> 
> 6. #ifdef __64BIT

Dangerous, as explained.

	Arnd <><
