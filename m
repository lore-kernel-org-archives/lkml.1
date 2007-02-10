Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXBKCvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXBKCvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXBKCvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:51:17 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:59939 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbXBKCuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:50:54 -0500
Date: Sat, 10 Feb 2007 21:34:47 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070210213447.GB9116@linux-mips.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com> <1171103527.29713.228.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171103527.29713.228.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 10:32:07AM +0000, David Woodhouse wrote:

> On Sat, 2007-02-10 at 11:22 +0100, Heiko Carstens wrote:
> > Which remembers me that I think that MIPS is using the non-compat version
> > of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
> > syscall for some reason. Dunno. 
> 
> It's OK as long as the 64-bit kernel, N32 and O32 userspace all agree
> there there's 32 bits of padding between the fields of this structure:
> 
> struct epoll_event {
>         __u32 events;
>         __u64 data;
> };
> 
> I suspect it's a fairly safe bet that N32 userspace agrees; if the O32
> ABI is different then it would need the compat syscall.

That is correct - and apparently for all ABIs because I wasn't able to find
a compat_sys_epoll_pwait at all.

Unfortunately struct epoll_event contains a gap so it bets on identical
padding rules between native and compat ABI and anyway, padding is wasted
space so the struct members should have been swapped when this structure
was created.  Oh well, too late.

  Ralf
