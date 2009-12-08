Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZLHPPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZLHPPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZLHPPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:15:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:38063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbZLHPPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:15:03 -0500
Date: Tue, 8 Dec 2009 16:14:16 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kbuild updates for 2.6.33
Message-ID: <20091208151416.GA13535@sepie.suse.cz>
References: <20091208133004.GA22750@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208133004.GA22750@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 02:30:04PM +0100, Michal Marek wrote:
> Hi Linus,
> 
> these are the kbuild patches I collected for 2.6.33. There might be a few
> more later, but this is the main part.
> 
> Thanks,
> Michal
> 
> The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
>   Linus Torvalds (1):
>         Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://repo.or.cz/linux-kbuild.git for-next
> 
...
> Michal Marek (4):
>       kbuild: generate modules.builtin

This patch broke make clean unfortunatelly. The for-next branch already
has a fix (commit e1cf87b), please, if you already fetched the branch,
fetch again. I'm attaching the fix for reference.

Michal


---

From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: fix make clean after mismerge

Fix typo / thinko in commit 698699f.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 391fcb3..8491b21 100644
--- a/Makefile
+++ b/Makefile
@@ -1174,7 +1174,7 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o modules.order -o -name '.tmp_*.o.*' \
+		-o -name modules.builtin -o -name '.tmp_*.o.*' \
 		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
-- 
1.6.5.3

