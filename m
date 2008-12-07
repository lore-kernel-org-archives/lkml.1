Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYLGLHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYLGLHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYLGLHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:07:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYLGLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:07:41 -0500
Date: Sun, 7 Dec 2008 12:18:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Is vm86old no more implemented?
Message-ID: <20081207111858.GH6703@one.firstfloor.org>
References: <200812061043.51438.arvidjaar@mail.ru> <200812061252.51173.arvidjaar@mail.ru> <20081206102047.GG6703@one.firstfloor.org> <200812062202.30476.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812062202.30476.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 10:02:29PM +0300, Andrey Borzenkov wrote:
> On Суббота 06 декабря 2008 13:20:47 Andi Kleen wrote:
> > On Sat, Dec 06, 2008 at 12:52:43PM +0300, Andrey Borzenkov wrote:
> > > On Суббота 06 декабря 2008 11:56:03 Andi Kleen wrote:
> > > > Andrey Borzenkov <arvidjaar@mail.ru> writes:
> > > > > CONFIG_VM86 is defined; is there anything else that is needed?
> > > > > This fails both in 2.6.27.7 and in 2.6.28-rc7. I attach config
> > > > > from 2.6.28-rc7.
> > > >
> > > > It should still work. Can you double check you're running the
> > > > correct kernel? Perhaps a 64bit kernel (which doesn't implement
> > > > it).
> > >
> > > Linux cooker 2.6.28-rc7-1avb #23 Fri Dec 5 22:42:47 MSK 2008 i686
> > > Pentium III (Coppermine) GNU/Linux
> > >
> > > Anything else I can check?
> >
> > Hmm perhaps place a printk into
> > arch/x86/kernel/vm86_32.c:sys_vm86old() and see if it's reached.
> >
> 
> It is:
> 
> [  156.094049] sys_vm86old called by monitor-get-edi
> [  156.243660] sys_vm86old called by monitor-get-edi
> [  285.698333] sys_vm86old called by X
> [  285.699408] sys_vm86old called by X
> [  285.699813] sys_vm86old called by X
> 
> any chance the specific function that is invoked is not implemented? 
> Because at least X apparently does not always fail video BIOS call - how 
> can I catch which calls were successful and which failed? I understand 
> return path sys_vm86old is rather non-standard.

One relatively reliable way would be to add printks to the error
paths again.

You're right it's probabaly related to the non standard return path.
Since it's so non standard i'm not sure you can even trust strace
completely. It relies on the return path and might be slightly confused.

Easiest way to track it down if you know an old kernels which
didn't show the problem would be probably to bisect.

-Andi



-- 
ak@linux.intel.com
