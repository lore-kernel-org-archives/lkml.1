Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZGCSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZGCSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZGCSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:24:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57918 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZGCSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:24:20 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
	<tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
	<4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu>
	<20090703111033.6e9627de@infradead.org>
Date: Fri, 03 Jul 2009 20:24:22 +0200
In-Reply-To: <20090703111033.6e9627de@infradead.org> (Arjan van de Ven's message of "Fri, 3 Jul 2009 11:10:33 -0700")
Message-ID: <87ocs1aall.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Fri, 3 Jul 2009 20:04:50 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> > +static inline u64 atomic64_read(atomic64_t *ptr)
>> > +{
>> > +	u64 res;
>> > +
>> > +	asm volatile(
>> > +		"mov %%ebx, %%eax\n\t"
>> > +		"mov %%ecx, %%edx\n\t"
>> > +		LOCK_PREFIX "cmpxchg8b %1\n"
>
> also afaik cmpxchg implies the lock prefix, so no need to make an
> explicit one... it just adds code size and alternatives-work

No it doesn't; LOCK is implied for "xchg", but not for cmpxchg

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
