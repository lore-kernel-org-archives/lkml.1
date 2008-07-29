Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYG2Tdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYG2Tdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYG2Tdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:33:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbYG2Tdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:33:42 -0400
Date: Tue, 29 Jul 2008 12:33:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 2/2] Remove a few inlines in fs/namei.c
Message-Id: <20080729123337.afb5fe4b.akpm@linux-foundation.org>
In-Reply-To: <20080729185537.GI28946@ZenIV.linux.org.uk>
References: <20080729155229.489904417@free-electrons.com>
	<20080729155527.799486507@free-electrons.com>
	<20080729185537.GI28946@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 19:55:37 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Jul 29, 2008 at 05:52:31PM +0200, Thomas Petazzoni wrote:
> > Uninline may_create() and do_follow_link() and use vfs_follow_link()
> > instead of __vfs_follow_link() in __do_follow_link(). It allows to
> > slightly reduce the size of kernel code:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 1114299	 118564	 212992	1445855	 160fdf	vmlinux.old
> > 1112971	 118564	 212992	1444527	 160aaf	vmlinux
> >   -1328       0       0   -1328    -530 +/-

That's a really big difference, considering whereabouts in the 
kernel this is.

> > This patch is part of the Linux Tiny project and has been originally
> > written by Matt Mackall <mpm@selenic.com>
> 
> Absolutely not.  do_follow_link() et.al. are parts of mutual recursion
> loop and we need to reduce the use of kernel *stack*.

Last time someone tried to "fix" this I suggested that we add some
comments explaining the design - why it is the way it is.  And the
time before that.

