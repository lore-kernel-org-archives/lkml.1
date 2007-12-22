Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXLVGDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXLVGDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXLVGDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:03:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbXLVGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:31 -0500
Date: Fri, 21 Dec 2007 22:03:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] update copyright date
Message-Id: <20071221220328.a051e42b.akpm@linux-foundation.org>
In-Reply-To: <1198188961-25147-13-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
	<1198188961-25147-13-git-send-email-ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 17:16:01 -0500 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> Subject: [PATCH 13/13] update copyright date

Please put an identfier for the subsytem in patch titles.  In this case,

	Subject: [PATCH 13/13] aoe: update copyright date

would suit.

I dropped aoe-remove-race-between-use-and-initialization-of-locks.patch,
queued the rest and added the below, thanks.


aoe: statically initialise devlist_lock
From: Andrew Morton <akpm@linux-foundation.org>

I guess aoedev_init() can go away now.

Cc: Greg KH <greg@kroah.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-statically-initialise-devlist_lock drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-statically-initialise-devlist_lock
+++ a/drivers/block/aoe/aoedev.c
@@ -16,7 +16,7 @@ static void freetgt(struct aoedev *d, st
 static void skbpoolfree(struct aoedev *d);
 
 static struct aoedev *devlist;
-static spinlock_t devlist_lock;
+static DEFINE_SPINLOCK(devlist_lock);
 
 int
 aoedev_isbusy(struct aoedev *d)
@@ -291,7 +291,5 @@ aoedev_exit(void)
 int __init
 aoedev_init(void)
 {
-	spin_lock_init(&devlist_lock);
 	return 0;
 }
-
_

