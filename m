Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXC0X3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXC0X3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXC0X3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:29:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43525 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbXC0X3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:29:09 -0400
Message-ID: <4609A8C4.6010803@us.ibm.com>
Date: Tue, 27 Mar 2007 16:29:08 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3
X-Accept-Language: en-us
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Badari Pulavarty <pbadari@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-rc5-mm1
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com> <20070327084838.34dc1b84.akpm@linux-foundation.org> <1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com> <20070327131214.656e1ad7.akpm@linux-foundation.org> <46098CBE.7010807@cosmosbay.com> <20070327144031.ef75dd53.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:

>On Tue, 27 Mar 2007 23:29:34 +0200
>Eric Dumazet <dada1@cosmosbay.com> wrote:
>
>>Andrew Morton a écrit :
>>
>>>The wheel spins around, slows then settles on.... 
>>>time-smp-friendly-alignment-of-struct-clocksource.patch!
>>>
>>>Presumably because the ____cacheline_aligned made vsyscall_gtod_data_t get
>>>too big.  Or something.
>>>
>>Very strange, since here I have plenty of available room (256 bytes) :
>>
>>ffffffffff600000 T vgettimeofday
>>ffffffffff60004e t vsysc2
>>ffffffffff600140 t vread_hpet
>>ffffffffff600150 t vread_tsc
>>ffffffffff600180 D __vsyscall_gtod_data
>>ffffffffff600280 D __vgetcpu_mode
>>ffffffffff6002c0 D __jiffies
>><lot of space (256 bytes)>
>>ffffffffff600400 T vtime
>>ffffffffff600413 t vsysc1
>>ffffffffff600800 T vgetcpu
>>ffffffffff600c00 T venosys_1
>>
>>It must depends on the compiler, and/or CONFIG_XXX options...
>>
>
>Badari's config triggered it for me.
>
>>Anyway, I think we can safely move __vgetcpu_mode & __jiffies to the 1024 
>>bytes area dedicated to vgetcpu() implementation. This saves 128 bytes from 
>>vsyscall_0 area.
>>
>>Could we add this patch instead of dropping 
>>time-smp-friendly-alignment-of-struct-clocksource.patch ?
>>
>
>When you tell me it works OK with Badari's config ;)
>
Yes. It did fix my problem.

Thanks,
Badari

>



