Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbXGJVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbXGJVHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbXGJVHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:07:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11756 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXGJVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:07:14 -0400
Date: Tue, 10 Jul 2007 14:09:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Randy.dunlap@oracle.com,
       wli@holomorphy.org, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH] 2.6.22-rc6-mm1:  hugetlbfs handle empty options string
Message-Id: <20070710140932.85fd9935.randy.dunlap@oracle.com>
In-Reply-To: <1184097540.5727.36.camel@localhost>
References: <1184097540.5727.36.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 15:59:00 -0400 Lee Schermerhorn wrote:

> [PATCH] 2.6.22-rc6-mm1 - hugetlbfs handle empty options string
> 
> I was seeing a null pointer deref in fs/super.c:vfs_kern_mount().
> Some file system get_sb() handler was returning NULL mnt_sb with
> a non-negative return value.  I also noticed a "hugetlbfs: Bad
> mount option:" message in the log.
> 
> Turns out that hugetlbfs_parse_options() was not checking for an
> empty option string after call to strsep().  On failure,
> hugetlbfs_parse_options() returns 1.  hugetlbfs_fill_super() just
> passed this return code back up the call stack where
> vfs_kern_mount() missed the error and proceeded with a NULL mnt_sb.
> 
> Apparently introduced by patch:
> 	hugetlbfs-use-lib-parser-fix-docs.patch
> 
> The problem was exposed by this line in my fstab:
> 
> none        /huge       hugetlbfs   defaults    0 0
> 
> It can also be demonstrated by invoking mount of hugetlbfs
> directly with no options or a bogus option.
> 
> This patch:
> 
> 1) adds the check for empty option to hugetlbfs_parse_options(),
> 2) enhances the error message to bracket any unrecognized
>    option with quotes ,
> 3) modifies hugetlbfs_parse_options() to return -EINVAL on any
>    unrecognized option,
> 4) adds a BUG_ON() to vfs_kern_mount() to catch any get_sb()
>    handler that returns a NULL mnt->mnt_sb with a return value
>    >= 0.
> 
> Signed-off-by:  Lee Schermerhorn  <lee.schermerhorn@hp.com>
> 
>  fs/hugetlbfs/inode.c |    8 +++++---
>  fs/super.c           |    1 +
>  2 files changed, 6 insertions(+), 3 deletions(-)

Argh.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
