Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbZBEASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbZBEASy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbZBEASl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:18:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760615AbZBEASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:18:39 -0500
Date: Wed, 4 Feb 2009 16:18:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mtk.manpages@gmail.com
Cc: mtk.manpages@googlemail.com, davidel@xmailserver.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Message-Id: <20090204161816.b93a4588.akpm@linux-foundation.org>
In-Reply-To: <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	<20090204150507.665b5b7c.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	<20090204152434.c8f65d52.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
	<20090204155514.6abbdc8f.akpm@linux-foundation.org>
	<cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 12:59:07 +1300
Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> >> > > > What should be userspace's fallback strategy if that support is not
> >> > > > present?
> >> > >
> >> > > #ifdef EFD_SEMAPHORE, maybe?
> >> >
> >> > That's compile-time.  People who ship binaries will probably want
> >> > to find a runtime thing for back-compatibility.
> >>
> >> I dunno. How do they actually do when we add new flags, like the O_ ones?
> >>
> >
> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
> > that work in this case?
> 
> As youll have seen by now, Ulrich and I noted that it works.

I think you means "should work" ;)

We're talking about this, yes?

SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
{
	int fd;
	struct eventfd_ctx *ctx;

	/* Check the EFD_* constants for consistency.  */
	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);

	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
		return -EINVAL;

That looks like it should work to me.
