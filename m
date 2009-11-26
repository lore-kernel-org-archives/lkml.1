Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbZKZQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbZKZQ4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKZQ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:56:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZKZQ4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:56:50 -0500
Date: Thu, 26 Nov 2009 17:51:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu,
       roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: + binfmt-introduce-coredump-parameter-structure.patch added to
	-mm tree
Message-ID: <20091126165108.GA13231@redhat.com>
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org> <20091126174835.5A73.A69D9226@jp.fujitsu.com> <4B0EA3AA.5070003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0EA3AA.5070003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Masami Hiramatsu wrote:
>
> $ grep -r DUMP_WRITE arch/*/include
> arch/ia64/include/asm/elf.h:            DUMP_WRITE(&phdr, sizeof(phdr));       \
> arch/ia64/include/asm/elf.h:                    DUMP_WRITE((void *) gate_phdrs[\

arch/um/sys-i386/asm/elf.h uses DUMP_WRITE() too.

> Oops, certainly, that's a problem.
> IMHO, we should not do like that, all parameter required by a macro should be
> specified explicitly, since it reduces readability so much...
> I think we'd better make those macros inline function, check it's return value
> for error handling.

Agreed, DUMP_WRITE() in its current form should die. Not only
it has implicit parameter, it does "goto" from the macro body
and it has multiple definitions withing the same file.

But perhaps this needs a separate patch? It is not trivial to kill
DUMP_WRITE(), you can fix this patch if you change DUMP_WRITE()
to use cprm->file instead of file.

Oleg.

