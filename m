Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0BRCH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:07:57 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:35135 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0BRCHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.1.10.0807261221480.4188@nehalem.linux-foundation.org>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi> 
	<20080725015537.564e3397.akpm@linux-foundation.org> <20080725091455.GD19310@cs181140183.pp.htv.fi> 
	<20080725092748.GF19310@cs181140183.pp.htv.fi> <20080725023455.dde3eb27.akpm@linux-foundation.org> 
	<20080725122454.GE6701@parisc-linux.org> <alpine.LFD.1.10.0807261221480.4188@nehalem.linux-foundation.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 17 Feb 2010 19:07:34 -0700
X-Google-Sender-Auth: 5ce9203173b29d52
Message-ID: <fa686aa41002171807s71ac7176l769d78e2bb5d9a1@mail.gmail.com>
Subject: Re: __weak vs ifdef
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Andrea Righi <righi.andrea@gmail.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reaching back into an old discussion....

On Sat, Jul 26, 2008 at 12:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 25 Jul 2008, Matthew Wilcox wrote:
>
>> On Fri, Jul 25, 2008 at 02:34:55AM -0700, Andrew Morton wrote:
>> > We should make arch_pick_mmap_layout __weak and nuke that ifdef.
>>
>> I strongly disagree.  I find it makes it harder to follow code flow
>> when __weak functions are involved.  Ifdefs are ugly, no question, but
>> they're easier to grep for
>
> Hell no, they're not.
>
> Our use of random HAVE_ARCH_xyz or ARCH_SUPPORTS_xyz etc stuff makes
> things _totally_ impossible to grep for.
>
> In contrast, it we did this code as
>
>        #ifndef arch_pick_mmap_layout
>        void __weak arch_pick_mmap_layout(struct mm_struct *mm)
>        {
>                mm->mmap_base = TASK_UNMAPPED_BASE;
>                mm->get_unmapped_area = arch_get_unmapped_area;
>                mm->unmap_area = arch_unmap_area;
>        }
>        #endif
>
> then trying to grep for arch_pick_mmap_layout() would show EVERY SINGLE
> RELEVANT CASE! And it would show the "__weak" there too, so that once
> people get used to this convention, they'd have a really easy time
> figuring out the rules from just the output of the 'grep'.
[...]

Question.  If I use this pattern, and use the __weak attribute on core
code functions wrapped with a #ifndef, then how does it mesh with
EXPORT_SYMBOL*() statements?  Do both the core code, and the arch
override need to do EXPORT_SYMBOL(), or should EXPORT_SYMBOL() only
appear at the core code site?

I also assume that at the core code site, the EXPORT_SYMBOL() must
appear inside the #ifndef block so that a #define override doesn't
break things.  Correct?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
