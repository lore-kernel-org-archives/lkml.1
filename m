Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbYHRTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbYHRTem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762113AbYHRTdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:33:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764638AbYHRTdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:33:02 -0400
Date: Mon, 18 Aug 2008 12:20:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <sfrench@us.ibm.com>
Subject: [patch 20/49] CIFS: if get root inode fails during mount, cleanup
	tree connection
Message-ID: <20080818192000.GU10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-if-get-root-inode-fails-during-mount-cleanup-tree-connection.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit 2c731afb0d4ba16018b400c75665fbdb8feb2175 upstream

Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -175,6 +175,8 @@ out_no_root:
 	if (inode)
 		iput(inode);
 
+	cifs_umount(sb, cifs_sb);
+
 out_mount_failed:
 	if (cifs_sb) {
 #ifdef CONFIG_CIFS_DFS_UPCALL

-- 
