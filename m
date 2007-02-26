Return-Path: <linux-kernel-owner+w=401wt.eu-S964965AbXBZMm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965AbXBZMm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965076AbXBZMm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:42:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965AbXBZMm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:42:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070226120154.GD3386@elf.ucw.cz> 
References: <20070226120154.GD3386@elf.ucw.cz>  <45E09989.5070604@google.com> <45DFB1C7.1030205@google.com> <45D5B2E3.3030607@hitachi.com> <17044.1172311335@redhat.com> <2910.1172490554@redhat.com> 
To: Pavel Machek <pavel@ucw.cz>
Cc: Markus Gutschke <markus@google.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Feb 2007 12:42:01 +0000
Message-ID: <5412.1172493721@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> By same argument, we should just give up the coredumping in kernel. It
> is rarely tested, so someone will just get it wrong.

Not so rare...  Lots of people still use Evolution after all:-)

However, to counter your point, I'll point out that there's just one main code
path to do coredumping in the kernel (for ELF; there are other binfmts that do
coredumping too), as opposed to lots of applications all trying to set up
coredumping themselves.

> Remember: we are having people with huge apps, and therefore huge
> coredumps. They want to hack a kernel in ugly way to make their dumps
> smaller.

MMAP_NODUMP or  MADV_NODUMP might be better.  Let the apps mark out for
themselves what they want.

> ...but there's better solution for them, create (& debug) userland
> coredumping library. No need to hack a kernel.

Actually, a better way to do this may be similar the way I assume Windows to
work.  On fatal fault: start up a debugger and PT_ATTACH corpse to it.  The
debugger could then be something that'll just save the core.  No need to make
sure you link in the core dumping library which might not catch the event if
it's bad enough as it's working from *inside* the program, and so is subject
to being corrupted by beserk code.

David
