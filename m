Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZD1Keg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZD1Keg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZD1KeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:34:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36553 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZD1KeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:34:24 -0400
Message-ID: <49F6DB9D.3080501@novell.com>
Date: Tue, 28 Apr 2009 06:34:05 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com>
In-Reply-To: <49F6CDFC.6000400@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFEDE34FA9AE74189949A93EA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEDE34FA9AE74189949A93EA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>
> =20
>
>>> Sure, the interface remains the same (write 8 bytes), but the
>>> implementation can change.  For example, we can implement it to work
>>> from interrupt context, once we hack the locking appropriately.
>>>    =20
>>
>> I was thinking more along the lines of eventfd_signal().  AIO and vbus=

>> currently use this interface, as opposed to the more polymorhpic
>> f_ops->write().
>>
>>  =20
>
> But eventfd_signal basically marries us to eventfd.

Well, only if we expect the fd to have eventfd semantics.  There are
advantages to doing so, as we have discussed, because things like AIO
can polymorhpically signal an interrupt without even knowing whats
behind the eventfd.  But this isn't a strict requirement to support
AIO.  Really all we need is a way for both kernel and userspace to
signal.  Perhaps I should export an "irqfd_signal()" function from kvm,
which today will map to eventfd_signal(), and tomorrow to ??.  I don't
think using f_ops->write() is an option for in-kernel signaling, so we
need some kind of interface here.

Does that sound reasonable?

-Greg



--------------enigFEDE34FA9AE74189949A93EA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn2250ACgkQlOSOBdgZUxnx7ACfUiUVrOtNcfs73R/EeZkU74b4
iTIAoI1a1XslZwh2xr/lvPNMpKtqsR7Q
=B43C
-----END PGP SIGNATURE-----

--------------enigFEDE34FA9AE74189949A93EA--
