Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbZGTAPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbZGTAPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZGTAPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:15:09 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:53107 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZGTAPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZS9UmfUHQ20GSN19vlR0RA/3pYl5wFvc4B+Z3XapwnzxfgFAGkmJLnhhj6JcJFjsGh
         //fRtfGrrHNirTsZ7porRrS0mMj1lLxJPHrC/Wq7tpIalFHYGollVIWDq11/NPPCC+HD
         p7lFB/M5P7j9Ijqdh5hwW9tghTCjGbDBGD5Do=
MIME-Version: 1.0
In-Reply-To: <20090719131808.77f986f3@infradead.org>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
	 <20090719131808.77f986f3@infradead.org>
Date: Sun, 19 Jul 2009 20:15:07 -0400
Message-ID: <817ecb6f0907191715v170416a8vad8bfa3b2c7f17b2@mail.gmail.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 4:18 PM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Sun, 19 Jul 2009 15:43:06 -0400
> Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
>
>> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
>> (static) kernel data area as NX.
>> The following steps are taken to achieve this:
>> 1. Linker scripts are adjusted so .text always starts and end on a
>> page boundary 2. Linker scripts are adjusted so .rodata and .data
>> always starts and end on a page boundary
>> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init_64.c and
>> arch/x86/mm/init_32.c with actual functionality: NX is set for all
>> pages from _etext through _edata
>> 4. mark_nxdata_nx() called from init_post(void) in init/main.c
>>
>> The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
>> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>
> I like the idea, and am happy to see the lack of ifdefs ;)

I was thinking about ifdefs, but could not find a place to put them in ;)

> I wonder if we should have a testcase for this though similar to
> how stackprotector and rodata get tested already....

We probably should. In addition, after looking at the code for a
while, it seems to me that the proper place to enable protection would
be kernel_physical_mapping_init(). This way the kernel could enjoy
protection from the very beginning of init, instead of turning it on
at the end.
