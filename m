Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYJGUJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYJGUJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYJGUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:09:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:37862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbYJGUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:09:21 -0400
Date: Tue, 7 Oct 2008 13:09:19 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/39] ocfs2: POSIX file locks support
Message-ID: <20081007200919.GA26373@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-2-git-send-email-mfasheh@suse.com> <20081001231144.87fa2a0b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231144.87fa2a0b.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:11:44PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:42 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +int ocfs2_stack_supports_plocks(void)
> > +{
> > +	return !!(active_stack && active_stack->sp_ops->plock);
> > +}
> 
> It's pointless doing !! on something which is already 0 or 1.

Sure - the following patch is now on the 'merge_window' branch of ocfs2.git.

Also, thanks for all the review you did on these.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Remove pointless !!

ocfs2_stack_supports_plocks() doesn't need this to properly return a zero or
one value.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stackglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 7150f5d..68b668b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -290,7 +290,7 @@ EXPORT_SYMBOL_GPL(ocfs2_dlm_dump_lksb);
 
 int ocfs2_stack_supports_plocks(void)
 {
-	return !!(active_stack && active_stack->sp_ops->plock);
+	return active_stack && active_stack->sp_ops->plock;
 }
 EXPORT_SYMBOL_GPL(ocfs2_stack_supports_plocks);
 
-- 
1.5.4.1

