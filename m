Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0BPLiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:38:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38488 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0BPLiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:38:07 -0500
Date: Tue, 16 Feb 2010 03:37:59 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on
 anon_inode files.
Message-ID: <20100216113759.GM3714@count0.beaverton.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <20100214035205.GU30031@ZenIV.linux.org.uk>
 <20100215172635.GI3714@count0.beaverton.ibm.com>
 <20100215195728.GX30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215195728.GX30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:57:28PM +0000, Al Viro wrote:
> On Mon, Feb 15, 2010 at 09:26:35AM -0800, Matt Helsley wrote:
> > > > [PATCH 1/4] signalfd
> > > > [PATCH 2/4] timerfd
> > > > [PATCH 3/4] epoll
> > > > [PATCH 4/4] eventfd
> > > > 
> > > > I did not check the perf, kvm-vm, or kvm-vcpu uses of anon_inodes.
> > > 
> > > Er...  O_ASYNC is silently ignored for regular files as well, so any
> > > userland code that tries to rely on fcntl() rejecting it is and always
> > > had been badly b0rken.
> > 
> > Of course. Did you mean to imply that the kernel shouldn't bother to
> > reject these, or were you merely making an observation?
> 
> I'm wondering why should we start changing that behaviour and what makes
> these 4 cases special?

I'm not saying we should change behavior for regular files. We should check
these because they're already being checked inside the special syscalls that
open these files. Without these patches fcntl(F_SETFL) is a way around those
checks for these interfaces.

Cheers,
	-Matt Helsley
