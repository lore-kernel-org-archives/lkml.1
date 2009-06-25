Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZFYN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZFYN7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZFYN70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:59:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49202 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbZFYN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:59:25 -0400
Message-ID: <4A4382AE.8000508@novell.com>
Date: Thu, 25 Jun 2009 09:59:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 0/4] irqfd fixes and enhancements
References: <20090625132441.26748.641.stgit@dev.haskins.net>
In-Reply-To: <20090625132441.26748.641.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig94318183CE06BD2F6625C544"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig94318183CE06BD2F6625C544
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
> This series has been tested against the kvm-eventfd unit test, and
> appears to be functioning properly.  You can download this test here:
>
> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>
> I've included version 4 of Davide's eventfd patch (ported to kvm.git) s=
o
> that its a complete reviewable series.  Note, however, that there may b=
e
> later versions of his patch to consider for merging, so we should
> coordinate with him.
>  =20

So I know we talked yesterday in the review session about whether it was
actually worth all this complexity to deal with the POLLHUP or if we
should just revert to the prior "two syscall" model and be done with
it.  Rusty reflected these same sentiments this morning in response to
Davide's patch in a different thread.

I am a bit torn myself, tbh.  I do feel as though I have a good handle
on the issue and that it is indeed now fixed (at least, if this series
is applied and the slow-work issue is fixed, still pending upstream
ACK).  I have a lot invested in going the POLLHUP direction having spent
so much time thinking about the problem and working on the patches, so I
a bit of a biased opinion, I know.

The reason why I am pushing this series out now is at least partly so we
can tie up these loose ends.  We have both solutions in front of us and
can make a decision either way.  At least the solution is formally
documented in the internet archives forever this way ;)

I took the review comments to heart that the shutdown code was
substantially larger and more complex than the actual fast-path code.  I
went though last night and simplified and clarified it.  I think the
latest result is leaner and clearer, so please give it another review
(particularly for races) before dismissing it.

Ultimately, I think the concept of a release notification for eventfd is
a good thing for all eventfd users, so I don't think this thing should
go away per se even if irqfd decides to not use it.=20

-Greg


--------------enig94318183CE06BD2F6625C544
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEUEARECAAYFAkpDgq4ACgkQlOSOBdgZUxl1JACSAkO9vtYRPk8NFVx8uSsjCvh1
4QCeKsJSP+yhkNMHEyviycrR9587LLY=
=yLPV
-----END PGP SIGNATURE-----

--------------enig94318183CE06BD2F6625C544--
