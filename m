Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbYBGVly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbYBGVly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbYBGVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:39:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:59619 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbYBGVjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:date:in-reply-to:message-id:user-agent:mime-version:content-type:from;
        b=YgZAtXB/dalJ4j53Nzf9gu7FUfMxeXxXoj44O5mqOt5bZ+XvObp80/2RjkwmU9H+8nIZDVdgfn5Qm1Y4Biw8CcnqFz4BcLKEGLL52/klrrSIFdGossVoY35ymzKmtRQH46pwQYD+Sbl+HA8mfWQgj0ZIRxZtZaui8v7JU/81MeM=
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harald Arnesen <skogtun.linux@gmail.com>, FUJITA Tomonori <tomof@acm.org>,
       akpm@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: Latest git oopses during boot
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	<20080207020214.0f0cf1c7.akpm@linux-foundation.org>
	<8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
	<20080207233239Z.tomof@acm.org>
	<8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
	<alpine.LFD.1.00.0802070956380.2883@woody.linux-foundation.org>
	<8120cfd40802071248x20ed938dh52cd9e314219613b@mail.gmail.com>
	<alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
Date: Thu, 07 Feb 2008 22:39:45 +0100
In-Reply-To: <alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 7 Feb 2008 13:14:25 -0800 (PST)")
Message-ID: <87hcgkzbry.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Harald Arnesen <skogtun.harald@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 7 Feb 2008, Harald Arnesen wrote:
>> >
>> > Can you do a
>> >
>> >         make drivers/scsi/advansys.lst
>> >
>> > and see what it should be?
>> 
>> Anyway, here it is, as an attachment.
>
> Ok, I was wrong. The code really *does* compile to that insane
>
> 	a3 14 00 00 00          mov    %eax,0x14
>
> by your compiler.
>
> That's the
>
> 	asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
>
> thing, and gcc seems to have decided that it can statically prove that 
> asc_dvc_varp is NULL.
>
> Quite frankly, I don't see that being true. But you have some patches in 
> your tree that I haven't followed, so.. Are you sure the patches applied 
> to the right spot? The patch I saw added that kzalloc() to the _end_ of 
> the function (long after asc_dvc_varp was initialized), maybe that one got 
> mis-applied?
>
> Or maybe your compiler version is simply totally broken.
>
> 			Linus

I'll try applying the patch to a freshly downloaded git-tree.

Shall I try another compiler? I have at least these two:

gcc version 3.4.6 (Ubuntu 3.4.6-6ubuntu2)
gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)

in addition to the self-compiled 4.2.3 I used for the tests.
-- 
Hilsen Harald.
