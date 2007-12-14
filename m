Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXLNPiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXLNPiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXLNPiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:38:15 -0500
Received: from smtp2f.orange.fr ([80.12.242.152]:46829 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbXLNPiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:38:14 -0500
X-ME-UUID: 20071214153812126.1EBE47000086@mwinf2f27.orange.fr
Message-ID: <4762A35C.8020901@cosmosbay.com>
Date: Fri, 14 Dec 2007 16:38:04 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
References: <20071213222044.GH21616@stusta.de> <20071214152454.GR17536@waste.org>
In-Reply-To: <20071214152454.GR17536@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall a écrit :
> On Thu, Dec 13, 2007 at 11:20:44PM +0100, Adrian Bunk wrote:
>   
>> I tried the following patch with a full x86 .config [1]:
>>
>> --- a/include/asm-x86/cache.h
>> +++ b/include/asm-x86/cache.h
>> -#define __read_mostly __attribute__((__section__(".data.read_mostly")))
>> +/* #define __read_mostly __attribute__((__section__(".data.read_mostly"))) */
>>
>> The result [2,3] was:
>>
>> -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
>> -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
>>
>> It's not a surprise that the kernel can become bigger when __read_mostly 
>> gets used, especially in cases where __read_mostly prevents gcc 
>> optimizations.
>>
>> My question is:
>> Is there anywhere in the kernel a case where __read_mostly brings a 
>> measurable improvement or can it be removed?
>>     
>
> Yes, but perhaps we can put it under CONFIG_BASE_FULL?
>
>   
Yes, we probably can do something like that (in addition to !CONFIG_SMP)





