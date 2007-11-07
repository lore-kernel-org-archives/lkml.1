Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXKGTBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXKGTBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXKGTA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:00:59 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60121 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754041AbXKGTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:00:58 -0500
Date: Wed, 7 Nov 2007 11:00:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Johannes Weiner <hannes-kernel@saeurebad.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 04/23] dentries: Extract common code to remove dentry
 from lru
In-Reply-To: <20071107185452.GD8918@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0711071100350.12363@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011227.298491275@sgi.com>
 <20071107085027.GA6243@cataract> <20071107094348.GB7374@lazybastard.org>
 <Pine.LNX.4.64.0711071054240.11906@schroedinger.engr.sgi.com>
 <20071107185452.GD8918@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-535107522-1194462056=:12363"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-535107522-1194462056=:12363
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 7 Nov 2007, J=F6rn Engel wrote:

> > Acked-by: Joern Engel <joern@logfs.org>
> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> >=20
> > Index: linux-2.6/fs/dcache.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/fs/dcache.c=092007-11-07 10:26:20.000000000 -0800
> > +++ linux-2.6/fs/dcache.c=092007-11-07 10:26:27.000000000 -0800
> > @@ -610,7 +610,7 @@ static void shrink_dcache_for_umount_sub
> >  =09=09=09spin_lock(&dcache_lock);
> >  =09=09=09list_for_each_entry(loop, &dentry->d_subdirs,
> >  =09=09=09=09=09    d_u.d_child) {
> > -=09=09=09=09dentry_lru_remove(dentry);
> > +=09=09=09=09dentry_lru_remove(loop);
> >  =09=09=09=09__d_drop(loop);
> >  =09=09=09=09cond_resched_lock(&dcache_lock);
> >  =09=09=09}
>=20
> Erm - wouldn't this break git-bisect?

Well Andrew will merge it into the earlier patch.

---1700579579-535107522-1194462056=:12363--
