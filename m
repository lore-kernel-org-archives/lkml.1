Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKBNct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKBNct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbXKBNcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:32:42 -0400
Received: from iucha.net ([209.98.146.184]:53872 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbXKBNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:32:41 -0400
Date: Fri, 2 Nov 2007 08:32:39 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071102133239.GI25561@iucha.net>
References: <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost> <20071101141414.GZ25561@iucha.net> <E1InlPV-0001f1-SL@localhost> <20071102021002.GF25561@iucha.net> <E1Inw51-0001e8-PS@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VKLB3BcClAS4nArB"
Content-Disposition: inline
In-Reply-To: <E1Inw51-0001e8-PS@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VKLB3BcClAS4nArB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2007 at 08:56:55PM +0800, Fengguang Wu wrote:
> > > ---
> > >  fs/reiserfs/stree.c |    3 ---
> > >  1 file changed, 3 deletions(-)
> > >=20
> > > --- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
> > > +++ linux-2.6.24-git17/fs/reiserfs/stree.c
> > > @@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
> > >  				}
> > >  				bh =3D next;
> > >  			} while (bh !=3D head);
> > > -			if (PAGE_SIZE =3D=3D bh->b_size) {
> > > -				cancel_dirty_page(page, PAGE_CACHE_SIZE);
> > > -			}
> > >  		}
> > >  	}
> > >  }
> >=20
> > ... and with the above patch applied.
> >=20
> > Copying 300 MB from root (ext3) to the new file system did not trigger
> > the pdflush condition.  But then I did a
> >    cd $MOUNTPOINT && find . -exec md5sum {} \;
> > and that brought one cpu to 75% iowait.
>=20
> Immediately? Do you have the debug printk messages this time(with the
> above patch)?

No, but I will add them this afternoon.

> > I have attached my .config, if it helps.
>=20
> It's really curious - I tried your .config and commands, and still
> could not trigger the high iowait. I'm running 64bit Intel Core 2,
> and kernel 2.6.24-rc1-git6 with the above patch.

Curious but 100% reproducible, at least on my box.  What I'm going to
try is booting into the kernel with your patch and just doing the find
/ md5sum.  It would be really interesting if the read-only access
triggers it.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--VKLB3BcClAS4nArB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKyb3ND0rFCN2b1sRAiA+AJ9SOt8c1O5xZmIylo6KZ38FruzQ8ACeJZuG
T/lDZhu3183t8inNkOsWYfw=
=dHKO
-----END PGP SIGNATURE-----

--VKLB3BcClAS4nArB--
