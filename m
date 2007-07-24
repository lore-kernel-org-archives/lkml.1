Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbXGXDxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbXGXDxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762067AbXGXDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:53:25 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:26037 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763214AbXGXDxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:53:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=E76/75ndv5m9meCULjqcARoCxZvK9ziqNPjn24AhN9MVerZVNikS73PjksiHCGVp7OeghL4pZrRNCgUvOLVR2oaAeSznutCSpXfKq0CCn0u8VDwYheHnrAUGQ+F56uLckiegda0qE64dUxlGqKa+zIXRM1el2FLTe0S5E1Zwm2A=  ;
X-YMail-OSG: d4Czj1wVM1m8HxWYzbNnMK_9WQ3LiL6ARFvKypzV_jZ9W3tohtW.JPVTggN0LZryEtBMKXP3F43hweDaMO13WaLVYzIr
Message-ID: <46A577AA.4020804@yahoo.com.au>
Date: Tue, 24 Jul 2007 13:53:14 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions
> 
>>From Documentation/atomic_ops.txt, those archs that require explicit
> memory barriers around clear_bit() must also implement these two interfaces.
> However, for i386, clear_bit() is a strict, locked, atomic and
> un-reorderable operation and includes an implicit memory barrier already.
> 
> But these two functions have been wrongly defined as "barrier()" which is
> a pointless _compiler optimization_ barrier, and only serves to make gcc
> not do legitimate optimizations that it could have otherwise done.
> 
> So let's make these proper no-ops, because that's exactly what we require
> these to be on the i386 platform.

No. clear_bit is not a compiler barrier on i386, thus smp_mb__before/after
must be.


> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> 
> ---
> 
> [ A similar optimization needs to be done in the atomic.h also.
>   Will submit that patch shortly. ]
> 
>  include/asm-i386/bitops.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
> index 4f1fda5..42999eb 100644
> --- a/include/asm-i386/bitops.h
> +++ b/include/asm-i386/bitops.h
> @@ -106,8 +106,8 @@ static inline void __clear_bit(int nr, unsigned long *addr)
>   * Bit operations are already serializing on x86.
>   * These must still be defined here for API completeness.
>   */
> -#define smp_mb__before_clear_bit()	barrier()
> -#define smp_mb__after_clear_bit()	barrier()
> +#define smp_mb__before_clear_bit()	do {} while (0)
> +#define smp_mb__after_clear_bit()	do {} while (0)
>  
>  /**
>   * __change_bit - Toggle a bit in memory
> 


-- 
SUSE Labs, Novell Inc.
