Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZK2D7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZK2D7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 22:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZK2D7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 22:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZK2D7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 22:59:54 -0500
Message-ID: <4B11F1A6.9090505@redhat.com>
Date: Sat, 28 Nov 2009 22:59:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu,
       roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: + binfmt-introduce-coredump-parameter-structure.patch added to
 -mm tree
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org> <20091126174835.5A73.A69D9226@jp.fujitsu.com> <4B0EA3AA.5070003@redhat.com> <20091126165108.GA13231@redhat.com>
In-Reply-To: <20091126165108.GA13231@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 11/26, Masami Hiramatsu wrote:
>>
>> $ grep -r DUMP_WRITE arch/*/include
>> arch/ia64/include/asm/elf.h:            DUMP_WRITE(&phdr, sizeof(phdr));       \
>> arch/ia64/include/asm/elf.h:                    DUMP_WRITE((void *) gate_phdrs[\
>
> arch/um/sys-i386/asm/elf.h uses DUMP_WRITE() too.
>
>> Oops, certainly, that's a problem.
>> IMHO, we should not do like that, all parameter required by a macro should be
>> specified explicitly, since it reduces readability so much...
>> I think we'd better make those macros inline function, check it's return value
>> for error handling.
>
> Agreed, DUMP_WRITE() in its current form should die. Not only
> it has implicit parameter, it does "goto" from the macro body
> and it has multiple definitions withing the same file.
>
> But perhaps this needs a separate patch? It is not trivial to kill
> DUMP_WRITE(), you can fix this patch if you change DUMP_WRITE()
> to use cprm->file instead of file.

Hmm, certainly, that should be separated. So I just change DUMP_WRITE()
to use cprm->limit/file.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

