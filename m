Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbYECMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbYECMmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761726AbYECMmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:42:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:51032 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761276AbYECMm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Iuzd9awjm7mMY1yI9oUi65Mg+639oAw3fQt1IyAx5RJgT8b8XinsRXg/Sg8fy/hTNk+7zBoQYHnVbkMUJZ6PQ3aaW1FHmhzEtT7dadzfNsXWWL3UsdO9w+VzQ4vK/yT3iTJy2GJA1rQ8OFAx54/pyokOlJsWyd3K9KAbmL+kTGo=
Date: Sat, 3 May 2008 20:46:18 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Youngdale <ericy@cais.com>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: [Patch] fs/binfmt_elf.c: fix a wrong free
Message-ID: <20080503124610.GA3986@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a wrong free in fs/binfmt_elf.c::elf_core_dump().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Youngdale <ericy@cais.com>

---
 fs/binfmt_elf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b25707f..43254e3 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2032,10 +2032,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 
 end_coredump:
 	set_fs(fs);
+	free_note_info(&info);
 
 cleanup:
 	kfree(elf);
-	free_note_info(&info);
 	return has_dumped;
 }
 
-- 
1.5.4.1

