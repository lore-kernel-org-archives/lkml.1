Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZDXK5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZDXK5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZDXK5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:57:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38465 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDXK5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZZNl6eAFw0Aq0VgUuI2LcnGH4ybe8A2L28nV3sKjg+1ygJylknGG3AaKeuIJ26r1N+
         CUEXml41E1t388hMG5tDXCUpro85G/CcMp7dZulXwPs4wm2J8JJFHgnd4UNwV7n5Akr5
         opu0MOlP5Ph6Pov0voZIGqTJKNbZIDGo8JD3Q=
MIME-Version: 1.0
In-Reply-To: <m2tz4e5psn.fsf@igel.home>
References: <20090423193211.GA14892@redhat.com> <m2tz4e5psn.fsf@igel.home>
Date: Fri, 24 Apr 2009 12:57:09 +0200
X-Google-Sender-Auth: 47c1b6e8e0715310
Message-ID: <10f740e80904240357r63fc9d4i5f8a4e6a5530b671@mail.gmail.com>
Subject: Re: [PATCH 3/4] ptrace: remove PT_DTRACE from m68k, m68knommu
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 12:06, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
>
>> m68k sets PT_DTRACE in trap_c() but never uses it.
>>
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>>
>>  arch/m68k/kernel/traps.c            |    1 -
>>  arch/m68knommu/kernel/asm-offsets.c |    1 -
>>  arch/m68knommu/kernel/traps.c       |    1 -
>>  3 files changed, 3 deletions(-)
>>
>> --- PTRACE/arch/m68k/kernel/traps.c~DT_3_SET  2009-04-06 00:03:35.000000000 +0200
>> +++ PTRACE/arch/m68k/kernel/traps.c   2009-04-22 21:52:23.000000000 +0200
>> @@ -1057,7 +1057,6 @@ asmlinkage void trap_c(struct frame *fp)
>>       if (fp->ptregs.sr & PS_S) {
>>               if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
>>                       /* traced a trapping instruction */
>> -                     current->ptrace |= PT_DTRACE;
>
> This is supposed to be setting the TIF_DELAYED_TRACE thread flag.

This code already looks different in the m68k tree, due to your fix to
`Allow all kernel traps to be handled via exception fixups' for
ARAnyM, and some related cleanups by you and Roman.

But more interestingly, Roman's last cleanup said there's no need to
set TIF_DELAYED_TRACE?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
