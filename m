Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbXF1MTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbXF1MTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXF1MTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:19:14 -0400
Received: from smtpout.mac.com ([17.250.248.173]:53943 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbXF1MTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:19:13 -0400
In-Reply-To: <20070628120803.GI7012@devserv.devel.redhat.com>
References: <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <20070628035754.GB22063@parisc-linux.org> <6B8385EC-8CD4-4E8B-94EF-293A02A62189@mac.com> <20070628120803.GI7012@devserv.devel.redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A934E115-A126-45A5-AE5F-E19215DEFF5E@mac.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       Andi Kleen <ak@suse.de>, linux-arch@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 08:18:50 -0400
To: Jakub Jelinek <jakub@redhat.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, at 08:08:03, Jakub Jelinek wrote:
> On Thu, Jun 28, 2007 at 07:53:51AM -0400, Kyle Moffett wrote:
>> Oh, ok, that makes it even easier to say this with certainty:  
>> Changing the other 64-bit archs to use "long long" for their 64- 
>> bit numbers will not cause additional warnings.  I'm also almost  
>> certain there are no architectures which use "long long" for 128- 
>> bit integers. (Moreover, I can't find hardly anything which does  
>> 128-bit integers at all).
>
> unsigned long and unsigned long long have the same size, precision  
> and alignment on all LP64 arches, that's true.  But they have  
> different ranks and more importantly they mangle differently in C+ 
> +.  So, whether some user exposed type uses unsigned long or  
> unsigned long long is part of the ABI, whether that's size_t,  
> uintptr_t, uint64_t, u_int64_t or any other type, you can't change  
> it without breaking the ABI.

That sounds *extraordinarily* broken.  Hopefully this would *not*  
affect the type of a function which is passed a C "struct" containing  
the "long long", right?

Hmm, I guess the question is:  Do we support people directly passing  
__u64 to C++ functions in userspace?  I could understand, perhaps,  
passing around structures defined in the kernel headers, but  
certainly not the kernel-internal types.  The only reason we even  
export those is so we can have a private set of bit-size-defined  
types with which to define kernel ABI structures.

Cheers,
Kyle Moffett

