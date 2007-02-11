Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXBKQP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXBKQP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 11:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXBKQP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 11:15:57 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:19275 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXBKQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 11:15:57 -0500
Date: Sun, 11 Feb 2007 17:14:46 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070211161446.GB11547@osiris.ibm.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com> <1171103527.29713.228.camel@pmac.infradead.org> <20070210213447.GB9116@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210213447.GB9116@linux-mips.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 09:34:47PM +0000, Ralf Baechle wrote:
> On Sat, Feb 10, 2007 at 10:32:07AM +0000, David Woodhouse wrote:
> 
> > On Sat, 2007-02-10 at 11:22 +0100, Heiko Carstens wrote:
> > > Which remembers me that I think that MIPS is using the non-compat version
> > > of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
> > > syscall for some reason. Dunno. 
> > 
> > It's OK as long as the 64-bit kernel, N32 and O32 userspace all agree
> > there there's 32 bits of padding between the fields of this structure:
> > 
> > struct epoll_event {
> >         __u32 events;
> >         __u64 data;
> > };
> > 
> > I suspect it's a fairly safe bet that N32 userspace agrees; if the O32
> > ABI is different then it would need the compat syscall.
> 
> That is correct - and apparently for all ABIs because I wasn't able to find
> a compat_sys_epoll_pwait at all.

Hmm.. so you don't need to do some fancy compat conversion for the sigset_t
that gets passed? Why is that? I don't get it...
