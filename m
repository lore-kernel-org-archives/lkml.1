Return-Path: <linux-kernel-owner+w=401wt.eu-S935587AbXEWQgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587AbXEWQgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXEWQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:35:54 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:37764 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759703AbXEWQfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:35:53 -0400
X-Greylist: delayed 4155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 12:35:52 EDT
Message-ID: <46545C65.3030806@kolumbus.fi>
Date: Wed, 23 May 2007 18:23:17 +0300
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: torvalds@linux-foundation.org, ben.collins@ubuntu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       sam@ravnborg.org, dwmw2@infradead.org, adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
References: <20070522.142929.05161433.nemoto@toshiba-tops.co.jp>	<20070522.182739.48825006.nemoto@toshiba-tops.co.jp>	<465302A9.8080701@kolumbus.fi> <20070523.235103.128617660.anemo@mba.ocn.ne.jp>
In-Reply-To: <20070523.235103.128617660.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Tue, 22 May 2007 17:48:09 +0300, Mika_Penttilä <mika.penttila@kolumbus.fi> wrote:
>   
>> I can't see how this use of r_attend is going to work. find_elf_symbol
>> compares relsym->st_value to Elf_Rela->r_attend. I think it doesn't work
>> for RELA archs and even with this patch for REL.
>>     
>
> It seems works fine with RELA archs, at least mips64.
>
> For example, set_up_list3s is correctly reported.
>
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x26358) and 'cache_reap'
>
> Here is excerpt from readelf output.  Addend value 0x21d8 matches
> st_value of its target symbol.
>
> $ mips64-linux-readelf -sr ../build-sb1250/mm/built-in.o
> Relocation section '.rela.text' at offset 0x33fe0 contains 5100 entries:
>   Offset          Info           Type           Sym. Value    Sym. Name + Addend
> ...
> 000000026358  000400000004 R_MIPS_26         0000000000000000 .init.text + 21d8
>                     Type2: R_MIPS_NONE
>                     Type3: R_MIPS_NONE
> ...
> Symbol table '.symtab' contains 1652 entries:
>    Num:    Value          Size Type    Bind   Vis      Ndx Name
> ...
>    746: 00000000000021d8   148 FUNC    LOCAL  DEFAULT    4 set_up_list3s
>
> ---
> Atsushi Nemoto
>
>   
So with mips64 you are lucky because the relocation symbol is .init.text 
and hence addend matches  (has to match) symbol's offset. I can't find 
any spec where it is stated that addend == address, maybe it's in mips64 
abi or something. It is quite normal to have addend of 0.

--Mika

