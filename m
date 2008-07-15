Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbYGOOYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbYGOOYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbYGOOYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:24:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:56796 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761468AbYGOOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l/uH/eRgGWxN2AY//alJ+B4y3WStSP/n8I0iYoX2ZNuMYke0qbuDxykuyq0/pBMnPQ
         pDSv8iza0CFWYz/oU3EZYLLqDqFDmRQv/nEidwRmKp2ZED2A3+AIMv0KPaoQHgng5SCd
         pDProkte5LkXDt1Qz2UsV4A1pQT+WGzmQwXgk=
Message-ID: <8bd0f97a0807150724x8f7095dl9b5d2e203053223f@mail.gmail.com>
Date: Tue, 15 Jul 2008 10:24:05 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: linux-next: 1ea0704e (ptep_modify_prot transaction abstraction) breaks no-mmu
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <486CF610.7000905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com>
	 <486CF610.7000905@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 11:53 AM, Jeremy Fitzhardinge wrote:
> Mike Frysinger wrote:
>> the functions added to asm-generic/pgtable.h are only used by
>> mm/mprotect.c (a MMU-only file), but they were not added inside of the
>> CONFIG_MMU ifdef block.  since the functions rely on things inside of
>> CONFIG_MMU (the lines just above in pgtable.h), we get build failure
>> on all no-mmu setups:
>>  CC      init/main.o
>> In file included from include/asm/pgtable.h:94,
>>                 from include/linux/mm.h:39,
>>                 from include/asm/dma.h:39,
>>                 from include/linux/bootmem.h:8,
>>                 from init/main.c:27:
>> include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
>> include/asm-generic/pgtable.h:210: error: implicit declaration of
>> function 'ptep_get_and_clear'
>> include/asm-generic/pgtable.h:210: error: incompatible types in return
>> make[1]: *** [init/main.o] Error 1
>> make: *** [init/main.o] Error 2
>
> Uh, OK.  What does mprotect do on a nommu system?

it depends on the port.  by default, i'm pretty sure mprotect on all
nommu systems are realistically pretty much noops.  the Blackfin can
do real protection (CONFIG_MPU), but with significant performance
degradation (since the page fault handler is not in hardware nor
hardware assisted in any way).

> Would it be sufficient to
> move the definitions of __ptep_modify_prot_start/commit out of a CONFIG_MMU
> block, or provide separate no-op versions?

simply move them into CONFIG_MMU for now
-mike
