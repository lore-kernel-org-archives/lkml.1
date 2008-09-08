Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYIHTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYIHTzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIHTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:55:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYIHTzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:55:40 -0400
Date: Mon, 8 Sep 2008 12:55:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080908125525.72bc1ad2@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com>
	<20080908114619.741b6786@infradead.org>
	<48C57439.3040903@zytor.com>
	<20080908190249.GA21998@elte.hu>
	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 12:30:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> I think there are realistically three classes:
> 
>  - _really_ old, to the point of being totally useless for SMP.
> 
>    This is really just 386 and clones. We _need_ a working WP for a 
>    race-free access_ok(), and we need cmpxchg (and lately xadd).
> 
>    Smaller pains even on UP: bswap doesn't exist. invlpg doesn't
> exist. 

I'd lump all cpus that don't have cpuid in this bucket too (eg half the
486es) simply because not having cpuid is painful in pretty much the
same way.

>  - old. pre-cmov. i486 and pentium, and some clones.

makes sense
 
>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>    granted.

again makes sense; question is if it makes sense to take PSE and PAE
for granted as well (although PSE we can do runtime I suppose)

> Hmm? Doesn't that sound like a sane model?

it does to me; the only question is if we hit a new bucket with the
various fancy string instructions that are in upcoming models; doing
string/copy operations inlined for those guys will make a fourth bucket.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
