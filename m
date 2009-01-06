Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZAFNdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZAFNdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZAFNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:33:08 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60006 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAFNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:33:07 -0500
Date: Tue, 6 Jan 2009 14:34:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Beulich <jbeulich@novell.com>, "David S. Miller" <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090106133442.GA14780@uranus.ravnborg.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <20090105194844.GR28946@ZenIV.linux.org.uk> <20090105195523.GB6204@uranus.ravnborg.org> <49631BF0.76E4.0078.0@novell.com> <20090106113543.GS28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106113543.GS28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:35:43AM +0000, Al Viro wrote:
> On Tue, Jan 06, 2009 at 07:53:04AM +0000, Jan Beulich wrote:
> 
> > The __crc_... reference is definitely bogus - none should survive with the
> > new .c->.o rule. Could you find out what object file they originate from?
> 
> So can you, by use of arcane tool known as "grep"...  It's in kernel/softirq.c
> and that's genksyms parser being fucked in head.  Look for TYPEOF_KEYW
> in parse.y and you'll see.  Especially amusing part is a kludge from
> commit a89a0a2354ae666612968e254d650bfd04f11eb6...

Any feedback on what to do to make it better?
Never used typeof myself so I do not know the exact syntax.

> 
> > The others look like a tools side behavioral difference, as I never saw any
> > such. Is this problem sparc32-specific (I tested x86 and ia64 only)? What's
> > the binutils version used?
> 
> 2.18.50.0.6.
> 
> And no, it's not tools side.  What it is, AFAICT, is that sparc32 has
> LDFLAGS_vmlinux = -r, which leaves a metric arseload of relocs that
> wouldn't have survived into vmlinux otherwise.  Look at .rela__ksymtab
> in .tmp_vmlinux1, for example...

The use of -r is to support the btfixup magic.
I have been thinking of moving the btfixup phase so it happens _before_
the final link of vmlinux. This should help us here.

But I never managed to really understand what the btfixup thing is all
about and has then been sidetracked by funnier stuff.

	Sam


