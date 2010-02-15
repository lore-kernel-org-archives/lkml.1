Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0BOTmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:42:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0BOTmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:42:02 -0500
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
In-Reply-To: H. Peter Anvin's message of  Monday, 15 February 2010 11:10:55 -0800 <4B799C3F.7010308@zytor.com>
References: <20100215161752.GA19962@redhat.com>
	<4B799C3F.7010308@zytor.com>
X-Zippy-Says: My FAVORITE group is "QUESTION MARK & THE MYSTERIANS"...
Message-Id: <20100215194123.96D49FC3@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 11:41:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect the purpose of TS_COMPAT is actually so you can ptrace() the
> newly exec'd process (and see it as a 32-bit process!) before it returns
> to userspace.  The comment, obviously, is wrong -- that again refers to
> TIF_IA32.

I don't follow you.  TS_COMPAT does not affect ptrace.
It affects syscall-audit, but only at syscall entry time.
It affects asm/syscall.h accessors, but ptrace does not use those.
It affects whatever uses is_compat_task(), but I can't see anything
where that matters except inside some particular syscall or for
syscall restart after signals.

TS_COMPAT does not affect the syscall return machinery itself.
The return path just follows from the particular entry path.


Thanks,
Roland
