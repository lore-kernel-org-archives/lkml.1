Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbXFSTYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbXFSTYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbXFSTYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:24:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43707 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757448AbXFSTYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:24:34 -0400
Date: Tue, 19 Jun 2007 12:24:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
In-Reply-To: <20070619113501.a88bba50.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706191222420.7008@schroedinger.engr.sgi.com>
References: <4676F0B9.3080408@fr.ibm.com> <20070619113501.a88bba50.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-794248155-1182281073=:7008"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-794248155-1182281073=:7008
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 19 Jun 2007, Andrew Morton wrote:

> On Mon, 18 Jun 2007 22:53:13 +0200
> Cedric Le Goater <clg@fr.ibm.com> wrote:
>=20
> > +static int __init nsproxy_cache_init(void)
> > +{
> > +=09nsproxy_cachep =3D kmem_cache_create("nsproxy", sizeof(struct nspro=
xy),
> > +=09=09=09=09=09   0, SLAB_PANIC, NULL, NULL);
> > +=09return 0;
> > +}
> > +
>=20
> Christoph added this cheesy KMEM_CACHE macro.  But I don't immediately re=
call
> the rationale so I'm a bit reluctant to ask people to use-the-cheesy-macr=
o.
>=20
> Perhaps he can remind us why it is there?

Because it simplifies the handling of slabs.

The above will could become:

nsproxy_cachep =3D KMEM_CACHE(nsproxy, SLAB_PANIC);

meaning create a cache for the nsproxy struct, the nsproxy name and the=20
nsproxy size. See include/linux/slab.h.
=98
---1700579579-794248155-1182281073=:7008--
