Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbZEECRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbZEECRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZEECR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:17:28 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49597 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZEECR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:17:28 -0400
Message-ID: <49FFA1AB.5000307@novell.com>
Date: Mon, 04 May 2009 22:17:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 1/2] eventfd: export eventfd interfaces for	module
 use
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175745.26758.94086.stgit@dev.haskins.net> <20090504222404.GJ8633@ZenIV.linux.org.uk>
In-Reply-To: <20090504222404.GJ8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4D9E879F57D8A579D6B671D5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4D9E879F57D8A579D6B671D5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Al Viro wrote:
> On Mon, May 04, 2009 at 01:57:45PM -0400, Gregory Haskins wrote:
>  =20
>> @@ -56,6 +57,7 @@ int eventfd_signal(struct file *file, int n)
>> =20
>>  	return n;
>>  }
>> +EXPORT_SYMBOL_GPL(eventfd_signal);
>>    =20
>
> perhaps, but...
>
>  =20
>> @@ -197,6 +199,7 @@ struct file *eventfd_fget(int fd)
>> =20
>>  	return file;
>>  }
>> +EXPORT_SYMBOL_GPL(eventfd_fget);
>>    =20
>
> this one looks very odd.  Could you show legitimate users?
>  =20
Hi Al,

I plan on using this in a similar way as the AIO io_submit function does
today for the next version of the virtual-bus patches.  That is,
userspace allocates an eventfd (in this case, via kvm_irqfd() and the
kernel side code you have been reviewing) and subsequently submits the
fd to a unique virtual-bus instance in the kernel via an ioctl().  This
will ultimately associate the vbus instance dynamically with the kvm
instance in a loosely coupled relationship.  Vbus may be compiled as a
module, thus the export.

-Greg


--------------enig4D9E879F57D8A579D6B671D5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn/oasACgkQlOSOBdgZUxnRtwCdF1QC+hyj9FPIL6j6S1tepaIV
ncMAn39NbOoRs/HSJcIltuCgw1qgbYQI
=Z5gu
-----END PGP SIGNATURE-----

--------------enig4D9E879F57D8A579D6B671D5--
