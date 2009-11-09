Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZKIKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZKIKvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZKIKvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:51:15 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:2585 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZKIKvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:51:06 -0500
X-Trace: 286469089/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.118.106/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.118.106
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEACmD90pQKXZq/2dsb2JhbACBToMkxzKPNINqVASBaA
X-IronPort-AV: E=Sophos;i="4.44,707,1249254000"; 
   d="scan'208";a="286469089"
Date: Mon, 9 Nov 2009 10:51:03 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: askb <askb23@gmail.com>
cc: wharms@bfs.de, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mm/ksm.c - Fix compile warnings (PS ignore my formatting
 in previous email)
In-Reply-To: <1257334139.14838.264.camel@linux-k65f.site>
Message-ID: <Pine.LNX.4.64.0911091034120.15199@sister.anvils>
References: <1257317010.14838.55.camel@linux-k65f.site>  <4AF15022.1020408@bfs.de>
 <1257334139.14838.264.camel@linux-k65f.site>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-287939173-1257763863=:15199"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-287939173-1257763863=:15199
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 4 Nov 2009, askb wrote:
> On Wed, 2009-11-04 at 10:57 +0100, walter harms wrote:
> >=20
> > askb schrieb:
> > > Found the compiler warning on linux-next: =09
> > >=20
> > > mm/ksm.c: In function =E2=80=98ksm_scan_thread=E2=80=99:
> > > mm/ksm.c:1083: warning: =E2=80=98page2[0u]=E2=80=99 may be used unini=
tialized in this
> > > function
> > > mm/ksm.c:1083: note: =E2=80=98page2[0u]=E2=80=99 was declared here
> > >=20
> > > fix for the above warning:
> > >=20
> > > Signed-off-by: Anil SB <askb23@gmail.com>
> > >=20
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index bef1af4..2ea0fd3 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -1080,7 +1080,7 @@ static void stable_tree_append(struct rmap_item=
 *rmap_item,
> > >   */
> > >  static void cmp_and_merge_page(struct page *page, struct rmap_item *=
rmap_item)
> > >  {
> > > -=09struct page *page2[1];
> > > +=09struct page *page2[1] =3D {NULL};
> > >  =09struct rmap_item *tree_rmap_item;
> > >  =09unsigned int checksum;
> > >  =09int err;
> > >=20
> > >=20
> >=20
> > a 1 element array looks strange, did you look what kind of magic is her=
e used ?
> >=20
> >From my understanding, it is used for place holder to check and return
> an identical page from stable_tree_search(). Can we do with a double
> indirection to struct page instead of the above?=20
> PS point me in the right direction.

I don't particularly like things like page2[1] myself, but there's
nothing actually wrong with it, so no urgency to change it.

mm/ksm.c is under active development (better Cc the people involved
with a sourcefile when considering changes to it), and I have a
collection of patches under testing, which do change some names
around here (along with more serious changes).  So, thanks for looking
at this, but I'd prefer to avoid the interference of a trivial patch
at the moment - sorry.

Which version of the compiler gave you that uninitialized warning?
A version which lots of people are using, or just some snapshot?
I've never seen a warning there myself, but they do keep "refining"
that logic.

Hugh's hypothesis: for every variable x initialized by a subfunction,
there exists at least one version V of gcc, such that V reports that
x may be used uninitialized.

Hugh
--8323584-287939173-1257763863=:15199--
