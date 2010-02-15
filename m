Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab0BOVPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab0BOVPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:15:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
In-Reply-To: H. Peter Anvin's message of  Monday, 15 February 2010 12:07:50 -0800 <4B79A996.2090606@zytor.com>
References: <20100215161752.GA19962@redhat.com>
	<4B799C3F.7010308@zytor.com>
	<20100215194123.96D49FC3@magilla.sf.frob.com>
	<4B79A996.2090606@zytor.com>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Message-Id: <20100215211457.C2E143E8@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 13:14:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's entirely possible it is completely superfluous.  The patch in
> question only moves the setting.  I don't know what gdb or strace use to
> distinguish a 32-bit and a 64-bit process, which is why I thought it
> might have something to do with ptrace.

Well, whatever it that might be, they have no way to know about the
TS_COMPAT setting.  TS_COMPAT affects three things: audit_syscall_entry()
parameters, asm/syscall.h stuff, and is_compat_task()--nothing that is
directly visible from userland unless you count /proc/pid/syscall values.
Notably, that includes syscall_get_error() that is used in signal recovery.

AFAICT the only interesting use of is_compat_task() is the drivers/input stuff.


Thanks,
Roland
