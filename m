Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbYF3Tvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbYF3Tvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYF3Tv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:51:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:17853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYF3TvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hSFMtgiSvtT6tIEaSfQu5bwdJZsm3v5Y7FRgKVs9z77KQtApBLVBimcUgSj8UdRmd5
         uaTcnzr7ylOUDz6dBi3ddb2EV/zkD9LtdgG/yoITnM/WQfJGbf8mcs32YneLcOgf+nBD
         Mog9nWyvPToZ+NV65y0XgCH4VhLFHMnavQKyk=
Message-ID: <19f34abd0806301251h321dce9ere61fbca01f2d4134@mail.gmail.com>
Date: Mon, 30 Jun 2008 21:51:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [git pull] core kernel fixes
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0806302145140.3297@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080630153200.GA22360@elte.hu>
	 <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>
	 <20080630182038.GA32211@elte.hu>
	 <19f34abd0806301143u2067d593kf162d7419b653a8b@mail.gmail.com>
	 <alpine.LFD.1.10.0806302145140.3297@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 9:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 30 Jun 2008, Vegard Nossum wrote:
>> On Mon, Jun 30, 2008 at 8:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > The patch was tested with our standard tests so it's certainly good in
>> > practice - but i havent specifically tried your testcase (maybe Thomas
>> > has). Can you see any problem with the fix?
>>
>> Well, what I can see is that the patch that was committed has some
>> missing changes. In Daniel's patch:
>>
>> -repeat:
>> -     spin_lock(&pool_lock);
>> +     spin_lock_irqsave(&pool_lock, flags);
>>       if (obj_pool.first) {
>>               obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
>>
>> The patch that was committed:
>>
>> -repeat:
>>         spin_lock(&pool_lock);
>>         if (obj_pool.first) {
>>                 obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
>>
>> Was it not necessary to make the pool lock irq-safe in this place?
>>
>> For reference:
>>
>> Daniel's patch: http://lkml.org/lkml/2008/6/15/27
>> Actual commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=70c85057e0bde35eb56352a293ecb5d1641a0334;hp=e6100f23375c0c71ce595d04551fa6553b611918
>
> alloc_object() is called with interrupts disabled from __debug_object_init()

Ok, thanks for clearing that up! :-)

(I'm just wary of patches that mutate when they have my name on the top...)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
