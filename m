Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZHXRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZHXRia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZHXRia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZHXRi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:38:29 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 0/3] Inotify cleanup and idr race
To: linux-kernel@vger.kernel.org, linux-fs-devel@vger.kernel.org
Cc: zdenek.kabelac@gmail.com, torvalds@linux-foundation.org,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk, mikko.cal@gmail.com
Date: Mon, 24 Aug 2009 13:37:51 -0400
Message-ID: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series cleans up the code around the addition of new watches and
the modification of old watches, thus making it easier to verify they are
correct.  It should make machines less likely to panic if an object is found
in the inotify idr which should have been removed (it's a memory leak, not an
unrecoverable situation) and it should fix a race in idr removal which could
leak to a use after free situation.

If anyone is able to reproduce inotify or fsnotify problems with -rc7 + these
3 patches please please let me know!


---

Eric Paris (3):
      inotify: fix locking around inotify watching in the idr
      inotify: do not BUG on idr entries at inotify destruction
      inotify: seperate new watch creation updating existing watches


 fs/notify/inotify/inotify_fsnotify.c |   10 ++
 fs/notify/inotify/inotify_user.c     |  217 ++++++++++++++++++++++------------
 2 files changed, 151 insertions(+), 76 deletions(-)

-- 
