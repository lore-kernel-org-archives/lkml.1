Return-Path: <linux-kernel-owner+w=401wt.eu-S966599AbXEGUxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966599AbXEGUxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966557AbXEGUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:53:01 -0400
Received: from [212.12.190.232] ([212.12.190.232]:32993 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966542AbXEGUxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:53:00 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Execute in place
Date: Mon, 7 May 2007 23:56:51 +0300
User-Agent: KMail/1.5
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200705030211.36293.a1426z@gawab.com> <200705072237.33217.a1426z@gawab.com> <463F80E3.8020204@zytor.com>
In-Reply-To: <463F80E3.8020204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072356.51283.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > H. Peter Anvin wrote:
> >> Al Boldi wrote:
> >>> Isn't everything really just temporary?
> >>>
> >>> Would something like an mmap'd tmpfs be possible?
> >>
> >> No.  tmpfs relies on being able to leave data structures in the running
> >> kernel.  In particular, it has no metadata store at all.
> >>
> >> The needs for a persistent filesystem are very different, regardless of
> >> what the underlying medium is.
> >
> > Think Suspend-To-Disk; in that case tmpfs looks pretty persistent to me.
> >
> > So what does STD do?  It pushes memory out to swap.
>
> It pushes ALL of (used) memory out to swap.

Ok.

> > Now, tmpfs could probably do the same thing on its own either to a
> > private swap or an mmap.  I am suggesting mmap, as swap is currently
> > really slow with tmpfs, and switching it to use mmap may buy us 2 for
> > the price of 1.
>
> No.
>
> First of all, it would have to map ALL of kernel memory, or you would
> have to change the way things like dentries, inodes, and namespaces are
> allocated in the kernel itself.

That's probably one way of doing it.

> Second, you still would have no stability across kernel versions.

No problem.  You could probably convince the user to do a tmpfs backup before 
an upgrade.

> Third, you would have to accept total data loss on unclean shutdown,
> because tmpfs doesn't care about coherency, *NOR SHOULD IT*.

I think that's understood.  But this risk could be reduced by instantiating 
the latest sync'd mmap/swap.

> This is
> the fundamental reason why allocating a large swap partition and making
> /tmp a tmpfs can give a *huge* performance boost, even though it still
> hits disk.

Don't know what you mean here.  Do you mean that tmpfs performance is 
dependent on free swap-space being larger than some threshold.  If so, what 
threshold causes a tmpfs slowdown?

> What you're talking about is, *and should be*, a different filesystem.
> You will relatively quickly find that you have to deal with the same
> kind of stuff that you have to in any filesystem.

That's exactly what I want to avoid, as this would introduce a performance 
penalty.

All we need is a periodically synced tmpfs to mmap, with a minimal stream 
into page-cache algo on mount.


Thanks!

--
Al

