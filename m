Return-Path: <linux-kernel-owner+w=401wt.eu-S1765603AbYBNXT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765603AbYBNXT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763043AbYBNXTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:19:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762853AbYBNXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:19:38 -0500
Date: Fri, 15 Feb 2008 00:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Jakub Jelinek <jakub@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214231917.GB31883@elte.hu>
References: <20080214223553.GW24887@devserv.devel.redhat.com> <47B4D233.23110.5E1523@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B4D233.23110.5E1523@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 14 Feb 2008 at 17:35, Jakub Jelinek wrote:
> 
> > Where do you see a mispredicted branch?
> 
> try it with -Os (gentoo gcc 4.2.2):
> 
> 0000000000000000 <foo>:
>    0:   48 83 ec 58             sub    $0x58,%rsp
>    4:   65 48 8b 04 25 28 00 00 00      mov    %gs:0x28,%rax
>    d:   48 89 44 24 48          mov    %rax,0x48(%rsp)
>   12:   31 c0                   xor    %eax,%eax
>   14:   48 89 e7                mov    %rsp,%rdi
>   17:   e8 00 00 00 00          callq  1c <foo+0x1c>    18: R_X86_64_PC32       
> bar+0xfffffffffffffffc
>   1c:   48 8b 54 24 48          mov    0x48(%rsp),%rdx
>   21:   65 48 33 14 25 28 00 00 00      xor    %gs:0x28,%rdx
>   2a:   b8 06 00 00 00          mov    $0x6,%eax
>   2f:   74 05                   je     36 <foo+0x36>
>   31:   e8 00 00 00 00          callq  36 <foo+0x36>    32: R_X86_64_PC32       
> __stack_chk_fail+0xfffffffffffffffc
>   36:   48 83 c4 58             add    $0x58,%rsp
>   3a:   c3                      retq

ah, that's what my kernel uses too - and CONFIG_CC_OPTIMIZE_FOR_SIZE=y 
is the default for Fedora too.

hm, especially those big addressing mode mov's and xor's look rather 
nasty.

	Ingo
