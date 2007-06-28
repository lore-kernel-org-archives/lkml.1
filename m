Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXF1LnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXF1LnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbXF1LnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:43:13 -0400
Received: from smtpout.mac.com ([17.250.248.184]:56646 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbXF1LnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:43:12 -0400
In-Reply-To: <200706280230.42515.ak@suse.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <200706280230.42515.ak@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <88515A48-E155-48A7-8EAE-095B080EAFE4@mac.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 07:42:46 -0400
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27, 2007, at 20:30:42, Andi Kleen wrote:
> On Thursday 28 June 2007 00:30:52 Kyle Moffett wrote:
>> The only trick is if you care about building 32-bit compat code  
>> using 64-bit linux kernel headers.  In that case we should  
>> probably just make all archs use "long long" for their 64-bit  
>> integers, unless there's some platform I'm not remembering where  
>> "long long" is 128-bits or bigger.  The other benefit is that  
>> people could then just use the printf format "%llu" for 64-bit  
>> integers instead of having to conditionalize it all over the place.
>>
>> I'm working on a patch now.
>
> Changing this will give you a zillion warnings for printk formats.

Why?  If this were a problem then we'd be getting a zillion warnings  
*now* from all the 32-bit archs (which already use "long long" for 64- 
bit.  This would actually make it _easier_ to get the printk formats  
right, as you could always use %ull for 64-bit types without having  
to cast for 64-bit platforms.

This is another way to get around the "build 32-bit-compat userspace  
on 64-bit kernel headers" problem:  It tells GCC to use the  
"smallest" available type of the given size, which ends up being  
exactly the types we use now.  On the other hand, it only works for  
GCC which sort of ruins most of the reason for changing the types in  
the first place.

typedef   signed __s8  __attribute__((__mode__(__QI__)));
typedef unsigned __u8  __attribute__((__mode__(__QI__)));
typedef   signed __s16 __attribute__((__mode__(__HI__)));
typedef unsigned __u16 __attribute__((__mode__(__HI__)));
typedef   signed __s32 __attribute__((__mode__(__SI__)));
typedef unsigned __u32 __attribute__((__mode__(__SI__)));
typedef   signed __s64 __attribute__((__mode__(__DI__)));
typedef unsigned __u64 __attribute__((__mode__(__DI__)));

Cheers,
Kyle Moffett

