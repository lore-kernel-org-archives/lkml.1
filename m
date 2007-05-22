Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbXEVA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbXEVA7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbXEVA7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:59:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763400AbXEVA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:59:15 -0400
Date: Mon, 21 May 2007 17:54:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Maneesh Soni <maneesh@in.ibm.com>,
       stable@kernel.org
Subject: Re: [stable] [PATCH] - fix oops in sysfs_readdir
Message-Id: <20070521175445.adab3608.akpm@linux-foundation.org>
In-Reply-To: <465236EF.40102@redhat.com>
References: <4651E0C9.3080609@redhat.com>
	<20070521153935.b549db8f.akpm@linux-foundation.org>
	<465236EF.40102@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 19:18:55 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > On Mon, 21 May 2007 13:11:21 -0500
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >> This is a non-ida backport of Tejun's patch in -mm at:
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> >> for the 2.6.16 -stable tree - it follows the same scheme of using s_ino to safely
> >> store & retrieve the inode number of sysfs entries for use in sysfs_readdir,
> >> but uses a brain-dead-simple inode nr allocator rather than ida, which would
> >> bring along a lot of newer, more complex code.
> >>
> >> No, this doesn't guarantee uniqueness of sysfs inode numbers, but then
> >> the code in -stable today doesn't either - and with this change, at least
> >> it shouldn't oops.
> > 
> > So I'm sitting here whether to commend this patch to google kernel maintainers
> > for 2.6.18 backport, but I realise I don't know what it does.  And I don't know
> > if it fixes the reclaim-time oopses they were intermittently seeing, or if it
> > fixes something else and if so what that is.
> > 
> > Sigh.  Better changelogs, please.
> > 
> 
> Sorry Andrew.  I referenced Tejun's upstream patch in -mm which has a 
> nice changelog etc, and this is a backport of that, and does the same 
> thing in the same way and solves the same problem - but that doesn't 
> help if you just want to toss this message into your patch stack.  Will 
> fix up & resend.
> 

Actually, someone (eg distros) looking at Tejun's changelog would still be
struggling to answer the question "do I need this".  The one thing it
claims to fix is "duplicate inode numbers".  But why is that a problem? 
What are the user-visible consequences of not merging the patch?  Unobvious.
