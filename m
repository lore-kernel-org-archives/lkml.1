Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZLWWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZLWWjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZLWWjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:39:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40363 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbZLWWjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:39:15 -0500
Date: Thu, 24 Dec 2009 09:39:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20091224093913.4f29f37b.sfr@canb.auug.org.au>
In-Reply-To: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
References: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Thu, 24 Dec 2009 09:11:41 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next merge of the acpi tree got a conflict in
> drivers/platform/x86/sony-laptop.c between commits
> 45465487897a1c6d508b14b904dc5777f7ec7e04 ("kfifo: move struct kfifo in
> place"), c1e13f25674ed564948ecb7dfe5f83e578892896 ("kfifo: move out
> spinlock") and 7acd72eb85f1c7a15e8b5eb554994949241737f1 ("kfifo: rename
> kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...") from
> Linus' tree and commit a287e9f941cf4bb8c167802c0f1cf04a93bc4e4c
> ("sony-laptop: remove private workqueue, use keventd instead") from the
> acpi tree.
> 
> I fixed it up (see below) and can cay the fix for a while.  This fix
> needs checking.

I applied the following further patch (and there may be more fixes
necessary).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Dec 2009 09:36:07 +1100
Subject: [PATCH] acpi: further update for __kfifo_len API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/platform/x86/sony-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 9d05a1e..84a1736 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -317,7 +317,7 @@ static void do_sony_laptop_release_key(struct work_struct *work)
 	 * extra "empty" wakeup. This may be improved with the new
 	 * kfifo API.
 	 */
-	if (__kfifo_len(sony_laptop_input.fifo) != 0)
+	if (kfifo_len(&sony_laptop_input.fifo) != 0)
 		schedule_delayed_work(dwork, msecs_to_jiffies(10));
 }
 
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
