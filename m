Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbZA2XiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbZA2XiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZA2Xh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:37:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbZA2Xh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:37:58 -0500
Date: Thu, 29 Jan 2009 15:37:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: sched behaviour (was: Re: linux-next: Tree for January 26)
Message-Id: <20090129153709.f368625e.akpm@linux-foundation.org>
In-Reply-To: <20090126192349.1804bc27.sfr@canb.auug.org.au>
References: <20090126192349.1804bc27.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 19:23:49 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

The machine is 8-way x86_64.  In one window it is running `make -j32
vmlinux'.

In another window I run the `fpatch' command.  fpatch is a scruffy
shell script from
http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz which does a
few mv's, cp's, etc.


current mainline:

akpm2:/usr/src/25> time fpatch b kernel/sched.c
fpatch b kernel/sched.c  0.02s user 0.09s system 33% cpu 0.338 total

Jan 26 linux-next:

akpm2:/usr/src/25> time fpatch b kernel/sched.c
fpatch b kernel/sched.c  0.02s user 0.05s system 0% cpu 32.739 total


Machine basically unusable, user unhappy!

I'm assuming it's a scheduler problem - everything is in pagecache.
