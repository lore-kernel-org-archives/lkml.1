Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbYBNWpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbYBNWpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbYBNWos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:44:48 -0500
Received: from r00tworld.com ([212.85.137.21]:50389 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508AbYBNWor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:44:47 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Thu, 14 Feb 2008 23:43:47 +0200
MIME-Version: 1.0
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <47B4D233.23110.5E1523@pageexec.freemail.hu>
In-reply-to: <20080214223553.GW24887@devserv.devel.redhat.com>
References: <20080214190050.GA32258@elte.hu>, <20080214202535.GA25316@elte.hu>, <20080214223553.GW24887@devserv.devel.redhat.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 14 Feb 2008 23:42:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2008 at 17:35, Jakub Jelinek wrote:

> Where do you see a mispredicted branch?

try it with -Os (gentoo gcc 4.2.2):

0000000000000000 <foo>:
   0:   48 83 ec 58             sub    $0x58,%rsp
   4:   65 48 8b 04 25 28 00 00 00      mov    %gs:0x28,%rax
   d:   48 89 44 24 48          mov    %rax,0x48(%rsp)
  12:   31 c0                   xor    %eax,%eax
  14:   48 89 e7                mov    %rsp,%rdi
  17:   e8 00 00 00 00          callq  1c <foo+0x1c>    18: R_X86_64_PC32       
bar+0xfffffffffffffffc
  1c:   48 8b 54 24 48          mov    0x48(%rsp),%rdx
  21:   65 48 33 14 25 28 00 00 00      xor    %gs:0x28,%rdx
  2a:   b8 06 00 00 00          mov    $0x6,%eax
  2f:   74 05                   je     36 <foo+0x36>
  31:   e8 00 00 00 00          callq  36 <foo+0x36>    32: R_X86_64_PC32       
__stack_chk_fail+0xfffffffffffffffc
  36:   48 83 c4 58             add    $0x58,%rsp
  3a:   c3                      retq

