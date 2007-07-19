Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbXGSMgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbXGSMgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXGSMgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:36:12 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:41450 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbXGSMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:36:12 -0400
Date: Thu, 19 Jul 2007 14:35:56 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: AFS compile broken
Message-ID: <20070719143556.795cb458@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.SOC.4.64.0707191516120.18397@math.ut.ee>
References: <Pine.SOC.4.64.0707191516120.18397@math.ut.ee>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 15:19:40 +0300 (EEST),
Meelis Roos <mroos@linux.ee> wrote:

> Trying to compile todays git with modular AFS and gcc 4.1.3 prerelease 
> in Debian unstable (gcc version 4.1.3 20070629 (prerelease) (Debian 
> 4.1.2-13)):
> 
>   CC [M]  fs/afs/flock.o
> fs/afs/flock.c: In function 'afs_do_getlk':
> fs/afs/flock.c:459: error: void value not ignored as it ought to be
> make[3]: *** [fs/afs/flock.o] Error 1

Should probably be something like this, but I have no idea whether this
is correct. David?

---
 fs/afs/flock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.22.orig/fs/afs/flock.c
+++ linux-2.6.22/fs/afs/flock.c
@@ -456,7 +456,8 @@ static int afs_do_getlk(struct file *fil
 
 	/* check local lock records first */
 	ret = 0;
-	if (posix_test_lock(file, fl) == 0) {
+	posix_test_lock(file, fl);
+	if (fl->fl_type == F_UNLCK) {
 		/* no local locks; consult the server */
 		ret = afs_vnode_fetch_status(vnode, NULL, key);
 		if (ret < 0)
