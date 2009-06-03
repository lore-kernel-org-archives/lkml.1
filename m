Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZFCViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZFCViA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZFCVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:37:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52229 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZFCVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:37:51 -0400
Message-ID: <4A26ED22.4060203@novell.com>
Date: Wed, 03 Jun 2009 17:37:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: mtosatti@redhat.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v5 0/2] iosignalfd
References: <20090603200835.8206.8039.stgit@dev.haskins.net>
In-Reply-To: <20090603200835.8206.8039.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4CF4F6AE2BA48FAF5F4549E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4CF4F6AE2BA48FAF5F4549E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to kvm.git/master:25deed73)
>
> This is v5 of the series.  For more details, please see the header to
> patch 2/2.
>
> This series has been tested against the kvm-eventfd unit test, and
> appears to be functioning properly.  You can download this test here:
>
> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>
> This series is ready to be considered for inclusion, pending any furthe=
r
> review comments.
>  =20

Sorry, Marcello.  I re-used an old email when composing this. :)

Marcello, Avi, and myself have previously agreed that Marcello's
mmio-locking cleanup should go in first.   When that happens, I will
need to rebase this series because it changes how you interface to the
io_bus code.  I should have mentioned that here, but forgot.  (Speaking
of, is there an ETA when that code will be merged Avi?)

That aside, after I sent this series I went to get some coffee to clear
my head and I thought of an issue in the code.  I will reply inline to
patch 2/2.

-Greg

> [
>    Changelog:
>
>       v5:
>            *) Removed "cookie" field, which was a misunderstanding on m=
y
>               part on what Avi wanted for a data-match feature
> 	   *) Added a new "trigger" data-match feature which I think is
>               much closer to what we need.
> 	   *) We retain the dev_count field in the io_bus infrastructure
> 	      and instead back-fill the array on removal.
> 	   *) Various minor cleanups
> 	   *) Rebased to kvm.git/master:25deed73
>
>       v4:
>            *) Fixed a bug in the original 2/4 where the PIT failure cas=
e
>               would potentially leave the io_bus components registered.=

>            *) Condensed the v3 2/4 and 3/4 into one patch (2/2) since
>               the patches became interdependent with the fix described =
above
>            *) Rebased to kvm.git/master:74dfca0a
>
>       v3:
>            *) fixed patch 2/4 to handle error cases instead of BUG_ON
>            *) implemented same HAVE_EVENTFD protection mechanism as
>               irqfd to prevent compilation errors on unsupported arches=

>            *) completed testing
>            *) rebased to kvm.git/master:7391a6d5
>
>       v2:
>            *) added optional data-matching capability (via cookie field=
)
>            *) changed name from iofd to iosignalfd
>            *) added io_bus unregister function
>            *) implemented deassign feature
>
>       v1:
>            *) original release (integrated into irqfd v7 series as "iof=
d")
> ]
>
> ---
>
> Gregory Haskins (2):
>       kvm: add iosignalfd support
>       kvm: make io_bus interface more robust
>
>
>  arch/x86/kvm/i8254.c      |   22 +++
>  arch/x86/kvm/i8259.c      |    9 +
>  arch/x86/kvm/x86.c        |    1=20
>  include/linux/kvm.h       |   15 ++
>  include/linux/kvm_host.h  |   16 ++
>  virt/kvm/coalesced_mmio.c |    8 +
>  virt/kvm/eventfd.c        |  356 +++++++++++++++++++++++++++++++++++++=
++++++++
>  virt/kvm/ioapic.c         |    9 +
>  virt/kvm/kvm_main.c       |   41 +++++
>  9 files changed, 462 insertions(+), 15 deletions(-)
>
>  =20



--------------enigD4CF4F6AE2BA48FAF5F4549E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkom7SkACgkQlOSOBdgZUxmpsgCcCkaNBOAN2agpDDAOx1XnrNh/
1ZoAnRgHZUqbcDDtIiImrTKqC6FzwNwX
=BOF4
-----END PGP SIGNATURE-----

--------------enigD4CF4F6AE2BA48FAF5F4549E--
