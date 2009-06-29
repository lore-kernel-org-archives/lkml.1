Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZF2Pqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZF2Pqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbZF2PqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:46:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33553 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509AbZF2PqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:46:24 -0400
Message-ID: <4A48E1C5.5040608@novell.com>
Date: Mon, 29 Jun 2009 11:46:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v6 0/4] irqfd fixes and enhancements
References: <20090629153627.31959.76947.stgit@dev.haskins.net>
In-Reply-To: <20090629153627.31959.76947.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig443D18E94ECA02704E6B6E75"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig443D18E94ECA02704E6B6E75
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to kvm.git/master:4631e094)
>
> The following is the latest attempt to fix the races in irqfd/eventfd, =
as
> well as restore DEASSIGN support.  For more details, please read the pa=
tch
> headers.
>
> You can also find this applied as a git tree:
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2=
=2E6-hacks.git kvm/irqfd
>
> For reviewing convenience, here is a link to the entire virt/kvm/eventf=
d.c
> file after the patches are applied:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/linux-2.6-hacks.gi=
t;a=3Dblob;f=3Dvirt/kvm/eventfd.c;h=3D409d9e160f1f85618a5e3772937b2721a24=
9399a;hb=3D85cfd57e33dcaea29971513334ca003764653b21
>
> As always, this series has been tested against the kvm-eventfd unit tes=
t, and
> appears to be functioning properly. You can download this test here:
>
> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>
> I've included version 4 of Davide's eventfd patch (ported to kvm.git) s=
o
> that its a complete reviewable series.  Note, however, that there may b=
e
> later versions of his patch to consider for merging, so we should
> coordinate with him.
>
> -Greg
>
>
> [Changelog:
>
> 	v6:
> 	   *) Removed slow-work in favor of using a dedicated single-thread
>               workqueue.
> 	   *) Condensed cleanup path to always use deferred shutdown
> 	   *) Saved about 56 lines over v5, with the following diffstat:
>
>  	   include/linux/kvm_host.h |    2=20
>  	   virt/kvm/eventfd.c       |  248 ++++++++++++++++++----------------=
-------------
>  	   2 files changed, 97 insertions(+), 153 deletions(-)
>  =20

Forgot another change:

                          *) Fixed race in ASSIGN for the proper
acquisition order of the irqfd->eventfd

> 	v5:
>            Untracked..
> ]
>
> ---
>
> Davide Libenzi (1):
>       eventfd - revised interface and cleanups (4th rev)
>
> Gregory Haskins (3):
>       KVM: add irqfd DEASSIGN feature
>       KVM: Fix races in irqfd using new eventfd_kref_get interface
>       kvm: prepare irqfd for having interrupts disabled during eventfd-=
>release
>
>
>  drivers/lguest/lg.h          |    2=20
>  drivers/lguest/lguest_user.c |    4 -
>  fs/aio.c                     |   24 +---
>  fs/eventfd.c                 |  126 ++++++++++++++++++++---
>  include/linux/aio.h          |    4 -
>  include/linux/eventfd.h      |   35 +++++-
>  include/linux/kvm.h          |    2=20
>  include/linux/kvm_host.h     |    5 +
>  virt/kvm/Kconfig             |    1=20
>  virt/kvm/eventfd.c           |  229 +++++++++++++++++++++++++++++++---=
--------
>  10 files changed, 321 insertions(+), 111 deletions(-)
>
>  =20



--------------enig443D18E94ECA02704E6B6E75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpI4ckACgkQlOSOBdgZUxmhpgCcCpciPj0H2pvogmMZMURMfGU1
gqgAoIftlGyntSzizql3MlUzycckmsN2
=Joi5
-----END PGP SIGNATURE-----

--------------enig443D18E94ECA02704E6B6E75--
