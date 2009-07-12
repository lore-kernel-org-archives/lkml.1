Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZGLJyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZGLJyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZGLJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:53:52 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:5125
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbZGLJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:53:51 -0400
Message-ID: <4A59B2AB.9010900@panasas.com>
Date: Sun, 12 Jul 2009 12:53:47 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v3 04/18] EXOFS: do not manipulate s_dirt directly
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain> <20090709084849.12122.23929.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084849.12122.23929.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2009 09:53:49.0717 (UTC) FILETIME=[A7EE9C50:01CA02D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2009 11:48 AM, Artem Bityutskiy wrote:
> ... use new VFS helpers instead.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Acked-by: Boaz Harrosh <bharrosh@panasas.com>

Hi Artem.

Linus has pulled the exofs tree for 2.6.31-rc3 if you sync
with it you'll find one more simple call site for is_sb_dirty(sb).
(See below)

Thanks
Boaz

---
git diff --stat -p fs/exofs/file.c
 fs/exofs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 839b9dc..be38834 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -58,7 +58,7 @@ static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
 	/* This is a good place to write the sb */
 	/* TODO: Sechedule an sb-sync on create */
 	sb = inode->i_sb;
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_sync_fs(sb, 1);
 
 	return ret;
