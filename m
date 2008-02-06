Return-Path: <linux-kernel-owner+w=401wt.eu-S933987AbYBGAVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbYBGAVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbYBFX7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:32975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbYBFX7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:14 -0500
Date: Wed, 6 Feb 2008 15:53:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steve French <sfrench@us.ibm.com>, Jeff <jlayton@redhat.com>,
       maximilian attems <max@stro.at>
Subject: [patch 54/73] CIFS: Respect umask when using POSIX mkdir
Message-ID: <20080206235354.GC13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-respect-umask-when-using-posix-mkdir.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Steve French <sfrench@us.ibm.com>

patch a8cd925f74c3b1b6d1192f9e75f9d12cc2ab148a in mainline.

[CIFS] Respect umask when using POSIX mkdir

When making a directory with POSIX mkdir calls, cifs_mkdir does not
respect the umask.  This patch causes the new POSIX mkdir to create with
the right mode

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -919,6 +919,7 @@ int cifs_mkdir(struct inode *inode, stru
 			goto mkdir_out;
 		}
 
+		mode &= ~current->fs->umask;
 		rc = CIFSPOSIXCreate(xid, pTcon, SMB_O_DIRECTORY | SMB_O_CREAT,
 				mode, NULL /* netfid */, pInfo, &oplock,
 				full_path, cifs_sb->local_nls,

-- 
