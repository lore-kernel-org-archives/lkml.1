Return-Path: <linux-kernel-owner+w=401wt.eu-S1765705AbXGYNjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765705AbXGYNjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759948AbXGYNjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:39:32 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3497 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760344AbXGYNjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:39:31 -0400
Date: Wed, 25 Jul 2007 09:37:59 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH]: allow individual core dump methods to be unlimited when sending to a pipe
Message-ID: <20070725133759.GA420@hmsreliant.homelinux.net>
References: <20070722153947.GA11941@hmsreliant.homelinux.net> <20070724020939.7644f18c.akpm@linux-foundation.org> <20070724151738.GB23976@hmsreliant.homelinux.net> <20070724220358.864db265.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724220358.864db265.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 10:03:58PM -0700, Andrew Morton wrote:
> 
> SuperH allmodconfig broke:
> 
> fs/binfmt_flat.c:83: warning: initialization from incompatible pointer type
> fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
> fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
> fs/binfmt_flat.c:94: error: conflicting types for 'flat_core_dump'
> fs/binfmt_flat.c:78: error: previous declaration of 'flat_core_dump' was here
> fs/binfmt_flat.c: In function `decompress_exec':
> fs/binfmt_flat.c:293: warning: label `out' defined but not used
> fs/binfmt_flat.c: In function `load_flat_file':
> fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 3)
> fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 4)
> fs/binfmt_flat.c:518: warning: comparison of distinct pointer types lacks a cast
> fs/binfmt_flat.c:549: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
> fs/binfmt_flat.c:601: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
> fs/binfmt_flat.c: At top level:
> fs/binfmt_flat.c:78: warning: 'flat_core_dump' used but never defined
> fs/binfmt_flat.c:94: warning: 'flat_core_dump' defined but not used

Damn!  Sorry about that.  At least I have a mediocre excuse in that it was on an
arch I didn't have hardware to test with.  Should have caught that sooner
though.  Heres the patch for it.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index e8f8198..cc24c5d 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int id, struct lib_info *p);
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
