Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbZFOKqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbZFOKqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZFOKqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:46:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZFOKqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:46:31 -0400
Date: Mon, 15 Jun 2009 06:46:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steve French <smfrench@gmail.com>, <linux-cifs-client@lists.samba.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: cifs tree build failure
Message-ID: <20090615064618.120a2337@tlielax.poochiereds.net>
In-Reply-To: <20090615133222.7405743c.sfr@canb.auug.org.au>
References: <20090615133222.7405743c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/y__V6Y3lSu2NR0Dmy=NHMeO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/y__V6Y3lSu2NR0Dmy=NHMeO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 15 Jun 2009 13:32:22 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> fs/cifs/cifsfs.c: In function 'cifs_show_options':
> fs/cifs/cifsfs.c:357: error: implicit declaration of function 'cifs_show_address'
> 
> Caused by commit 8616e0fc1e27295316f9821a883f0e9fa6f8200f ("cifs: remove
> unneeded NULL checks from cifs_show_options").
> 
> I have used the cifs tree from next-20090612 for today.

My fault. That function gets introduced in a later patch and I had a
bogus call left in here from when I reorganized the series. This
patch should fix it and a typo that got silently fixed in a patch that
hasn't been committed yet.

This patch should fix both. Steve F., let me know if you want me to
respin the series on top of this patch. Note that there's still a
harmless compiler warning that gets fixed in a later patch in the
series.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

--MP_/y__V6Y3lSu2NR0Dmy=NHMeO
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-cifs-fix-problems-with-earlier-patches.patch

=46rom c5949e669f4a85c16b3529777f5d550bddea9dd9 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@redhat.com>
Date: Mon, 15 Jun 2009 06:40:23 -0400
Subject: [PATCH] cifs: fix problems with earlier patches

cifs_show_address hasn't been introduced yet, and fix a typo that was
silently fixed by a later patch in the series.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c  |    2 --
 fs/cifs/netmisc.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8b31570..4b8ec25 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -354,8 +354,6 @@ cifs_show_options(struct seq_file *s, struct vfsmount *=
m)
 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=3D%s", tcon->ses->domainName);
=20
-	cifs_show_address(s, tcon->ses->server);
-
 	seq_printf(s, ",uid=3D%d", cifs_sb->mnt_uid);
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_printf(s, ",forceuid");
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 00e6e35..f9a54da 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -166,7 +166,7 @@ int
 cifs_convert_address(char *src, void *dst)
 {
 	struct sockaddr_in *s4 =3D (struct sockaddr_in *) dst;
-	struct sockaddr_in6 *s6 =3D (Struct sockaddr_in6 *) dst;
+	struct sockaddr_in6 *s6 =3D (struct sockaddr_in6 *) dst;
=20
 	if (cifs_inet_pton(AF_INET, src, &s4->sin_addr.s_addr)) {
 		s4->sin_family =3D AF_INET;
--=20
1.6.0.6


--MP_/y__V6Y3lSu2NR0Dmy=NHMeO--
