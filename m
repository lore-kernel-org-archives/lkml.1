Return-Path: <linux-kernel-owner+w=401wt.eu-S935580AbYBWAgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935580AbYBWAgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763792AbYBWAd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:55251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763378AbYBWAd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:26 -0500
Date: Fri, 22 Feb 2008 16:29:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jack@suse.cz
Subject: [patch 06/38] quota: turn quotas off when remounting read-only
Message-ID: <20080223002951.GG7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="quota-turn-quotas-off-when-remounting-read-only.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 

From: Jan Kara <jack@suse.cz>

patch 66191dc622f5ff0a541524c4e96fdacfacfda206 in mainline.

Turn off quotas before filesystem is remounted read only.  Otherwise quota
will try to write to read-only filesystem which does no good...  We could
also just refuse to remount ro when quota is enabled but turning quota off
is consistent with what we do on umount.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/super.c
+++ b/fs/super.c
@@ -603,6 +603,7 @@ int do_remount_sb(struct super_block *sb
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
+		DQUOT_OFF(sb);
 	}
 
 	if (sb->s_op->remount_fs) {

-- 
