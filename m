Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYFZK56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYFZK56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZK5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:57:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35470 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYFZK5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:57:47 -0400
Date: Thu, 26 Jun 2008 12:57:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Message-ID: <20080626105722.GA12640@elte.hu>
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4862A6A9.1030109@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> It quickly broke the build in testing:
>>
>>  include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
>>  include/asm/pgalloc.h:14: error: parameter name omitted
>>  arch/x86/kernel/entry_64.S: In file included from  
>> arch/x86/kernel/traps_64.c:51:include/asm/pgalloc.h: In function 
>> ‘paravirt_pgd_free':
>>  include/asm/pgalloc.h:14: error: parameter name omitted
>>   
>
> No, looks like my fault.  The non-PARAVIRT version of  
> paravirt_pgd_free() is:
>
> static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *) {}
>
> but C doesn't like missing parameter names, even if unused.
>
> This should fix it:

that fixed the build but now we've got a boot crash with this config:

 time.c: Detected 2010.304 MHz processor.
 spurious 8259A interrupt: IRQ7.
 BUG: unable to handle kernel NULL pointer dereference at  0000000000000000
 IP: [<0000000000000000>]
 PGD 0
 Thread overran stack, or stack corrupted
 Oops: 0010 [1] SMP
 CPU 0

with:

  http://redhat.com/~mingo/misc/config-Thu_Jun_26_12_46_46_CEST_2008.bad

i've pushed out the current tip/xen-64bit branch, so that you can see 
how things look like at the moment, but i cannot put it into tip/master 
yet.

	Ingo
