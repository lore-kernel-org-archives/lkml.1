Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZAFPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZAFPwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZAFPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:52:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZAFPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:52:21 -0500
Date: Tue, 6 Jan 2009 15:52:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Beulich <jbeulich@novell.com>, "David S. Miller" <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090106155210.GT28946@ZenIV.linux.org.uk>
References: <20090105181922.GA25622@uranus.ravnborg.org> <20090105194844.GR28946@ZenIV.linux.org.uk> <20090105195523.GB6204@uranus.ravnborg.org> <49631BF0.76E4.0078.0@novell.com> <20090106113543.GS28946@ZenIV.linux.org.uk> <20090106133442.GA14780@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106133442.GA14780@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 02:34:42PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 06, 2009 at 11:35:43AM +0000, Al Viro wrote:
> > On Tue, Jan 06, 2009 at 07:53:04AM +0000, Jan Beulich wrote:
> > 
> > > The __crc_... reference is definitely bogus - none should survive with the
> > > new .c->.o rule. Could you find out what object file they originate from?
> > 
> > So can you, by use of arcane tool known as "grep"...  It's in kernel/softirq.c
> > and that's genksyms parser being fucked in head.  Look for TYPEOF_KEYW
> > in parse.y and you'll see.  Especially amusing part is a kludge from
> > commit a89a0a2354ae666612968e254d650bfd04f11eb6...
> 
> Any feedback on what to do to make it better?
> Never used typeof myself so I do not know the exact syntax.

Same as that of sizeof.  I.e. typeof(<type-name>) or typeof <unary-expression>.

