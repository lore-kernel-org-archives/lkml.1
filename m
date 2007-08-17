Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXHQQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXHQQDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765368AbXHQQD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:03:26 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:27383 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764916AbXHQQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:03:22 -0400
Subject: Re: [PATCH 09/23] lib: percpu_counter_init error handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
In-Reply-To: <20070817155659.GD24323@filer.fsl.cs.sunysb.edu>
References: <20070816074525.065850000@chello.nl>
	 <20070816074626.739944000@chello.nl>
	 <20070817155659.GD24323@filer.fsl.cs.sunysb.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sEzITVMqsFIiu6cypp27"
Date: Fri, 17 Aug 2007 18:03:16 +0200
Message-Id: <1187366597.6114.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sEzITVMqsFIiu6cypp27
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 11:56 -0400, Josef Sipek wrote:
> On Thu, Aug 16, 2007 at 09:45:34AM +0200, Peter Zijlstra wrote:
> )
> > @@ -996,12 +997,16 @@ static int ext2_fill_super(struct super_
> >  	sbi->s_rsv_window_head.rsv_goal_size =3D 0;
> >  	ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
> > =20
> > -	percpu_counter_init(&sbi->s_freeblocks_counter,
> > +	err =3D percpu_counter_init(&sbi->s_freeblocks_counter,
> >  				ext2_count_free_blocks(sb));
> > -	percpu_counter_init(&sbi->s_freeinodes_counter,
> > +	err |=3D percpu_counter_init(&sbi->s_freeinodes_counter,
> >  				ext2_count_free_inodes(sb));
> > -	percpu_counter_init(&sbi->s_dirs_counter,
> > +	err |=3D percpu_counter_init(&sbi->s_dirs_counter,
> >  				ext2_count_dirs(sb));
> > +	if (err) {
> > +		printk(KERN_ERR "EXT2-fs: insufficient memory\n");
> > +		goto failed_mount3;
> > +	}
>=20
> Can percpu_counter_init fail with only one error code? If not, the error
> code potentially used in future at failed_mount3 could be nonsensical
> because of the bitwise or-ing.

I guess I could have written saner code :-/ will try to come up with
something that is both clear and short.

--=-sEzITVMqsFIiu6cypp27
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGxcbEXA2jU0ANEf4RAngmAJ9iLoRbugFnY4WMorNM+fNCD6O8YACfSzEl
Ov+UGUBAZY2uX4INn3sJxTw=
=TFSt
-----END PGP SIGNATURE-----

--=-sEzITVMqsFIiu6cypp27--

