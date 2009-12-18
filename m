Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbZLRXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbZLRXSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZLRXSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:18:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49989 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZLRXSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:18:37 -0500
Message-ID: <339143df87bf5d7afe89b9b2fe8af031.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20091218184504.GA675@elte.hu>
References: <20091217175338.GL9804@basil.fritz.box>
    <20091217190804.GB6788@linux.vnet.ibm.com>
    <20091217195530.GM9804@basil.fritz.box>
    <alpine.DEB.2.00.0912171356020.4640@router.home>
    <1261080855.27920.807.camel@laptop>
    <alpine.DEB.2.00.0912171439380.4640@router.home>
    <20091218051754.GC417@elte.hu> <4B2BB52A.7050103@redhat.com>
    <20091218171240.GB1354@elte.hu>
    <alpine.DEB.2.00.0912181207010.26947@router.home>
    <20091218184504.GA675@elte.hu>
Date: Sat, 19 Dec 2009 08:18:33 +0900 (JST)
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Avi Kivity" <avi@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Christoph Lameter <cl@linux-foundation.org> wrote:
>
>> > We've been through this many times in the past within the kernel: many
>> > times when we hid some locking primitive within some clever wrapping
>> > scheme the quality of locking started to deteriorate. In most of the
>> > important cases we got rid of the indirection and went with an
>> existing
>> > core kernel locking primitive which are all well known and have clear
>> > semantics and lead to more maintainable code.
>>
>> The existing locking APIs are all hiding lock details at various levels.
>> We
>> have various specific APIs for specialized locks already Page locking
>> etc.
>
> You need to loo at the patches. This is simply a step backwards:
>
> -               up_read(&mm->mmap_sem);
> +               mm_read_unlock(mm);
>
> because it hides the lock instance.
>
After rewriting speculative-page-fault patches, I feel I can do it
without mm_accessor, by just skipping mmap_sem in fault.c. Then, original
problem I tried to fix, false sharing at multithread page fault, can be
fixed without this.

Then, I myself stop this.

About range-locking of mm_struct, I don't find any good approach.

Sorry for annoying and thank you all.
-Kame






