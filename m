Return-Path: <linux-kernel-owner+w=401wt.eu-S1764114AbZAQWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764114AbZAQWEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZAQWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:04:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbZAQWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:04:10 -0500
Date: Sat, 17 Jan 2009 23:04:06 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, linux-media@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-raid@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
In-Reply-To: <1232228261.27094.0.camel@macbook.infradead.org>
Message-ID: <alpine.LSU.2.00.0901172301380.14505@fbirervta.pbzchgretzou.qr>
References: <1232223441.3966.22.camel@localhost.localdomain> <1232228261.27094.0.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2009-01-17 22:37, David Woodhouse wrote:
>On Sun, 2009-01-18 at 01:47 +0530, Jaswinder Singh Rajput wrote:
>> --- a/include/linux/dvb/audio.h
>> +++ b/include/linux/dvb/audio.h
>> @@ -24,9 +24,8 @@
>>  #ifndef _DVBAUDIO_H_
>>  #define _DVBAUDIO_H_
>>  
>> -#ifdef __KERNEL__
>>  #include <linux/types.h>
>> -#else
>> +#ifndef __KERNEL__
>>  #include <stdint.h>
>>  #endif
>
>That patch looks wrong, and unnecessary. It was fine before.

What itches my eye is

#ifndef __KERNEL__
#include <stdint.h>
#endif

I am not sure how much Linux header files are supposed to be usable
from C++, but in case someone does, <cstdint> should be used in C++0x
mode. Testing for C++0x with macros however looks even more out of
place in such header files.
Thoughts?
