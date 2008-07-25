Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYGYMmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYGYMmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYGYMlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:41:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbYGYMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:41:51 -0400
Date: Fri, 25 Jul 2008 05:41:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Adrian Bunk <bunk@kernel.org>, Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: __weak vs ifdef
Message-Id: <20080725054142.372f1c03.akpm@linux-foundation.org>
In-Reply-To: <20080725122454.GE6701@parisc-linux.org>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi>
	<20080725015537.564e3397.akpm@linux-foundation.org>
	<20080725091455.GD19310@cs181140183.pp.htv.fi>
	<20080725092748.GF19310@cs181140183.pp.htv.fi>
	<20080725023455.dde3eb27.akpm@linux-foundation.org>
	<20080725122454.GE6701@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 06:24:54 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jul 25, 2008 at 02:34:55AM -0700, Andrew Morton wrote:
> > We should make arch_pick_mmap_layout __weak and nuke that ifdef.
> 
> I strongly disagree.  I find it makes it harder to follow code flow
> when __weak functions are involved.  Ifdefs are ugly, no question, but
> they're easier to grep for, see when they'll be defined and know which of
> the arch_pick_mmap_layout() functions will be called.  __weak certainly
> has its uses (eg the sys_ni_syscall is great) but I find it's becoming
> overused.
> 
> My basic point here is that __weak makes the code easier to write but
> harder to read, and we're supposed to be optimising for easier to read.
> 

If you see

void __weak arch_foo(...)

and can't immediately work out what's going on then converting it to an
ifdef maze won't save you.

