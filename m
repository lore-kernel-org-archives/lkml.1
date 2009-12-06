Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZLGAMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZLGAMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZLGAMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:36 -0500
Received: from kroah.org ([198.145.64.141]:34185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZLGAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:42 2009
Message-Id: <20091207000642.287972660@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [011/119] md/raid1/raid10: add a cond_resched
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=md-raid1-raid10-add-a-cond_resched.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: NeilBrown <neilb@suse.de>

commit 1d9d52416c0445019ccc1f0fddb9a227456eb61b upstream.

During 'check' of a raid1 or raid10 it is possible for the management
thread to spend a lot of time running 'memcmp' on blocks from
different devices, so make sure the thread has a chance to schedule.
raid5d already has a cond_resched (in process_stripe).

Reported-By: Lee Howard <faxguy@howardsilvan.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1630,6 +1630,7 @@ static void raid10d(mddev_t *mddev)
 				generic_make_request(bio);
 			}
 		}
+		cond_resched();
 	}
 	if (unplug)
 		unplug_slaves(mddev);
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1676,6 +1676,7 @@ static void raid1d(mddev_t *mddev)
 				generic_make_request(bio);
 			}
 		}
+		cond_resched();
 	}
 	if (unplug)
 		unplug_slaves(mddev);


