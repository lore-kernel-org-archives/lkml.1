Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbYHKFgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbYHKFgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 01:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYHKFf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 01:35:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51638 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbYHKFfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 01:35:55 -0400
Date: Mon, 11 Aug 2008 15:35:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
Message-Id: <20080811153536.02ac0561.sfr@canb.auug.org.au>
In-Reply-To: <20080811101602.09555609.sfr@canb.auug.org.au>
References: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
	<20080811101602.09555609.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Aug_2008_15_35_36_+1000_z+KOiRsfus2NvLVy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Aug_2008_15_35_36_+1000_z+KOiRsfus2NvLVy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David, James,

On Mon, 11 Aug 2008 10:16:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I have a plan for getting rid of these - I will start on it today or
> tomorrow.

As a start, can you create a patch (or patches) that does just the
include/linux/creds.h part of commits
785af0f385cd424d4b40908bf0e467df3dc05434 ("CRED: Change current->fs[ug]id
to current_fs[ug]id()") and f4d399d40debd14b22967153294b94087cbcf789
("CRED: Wrap most current->e?[ug]id and some task->e?[ug]id") and send
that to Linus explaining to him the reason we want these in 2.6.27
(Something like "The introduction of the credentials API in 2.6.28
requires the abstracting of access to some fields in the task structure.
This change introduces trivial noop version of the desired accessors so
that other subsystems can start to be converted over.").  This
explanation should go in the commit message.

After he has put those patch(es) in, you could break up the rest of those
two commits by subsystem/arc/driver (or something) and ask the
appropriate maintainers to apply them and send them to Linus (with a
similar explanation) (or just ask them to ACK such patches so you can
send them upstream).

Hopefully this way ww will avoid a lot of the merge pain during the next
merge window and the other subsystems can continue on in their
development.

How does that sound?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Aug_2008_15_35_36_+1000_z+KOiRsfus2NvLVy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkifz6gACgkQjjKRsyhoI8y0KwCZAWqQPEkLDBkcw9wEcPDL3H7X
lzEAoLpMNK/8c5SGQO+yTSVShqmED6yN
=D9R1
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Aug_2008_15_35_36_+1000_z+KOiRsfus2NvLVy--
