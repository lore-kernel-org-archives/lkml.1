Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZGJPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZGJPve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZGJPvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:51:25 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:46486 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbZGJPvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CVoaKYckdU/57143doOZFWYO388VcmiXY2SGmA2VMjlS5OYw5EvBQEkLg7ty0m1W3B
         dKMbBr3w/fWRKBFxRL+Y9zbJD1ySxCm/P31nhPPGVKBJvTwQruMXU8gNs7uwfbVYYOX9
         +kAagbuu9slNQw7npCLXqsJdgxURymp/GI0Ls=
MIME-Version: 1.0
In-Reply-To: <1247159251.7529.1.camel@twins>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> 
	<1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> 
	<1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com> 
	<1247078164.16156.18.camel@laptop> <20090709043931.GA11391@redhat.com> 
	<1247126556.9777.323.camel@twins> <20090709161059.GA2909@redhat.com> 
	<1247159251.7529.1.camel@twins>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Fri, 10 Jul 2009 16:50:59 +0100
Message-ID: <a5d9929e0907100850x4acc9e68s182f29ca912d24db@mail.gmail.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "joerg.roedel" <joerg.roedel@amd.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 6:07 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Thu, 2009-07-09 at 12:10 -0400, Dave Jones wrote:
>> On Thu, Jul 09, 2009 at 10:02:36AM +0200, Peter Zijlstra wrote:
>>  > On Thu, 2009-07-09 at 00:39 -0400, Dave Jones wrote:
>>  > > On Wed, Jul 08, 2009 at 08:36:04PM +0200, Peter Zijlstra wrote:
>>  > >  > Looking at a lockdep dump hch gave me I can see that that is certainly
>>  > >  > possible, I see tons of very deep callchains.
>>  > >  >
>>  > >  > /me wonders if we're getting significantly deeper..
>>  > >
>>  > > Looking at /proc/lockdep, I'm curious..
>>  > > Take a look at http://davej.fedorapeople.org/lockdep
>>  > > scroll down to c12c0924
>>  > >
>>  > > What's up with all those old_style_spin_init's ?
>>  >
>>  > What kernel are you running?
>>
>> ..31rc2
>>
>>  > Does your lib/dma_debug.c:dma_debug_init()
>>  > have spin_lock_init() in that HASH_SIZE loop?
>>
>> it's doing it by hand..
>>
>>  717         for (i = 0; i < HASH_SIZE; ++i) {
>>  718                 INIT_LIST_HEAD(&dma_entry_hash[i].list);
>>  719                 dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
>>  720         }
>
> Hmm, that's the problem, it should read:
>
>        for (i = 0; i < HASH_SIZE; ++i) {
>                INIT_LIST_HEAD(&dma_entry_hash[i].list);
>                spin_lock_init(&dma_entry_hash[i].lock);
>        }
>
> and does in -tip, so maybe Ingo took that patch, but I thought Joerg
> would push that Linus wards. Joerg?
>
>

Indeed, changing to spin_lock_init keeps the values at a much
healthier value, and the warnings do not trigger anymore. Thanks for
looking into this.

Disregard my patch submission please.

Joao Correia
