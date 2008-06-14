Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYFNAP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYFNAP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760722AbYFNAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:51704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719AbYFNAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:57 -0400
Date: Fri, 13 Jun 2008 17:10:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gorcunov@gmail.com, mhalcrow@us.ibm.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 11/47] ecryptfs: fix missed mutex_unlock
Message-ID: <20080614001043.GK24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-fix-missed-mutex_unlock.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>

upstream commit: 71fd5179e8d1d4d503b517e0c5374f7c49540bfc

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1907,9 +1907,9 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 			goto out;
 		}
 	}
-	mutex_unlock(&key_tfm_list_mutex);
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
+	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }

-- 
