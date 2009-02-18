Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZBRRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZBRRLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZBRRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:11:04 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:42081 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZBRRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WXGGjXBlqT/Bdpg1VMvsXoSu2socvhDLHn924fh2AEMe/LwA7Hld4QIdEokXTp7VqX
         lb0LyOtMQJ5sfqxTbAVC4E9ilCsjFKJ7HDAvmizN1hu16XJ1J+S1Cr96t4xaMIkyC+0D
         eVrUE9UFovjsWlXV8keYt02FO5tjYDFtEQmjc=
MIME-Version: 1.0
In-Reply-To: <20090218224541.fe6e0355.sfr@canb.auug.org.au>
References: <20090218191640.0b023029.sfr@canb.auug.org.au>
	 <499BE300.5090405@in.ibm.com>
	 <20090218224541.fe6e0355.sfr@canb.auug.org.au>
Date: Wed, 18 Feb 2009 12:10:59 -0500
Message-ID: <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
From: Mike Frysinger <vapier.adi@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 06:45, Stephen Rothwell wrote:
> On Wed, 18 Feb 2009 15:59:20 +0530 "Sachin P. Sant" wrote:
>> Next Feb 18 defconfig build on s390 fails with following error.
>>
>>   CC      arch/s390/lib/string.o
>> In file included from include/linux/bitmap.h:8,
>>                  from include/linux/cpumask.h:142,
>>                  from include/linux/smp.h:12,
>>                  from /usr/local/autobench/var/tmp/build/linux/arch/s390/include/asm/spinlock.h:14,
>>                  from include/linux/spinlock.h:88,
>>                  from include/linux/seqlock.h:29,
>>                  from include/linux/time.h:8,
>>                  from include/linux/stat.h:60,
>>                  from include/linux/module.h:10,
>>                  from arch/s390/lib/string.c:13:
>> include/linux/string.h: In function 'strstarts':
>> include/linux/string.h:124: error: implicit declaration of function 'strlen'
>> include/linux/string.h:124: warning: incompatible implicit declaration of built-in function 'strlen'
>> make[1]: *** [arch/s390/lib/string.o] Error 1
>> make: *** [arch/s390/lib] Error 2
>
> That would be a side effect of commit 43a47c6ca0e0b5479ae316e188a28b7e625d41e5 ("misc:strstarts") from the rr tree.  Rusty cc'd.

breaks all Blackfin ports as well:
In file included from include/linux/bitmap.h:9,
                 from include/linux/nodemask.h:90,
                 from include/linux/mmzone.h:17,
                 from include/linux/gfp.h:5,
                 from include/linux/kmod.h:23,
                 from include/linux/module.h:14,
                 from arch/blackfin/lib/strncmp.c:14:
include/linux/string.h: In function 'strstarts':
include/linux/string.h:124: error: implicit declaration of function 'strncmp'
make[1]: *** [arch/blackfin/lib/strncmp.o] Error 1
make: *** [arch/blackfin/lib] Error 2
-mike
