Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDUTkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDUTkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXDUTkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:40:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbXDUTkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:40:40 -0400
Date: Sat, 21 Apr 2007 12:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: a.righi@cineca.it, "Vladimir V. Saveliev" <vs@namesys.com>,
       linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com, ak@suse.de
Subject: Re: [PATCH] reiserfs: fix xattr root locking/refcount bug
Message-Id: <20070421123956.f74575d0.akpm@linux-foundation.org>
In-Reply-To: <462A2D27.3060809@suse.com>
References: <20070413095219.02075323.akpm@linux-foundation.org>
	<462536B2.5060308@users.sourceforge.net>
	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>
	<200704181816.21166.vs@namesys.com>
	<46263270.9010108@suse.com>
	<20070420170738.e269fcae.akpm@linux-foundation.org>
	<46296CB8.3090100@suse.com>
	<462A0F06.9020602@cineca.it>
	<462A2055.1040509@suse.com>
	<462A2107.6060902@suse.de>
	<462A2D27.3060809@suse.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 11:26:31 -0400 Jeff Mahoney <jeffm@suse.com> wrote:

>  The listxattr() and getxattr() operations are only protected by a read
>  lock. As a result, if either of these operations run in parallel, a race
>  condition exists where the xattr_root will end up being cached twice,
>  which results in the leaking of a reference and a BUG() on umount.
> 
>  This patch refactors get_xa_root(), __get_xa_root(), and
>  create_xa_root(), into one get_xa_root() function that takes
>  the appropriate locking around the entire critical section.

Great, thanks.

Now we need to work out the timing.  Our options are to shove
it into 2.6.21 immediately, or to give it a run in 2.6.22-rc1 then
backport into 2.6.21.x.

What is everyone's confidence level?
