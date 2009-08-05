Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZHEErc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZHEErc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZHEEra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:47:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54582 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZHEEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:47:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK2reEqrR7PD/2dsb2JhbAC8OogpkEMFhBg
X-IronPort-AV: E=Sophos;i="4.43,326,1246838400"; 
   d="scan'208";a="360642956"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-04-14-22 uploaded (ummunotify)
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
	<20090804155014.35d4597c.randy.dunlap@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Aug 2009 21:47:30 -0700
In-Reply-To: <20090804155014.35d4597c.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 4 Aug 2009 15:50:14 -0700")
Message-ID: <adabpmulvdp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Aug 2009 04:47:30.0754 (UTC) FILETIME=[D7216A20:01CA1587]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you add this into the ummunotify patch, or add it on top or whatever?

Fix

    ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'

when building for i386 -- get_user() can't handle u64 on all
architectures, so just use copy_from_user().

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/char/ummunotify.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ummunotify.c b/drivers/char/ummunotify.c
index 725fbb0..29de6ab 100644
--- a/drivers/char/ummunotify.c
+++ b/drivers/char/ummunotify.c
@@ -453,7 +453,7 @@ static long ummunotify_unregister_region(struct ummunotify_file *priv,
 	struct ummunotify_reg *reg;
 	int ret = -EINVAL;
 
-	if (get_user(user_cookie, arg))
+	if (copy_from_user(&user_cookie, arg, sizeof user_cookie))
 		return -EFAULT;
 
 	spin_lock_irq(&priv->lock);
