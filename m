Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbXKGSzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbXKGSzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGSzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:55:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43741 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbXKGSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:55:12 -0500
Date: Wed, 7 Nov 2007 10:55:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Johannes Weiner <hannes-kernel@saeurebad.de>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 04/23] dentries: Extract common code to remove dentry
 from lru
In-Reply-To: <20071107094348.GB7374@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0711071054240.11906@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011227.298491275@sgi.com>
 <20071107085027.GA6243@cataract> <20071107094348.GB7374@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-711890388-1194461709=:11906"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-711890388-1194461709=:11906
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 7 Nov 2007, J=F6rn Engel wrote:

> Looks like it.  Once this is fixed, feel free to add
> Acked-by: Joern Engel <joern@logfs.org>

Its in the slab defrag git now. I added the spelling fix and this one as a=
=20
result of the discussions today.


From: Christoph Lameter <clameter@sgi.com>
Subject: dcache: use the correct variable.

We need to use "loop" instead of "dentry"

Acked-by: Joern Engel <joern@logfs.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/fs/dcache.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/fs/dcache.c=092007-11-07 10:26:20.000000000 -0800
+++ linux-2.6/fs/dcache.c=092007-11-07 10:26:27.000000000 -0800
@@ -610,7 +610,7 @@ static void shrink_dcache_for_umount_sub
 =09=09=09spin_lock(&dcache_lock);
 =09=09=09list_for_each_entry(loop, &dentry->d_subdirs,
 =09=09=09=09=09    d_u.d_child) {
-=09=09=09=09dentry_lru_remove(dentry);
+=09=09=09=09dentry_lru_remove(loop);
 =09=09=09=09__d_drop(loop);
 =09=09=09=09cond_resched_lock(&dcache_lock);
 =09=09=09}
---1700579579-711890388-1194461709=:11906--
