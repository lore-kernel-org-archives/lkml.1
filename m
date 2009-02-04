Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZBDDHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZBDDHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBDDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:06:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:22083 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBDDGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PRBzt+1RXDjF52zsZAZqetVaOaN41iTl7b7OIstuL9UVjXadyr1NnavOIerc8LaD/f
         f1oiu54jGCNN6Z51HqCObmh7Cqka+7FiyDQGmx0RYm2yltw5+jq646quE70bY4iR/TRR
         GZrqu9EEmBhIwR9L2e3hkxIoW7qXG/LuV+sUQ=
MIME-Version: 1.0
In-Reply-To: <20090204022905.GM7199@verge.net.au>
References: <1233642168.19806.74.camel@yhuang-dev.sh.intel.com>
	 <20090204022905.GM7199@verge.net.au>
Date: Wed, 4 Feb 2009 12:06:52 +0900
Message-ID: <aec7e5c30902031906k7fe8947kc429ffc0274eb930@mail.gmail.com>
Subject: Re: [PATCH resend] kexec/x86_64: Use one page table in x86_64 
	machine_kexec
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 11:29 AM, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Feb 03, 2009 at 02:22:48PM +0800, Huang Ying wrote:
>> Impact: reduce kernel BSS size by 7 pages, improve code readability
>>
>> Two page tables are used in current x86_64 kexec implementation. One
>> is used to jump from kernel virtual address to identity map address,
>> the other is used to map all physical memory. In fact, on x86_64,
>> there is no conflict between kernel virtual address space and physical
>> memory space, so just one page table is sufficient. The page table
>> pages used to map control page are dynamically allocated to save
>> memory if kexec image is not loaded. ASM code used to map control page
>> is replaced by C code too.
>
> Hi Huang,
>
> this patch looks quite nice to me. I am CCing my former colleague Magnus
> Damm for comment. He did some work in this area a little while ago.

Thanks for the ping Simon!

I like the idea of dynamically allocating pages and writing code in C
instead of ASM. In fact, this patch is not so far away from what V2 of
my patches did a few years ago:

http://lkml.org/lkml/2006/5/24/12

For one reason or another this wasn't acceptable at that point so I
rewrote things and V4 got merged with static page tables and ASM code.

This patch is a step in the right direction IMO, but I'm not sure how
it affects the Xen dom0 implementation. Does it still work and/or does
anyone care?

Cheers,

/ magnus
