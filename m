Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZKWTxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZKWTxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbZKWTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:53:17 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3438 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbZKWTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:53:16 -0500
Date: Mon, 23 Nov 2009 12:53:20 -0700
From: Alex Chiang <achiang@hp.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Tony Luck <tony.luck@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier.adi@gmail.com>,
       greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
	kernel (__ksymtab)
Message-ID: <20091123195320.GD26810@ldl.fc.hp.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <20091104171916.GA6323@merkur.ravnborg.org> <4AF2E00A.3010107@tuffmail.co.uk> <200911091347.57286.rusty@rustcorp.com.au> <12c511ca0911201420i5f2d4751m25ae5288b69dbabb@mail.gmail.com> <4B072E31.4000906@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B072E31.4000906@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, Rusty,

* Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> Tony Luck wrote:
>> The sorted ksymtab breaks ia64 (and possibly ppc64 and
>> parisc too).

[snip]

>> The syntax you need for this* is:
>>
>>         .long @fptr(____pagevec_lru_add)
>>         .long __kstrtab____pagevec_lru_add
>>
>> Note that you must only use the @fptr(name) syntax for
>> function exports. Exported data items just need an address.
>>
>> -Tony
>>
>> * On ia64 ... powerpc and parisc might need something else.
>>   
> Thanks!  It doesn't sound too hard to retro-fit your suggestion.
>
> Still, I can't help wondering if I've done this all wrong :-/.  Perhaps  
> I should avoid the assembler.  Instead, I could write a tool to sort the  
> ksymtab elf sections in-place (and mangle their relocations  
> accordingly).  That should preserve any special handling for function  
> symbols without arch-specific special cases.  It would also concentrate  
> all the magic in one tool - rather than it being scattered between the  
> modpost tool, mod_export.h, tmp_exports.S, and vmlinux.lds.h.

In the meantime, while Alan is deciding the proper way to fix
this, would it be possible to drop the offending patch series
from linux-next?

It makes ia64 unbootable, and has ripple-through effects, since
mmotm is based on linux-next these days.

Thanks,
/ac

