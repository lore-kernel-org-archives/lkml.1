Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0BOR0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:26:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42351 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0BOR0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:26:38 -0500
Date: Mon, 15 Feb 2010 09:26:35 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on
 anon_inode files.
Message-ID: <20100215172635.GI3714@count0.beaverton.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <20100214035205.GU30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214035205.GU30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 03:52:05AM +0000, Al Viro wrote:
> On Sat, Feb 13, 2010 at 04:27:43PM -0800, Matt Helsley wrote:
> > anon_inode interfaces often do not support flags that can be set
> > by fcntl(). Right now using fcntl() to set these flags falsely
> > reports success for things like O_ASYNC yet SIGIO is not delivered.
> > 
> > I relied on the flags allowed by the syscalls that create
> > these files to determine the flags that are allowed to be set by
> > fcntl().
> > 
> > Each patch checks flags for one anonymous inode interface:
> > 
> > [PATCH 1/4] signalfd
> > [PATCH 2/4] timerfd
> > [PATCH 3/4] epoll
> > [PATCH 4/4] eventfd
> > 
> > I did not check the perf, kvm-vm, or kvm-vcpu uses of anon_inodes.
> 
> Er...  O_ASYNC is silently ignored for regular files as well, so any
> userland code that tries to rely on fcntl() rejecting it is and always
> had been badly b0rken.

Of course. Did you mean to imply that the kernel shouldn't bother to
reject these, or were you merely making an observation?

Cheers,
	-Matt Helsley
