Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXFFPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXFFPTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbXFFPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:18:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:10198 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170AbXFFPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=iFp3QX9mPciJoGoTYEJA2urwJb/dYBAPimFn9op5ULEEOniMZC8MndOicr6RzpkOLU8dstyp+UzvO20uf+SnE0GoUOk8Dd525kD/5d3cEJPiOXa0QwF5t26z27ka4lIWOlybljh9tZC0yP/chENsDsvwGAvcnfwOr2qfR0uCwsQ=
Message-ID: <4666D050.7010603@googlemail.com>
Date: Wed, 06 Jun 2007 17:18:40 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4666ABD4.8050402@fr.ibm.com>
In-Reply-To: <4666ABD4.8050402@fr.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater pisze:
> Hi Andrew,
> 
> When CONFIG_DEBUG_VM=y, boot on i386 and s390 (the only one tested) ends 
> with the following. 
> 
> C.
>  
> ------------[ cut here ]------------
> kernel BUG at mm/rmap.c:557!
> invalid opcode: 0000 [#1]
> CPU:    0
> EIP:    0060:[<c013cbbd>]    Not tainted VLI
> EFLAGS: 00000206   (2.6.22-rc4-mm1 #1)
> EIP is at __page_check_anon_rmap+0x21/0x28
> eax: c15bd431   ebx: c1024700   ecx: 000bffa6   edx: c15bb6d0
> esi: c1024700   edi: 01238045   ebp: c1423e9c   esp: c1423e98
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process init (pid: 1, ti=c1422000 task=c14216b0 task.ti=c1422000)
> Stack: c1024700 c1423ea8 c013d631 01238045 c1423ef8 c01392a6 c15bb6d0 c15afc40 
>        c15afa40 c15aebfc c15c3bfc bffa7000 bffa6000 bffa7000 c15bae98 c15d5e98 
>        00000000 c15afa90 c15afc90 00000000 00000002 c15d66f0 00000000 c15bb6d0 
> Call Trace:
>  [<c010282d>] show_trace_log_lvl+0x1a/0x2f
>  [<c01028dd>] show_stack_log_lvl+0x9b/0xa3
>  [<c0102a94>] show_registers+0x1af/0x280
>  [<c0102c4b>] die+0xe6/0x1e5
>  [<c0102dd3>] do_trap+0x89/0xa2
>  [<c010313e>] do_invalid_op+0x88/0x92
>  [<c024d142>] error_code+0x6a/0x70
>  [<c013d631>] page_dup_rmap+0x1b/0x21
>  [<c01392a6>] copy_page_range+0x22b/0x2d0
>  [<c01109bc>] copy_process+0x964/0xf54
>  [<c01110d1>] do_fork+0x98/0x1b8
>  [<c0100716>] sys_clone+0x33/0x39
>  [<c010226c>] syscall_call+0x7/0xb
>  =======================
> Code: 2a c0 ff 05 30 67 2f c0 5d c3 55 89 e5 53 89 c3 8b 42 3c 40 39 43 10 74 04 0f 0b eb fe 2b 4a 04 c1 e9 0c 03 4a 44 39 4b 14 74 04 <0f> 0b eb fe 5b 5d c3 55 89 e5 53 89 c3 8b 42 3c 85 c0 75 04 0f 
> EIP: [<c013cbbd>] __page_check_anon_rmap+0x21/0x28 SS:ESP 0068:c1423e98
> Kernel panic - not syncing: Attempted to kill init!
> -


Same problem here

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/mm-config2

l *__page_check_anon_rmap+0x49
0xc1075ee5 is in __page_check_anon_rmap (mm/rmap.c:557).
552              * over the call to page_add_new_anon_rmap.
553              */
554             struct anon_vma *anon_vma = vma->anon_vma;
555             anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
556             BUG_ON(page->mapping != (struct address_space *)anon_vma);
557             BUG_ON(page->index != linear_page_index(vma, address));
558     #endif
559     }
560
561     /**

I'll try to revert mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
