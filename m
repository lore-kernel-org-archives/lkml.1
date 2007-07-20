Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbXGTWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbXGTWS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXGTWSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:18:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54468 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbXGTWST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:18:19 -0400
Date: Fri, 20 Jul 2007 18:18:15 -0400
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] knfsd: Fix typo in export display, print uid and gid as
	unsigned
Message-ID: <20070720221815.GP6514@fieldses.org>
References: <20070710121949.12548.patches@notabene> <1070710022737.13509@suse.de> <20070713002933.f15724a7.akpm@linux-foundation.org> <20070718230555.GN7111@fieldses.org> <18078.44366.961344.428533@notabene.brown> <20070719153536.GB23093@fieldses.org> <18080.7196.844577.295882@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18080.7196.844577.295882@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

For display purposes, treat uid's and gid's as unsigned ints for now.
Also fix a typo.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/export.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

On Fri, Jul 20, 2007 at 12:21:16PM +1000, Neil Brown wrote:
> On Thursday July 19, bfields@fieldses.org wrote:
> > Sharp eyes, thanks!  I'll make a patch.  Uh, any objection if I print
> > all those uid's as unsigned while I'm at it?
> 
> I wondered about that too.  I think we have completely removed the
> fiction that 'nobody' is '-2' rather than '65534' so it should be both
> safe and sensible to make them unsigned.

OK!  Here's what I've got.--b.

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 6ab8de4..2d295dd 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1503,9 +1503,9 @@ static void exp_flags(struct seq_file *m, int flag, int fsid,
 	if (flag & NFSEXP_FSID)
 		seq_printf(m, ",fsid=%d", fsid);
 	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
-		seq_printf(m, ",sanonuid=%d", anonu);
+		seq_printf(m, ",anonuid=%u", anonu);
 	if (anong != (gid_t)-2 && anong != (0x10000-2))
-		seq_printf(m, ",sanongid=%d", anong);
+		seq_printf(m, ",anongid=%u", anong);
 	if (fsloc && fsloc->locations_count > 0) {
 		char *loctype = (fsloc->migrated) ? "refer" : "replicas";
 		int i;
-- 
1.5.3.rc2

