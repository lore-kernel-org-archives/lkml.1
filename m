Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbZBEA0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbZBEA0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZBEAZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:25:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57016 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZBEAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:25:54 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 16:25:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Kerrisk <mtk.manpages@gmail.com>, mtk.manpages@googlemail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
In-Reply-To: <20090204161816.b93a4588.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902041621360.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com> <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com> <20090204152434.c8f65d52.akpm@linux-foundation.org>
 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com> <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com> <20090204161816.b93a4588.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Andrew Morton wrote:

> On Thu, 5 Feb 2009 12:59:07 +1300
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> 
> > >> > > > What should be userspace's fallback strategy if that support is not
> > >> > > > present?
> > >> > >
> > >> > > #ifdef EFD_SEMAPHORE, maybe?
> > >> >
> > >> > That's compile-time.  People who ship binaries will probably want
> > >> > to find a runtime thing for back-compatibility.
> > >>
> > >> I dunno. How do they actually do when we add new flags, like the O_ ones?
> > >>
> > >
> > > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> > > that work in this case?
> > 
> > As youll have seen by now, Ulrich and I noted that it works.
> 
> I think you means "should work" ;)
> 
> We're talking about this, yes?
> 
> SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
> {
> 	int fd;
> 	struct eventfd_ctx *ctx;
> 
> 	/* Check the EFD_* constants for consistency.  */
> 	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
> 	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
> 
> 	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
> 		return -EINVAL;
> 
> That looks like it should work to me.

I lost you guys. On old kernels you'd get -EINVAL when using the new flag. 
Wasn't it clear? Or is there some side-band traffic in this conversation 
that I missed? :)



- Davide


