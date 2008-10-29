Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYJ2XRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYJ2XRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ2XRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:17:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbYJ2XRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:17:03 -0400
Date: Wed, 29 Oct 2008 16:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: 2.6.28-rc2-mm1: Build failure on fs/quota.o
Message-Id: <20081029161626.1fa5acb0.akpm@linux-foundation.org>
In-Reply-To: <4908EA82.8090308@acm.org>
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
	<4908EA82.8090308@acm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 16:58:10 -0600
Zan Lynx <zlynx@acm.org> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/
> > 
> > - Various architectures don't compile very well.  ia64, alpha, s390,
> >   arm.  ftrace seems to be a particular culprit.
> > 
> > - But it seems to work OK on the six machines I ran it on.
> > 
> 
> Here is the error:
> 
>   CC      fs/quota.o
> fs/quota.c: In function ___generic_quotactl_valid___:
> fs/quota.c:76: error: implicit declaration of function ___sb_has_quota_active___
> make[1]: *** [fs/quota.o] Error 1
> make: *** [fs] Error 2

Thanks.

From: Andrew Morton <akpm@linux-foundation.org>

fs/quota.c: In function `generic_quotactl_valid':
fs/quota.c:76: error: implicit declaration of function `sb_has_quota_active'

Cc: Jan Kara <jack@suse.cz>
Reported-by: Zan Lynx <zlynx@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix
+++ a/include/linux/quotaops.h
@@ -257,6 +257,11 @@ static inline int sb_any_quota_loaded(st
 	return 0;
 }
 
+static inline int sb_has_quota_active(struct super_block *sb, int type)
+{
+	return 0;
+}
+
 static inline int sb_any_quota_active(struct super_block *sb)
 {
 	return 0;
_

