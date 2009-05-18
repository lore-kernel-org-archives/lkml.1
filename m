Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZERCbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZERCbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZERCbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:31:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57191 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZERCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:31:36 -0400
Message-ID: <4A10C880.9020903@novell.com>
Date: Sun, 17 May 2009 22:31:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 2/4] kvm: add return value to kvm_io_bus_register_dev
References: <20090515162047.26209.93545.stgit@dev.haskins.net> <20090515162813.26209.49515.stgit@dev.haskins.net> <4A106F2E.4010601@redhat.com>
In-Reply-To: <4A106F2E.4010601@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig661EB0C76B9B5E8076DD9B7D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig661EB0C76B9B5E8076DD9B7D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Today this function returns void and will internally BUG_ON if it fail=
s.
>> We want to create dynamic MMIO/PIO entries driven from userspace
>> later in
>> the series, so enhance this API to return an error code on failure.
>>
>> We also fix up all the callsites to check the return code and BUG_ON i=
f
>> it fails.
>>
>> The net result should be identical behavior both before and after this=

>> patch.  We are simply laying the groundwork for the dynamic usage
>>  =20
>
> What happens if the dynamic user gets in there first, then the
> internal device (which is set up by userspace)?  We'll just BUG().

Hmm..I was assuming the in-kernel stuff would have completed in early
init before the dynamic stuff could even get in there.  But thinking
about it some more, you are right.  Theres no reason why something like
a iosignalfd ioctl couldnt come down before, for instance, enabling the
in-kernel PIC.  My bad.


>
> Need to handle the failure gracefully, more or less.
>

Yeah, agreed.  Will fix in next rev.

-Greg



--------------enig661EB0C76B9B5E8076DD9B7D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoQyIAACgkQlOSOBdgZUxk8igCeKW9FyRlXzcr/D1y2fORlhW/b
GXUAn3tv9eGWQxuXI3pGo8YNgL+CXb0K
=hDrY
-----END PGP SIGNATURE-----

--------------enig661EB0C76B9B5E8076DD9B7D--
