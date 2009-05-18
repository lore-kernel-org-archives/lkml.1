Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZERChk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZERChk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZERCh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:37:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49238 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZERCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:37:28 -0400
Message-ID: <4A10C9D5.7000408@novell.com>
Date: Sun, 17 May 2009 22:37:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 4/4] kvm: add iosignalfd support
References: <20090515162047.26209.93545.stgit@dev.haskins.net> <20090515162823.26209.72294.stgit@dev.haskins.net> <4A10704E.1080301@redhat.com>
In-Reply-To: <4A10704E.1080301@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD328AFFCD4713ADA18A9330D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD328AFFCD4713ADA18A9330D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> +
>> +struct _iosignalfd {
>>  =20
>
> Why the underscore?  It's unorthodox for a structure.

I tend to do that to denote "this is a private structure", but it makes
more sense if we are building a factory interface for a corresponding
public version of the structure of the same name.  In this case, I do
not think I was using that pattern, but old habits die hard. ;)  I will
get rid of this extra underscore in the next rev.

>
>
>> +    u64                  cookie;
>> +    u64                  addr;
>> +    size_t               length;
>> +    struct file         *file;
>> +    struct list_head     list;
>> +    struct kvm_io_device dev;
>> +};
>>  =20
>
> How will that work with multiple identical addresses and different
> cookies?  Will the code iterate over all of them and just fire for one?=

Yeah, primarily because I think the io_bus code will stop once it finds
the first in_range() match.  But I put this logic in anyway in
preparation for the future when we may perhaps support such a notion
(similar to what you had me do with the irqfd side).

-Greg



--------------enigD328AFFCD4713ADA18A9330D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoQydYACgkQlOSOBdgZUxnCcQCfeUbM2YOLqFcmvyQPX2Jx/7lv
wSYAn2O6/3GR6Mu0jmtGILbO967QKY4a
=504A
-----END PGP SIGNATURE-----

--------------enigD328AFFCD4713ADA18A9330D--
