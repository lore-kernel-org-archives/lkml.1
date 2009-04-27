Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZD0OPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZD0OPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZD0OPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:15:20 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:43326 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZD0OPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:15:19 -0400
Date: Mon, 27 Apr 2009 10:04:47 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Bart <mmx@riz.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0904271000200.16119@qirst.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>  <egHshlwQQFE.A.KjC.JpE9JB@chimera>  <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com> <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Pekka Enberg wrote:

>   18:   4a 8b 8c eb 68 01 00    mov    0x168(%rbx,%r13,8),%rcx # l3 =
> cachep->nodelists[node];
>   1f:   00
>   20:   48 8b 16                mov    (%rsi),%rdx
>   23:   48 8b 46 08             mov    0x8(%rsi),%rax
>   27:   48 89 42 08             mov    %rax,0x8(%rdx)
>   2b:*  48 89 10                mov    %rdx,(%rax)     <-- trapping instruction
>   2e:   89 e8                   mov    %ebp,%eax
>   30:   48 c7 06 00 01 10 00    movq   $0x100100,(%rsi)
>   37:   48 c7 46 08 00 02 20    movq   $0x200200,0x8(%rsi)
>
> it seems like list_del() in free_block() explodes because because
> ->prev ("rax") of slab->list is bogus ("0000000000000cd0").

Where do I find the rest of the information regarding this report?
bugzilla does only contain a pointer to the initial report on lkml no
discussion.

Typically these oopses occur because the slab header at the beginning of a
slab is overwritten. Enable debugging. Switching to SLUB would give better
diagnostics.




