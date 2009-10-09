Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbZJIROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbZJIROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbZJIROr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:14:47 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:37664 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247AbZJIROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:14:46 -0400
Message-ID: <4ACF6F60.6040606@msgid.tls.msk.ru>
Date: Fri, 09 Oct 2009 21:14:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF6CF8.4060204@zytor.com>
In-Reply-To: <4ACF6CF8.4060204@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin пишет:
> On 10/09/2009 07:58 AM, Cyrill Gorcunov wrote:
>> Peter and Sam CC'ed
>>
>> [Michael Tokarev - Fri, Oct 09, 2009 at 06:17:50PM +0400]
>>> Ok, finally the mystery solved.  After a week of
>>> digging.
>>>
>>> The original problem was titled "Cannot boot on
>>> a PIII Celeron", and Rafael filed a bug #14270
>>> for this.
>>>
>>> In short, what I observed was that a new kernel
>>> (2.6.31) fails to boot on a PIII Celeron machine.
>>> But changing just the CPU to plain PIII and voila,
>>> it now works.  I don't know why it behaved this
>>> way, but I found where was the problem, finally.
> 
> We should switch to printf here.  Hexadecimal constants in echo aren't
> guaranteed by POSIX.

That's what I initially proposed.  However, as Scott Olson pointed
out, there's already a fix for this:

http://lkml.org/lkml/2009/8/19/84
http://patchwork.kernel.org/patch/42564/

which uses still-non-portable /bin/echo.

(I wish I knew about it a week before now - it wasn't a pleasant week for me).

Still an interesting result.  I can understand if it failed
for systems with smaller amounts of memory, -- nope, it fails
with Celeron on a 64Mb system, but works on the same system
if I replace the CPU to a real PIII...  Fun.

/mjt
