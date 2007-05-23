Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbXEWOvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbXEWOvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbXEWOur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:50:47 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:54726 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbXEWOup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:50:45 -0400
Date: Wed, 23 May 2007 23:51:03 +0900 (JST)
Message-Id: <20070523.235103.128617660.anemo@mba.ocn.ne.jp>
To: mika.penttila@kolumbus.fi
Cc: torvalds@linux-foundation.org, ben.collins@ubuntu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       sam@ravnborg.org, dwmw2@infradead.org, adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <465302A9.8080701@kolumbus.fi>
References: <20070522.142929.05161433.nemoto@toshiba-tops.co.jp>
	<20070522.182739.48825006.nemoto@toshiba-tops.co.jp>
	<465302A9.8080701@kolumbus.fi>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 17:48:09 +0300, Mika_Penttilä <mika.penttila@kolumbus.fi> wrote:
> I can't see how this use of r_attend is going to work. find_elf_symbol
> compares relsym->st_value to Elf_Rela->r_attend. I think it doesn't work
> for RELA archs and even with this patch for REL.

It seems works fine with RELA archs, at least mips64.

For example, set_up_list3s is correctly reported.

WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x26358) and 'cache_reap'

Here is excerpt from readelf output.  Addend value 0x21d8 matches
st_value of its target symbol.

$ mips64-linux-readelf -sr ../build-sb1250/mm/built-in.o
Relocation section '.rela.text' at offset 0x33fe0 contains 5100 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
...
000000026358  000400000004 R_MIPS_26         0000000000000000 .init.text + 21d8
                    Type2: R_MIPS_NONE
                    Type3: R_MIPS_NONE
...
Symbol table '.symtab' contains 1652 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
...
   746: 00000000000021d8   148 FUNC    LOCAL  DEFAULT    4 set_up_list3s

---
Atsushi Nemoto
