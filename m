Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFKQtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFKQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXFKQtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:49:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58941 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbXFKQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:49:37 -0400
Date: Mon, 11 Jun 2007 09:49:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1549060509-1181580576=:15910"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1549060509-1181580576=:15910
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jun 2007, H=E5vard Skinnemoen wrote:

> On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Mon, 11 Jun 2007, Haavard Skinnemoen wrote:
> >=20
> > > While trying to get SLUB debugging to not break DMA on AVR32, I ran
> > > into this:
> >=20
> > This is a known bug in 2.6.22-rc2/rc3. Which version are you running?
>=20
> 2.6.22-rc4. I did a pull from Linus' tree a few hours ago.

Ahhh... I see its the same phenomenon as before but triggered by
a different cause.

If you set the align to 32 then the first kmalloc slabs of size

8
16
32

are all of the same size which leads to duplicate files in sysfs.

Does this patch fix it?

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/slub.c=092007-06-11 09:48:04.000000000 -0700
+++ linux-2.6/mm/slub.c=092007-06-11 09:48:17.000000000 -0700
@@ -3579,7 +3579,7 @@ static char *create_unique_id(struct kme
 =09=09*p++ =3D 'F';
 =09if (p !=3D name + 1)
 =09=09*p++ =3D '-';
-=09p +=3D sprintf(p, "%07d", s->size);
+=09p +=3D sprintf(p, "%07d", s->objsize);
 =09BUG_ON(p > name + ID_STR_LENGTH - 1);
 =09return name;
 }
---1700579579-1549060509-1181580576=:15910--
