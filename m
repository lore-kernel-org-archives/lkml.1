Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZJ0QxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZJ0QxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZJ0QxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:53:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:52588 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZJ0QxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=xDHp/IeMwRATbD0LaNoQBD3mZnNdv+9Sv0r4P345hOFH0D8Z6qMiZt4VJd7OHAa+Hd
         ku5CnHEgV3gB1CopElcsA1TG6STKvge9deRnMIAfOAA0i120oy6YWX7PUzrqEB3A+sP4
         e55S0YJtc7ixpZVXQWHlf+asmW3gyj+M8Y8kI=
Message-ID: <4AE72570.9070305@gmail.com>
Date: Tue, 27 Oct 2009 12:53:04 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com> <4AE6F7F7.1010302@gmail.com> <20091027140237.GM29477@redhat.com> <4AE70815.7030307@gmail.com> <20091027153007.GP29477@redhat.com>
In-Reply-To: <20091027153007.GP29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig537077F5FAF7ADF9D83BB962"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig537077F5FAF7ADF9D83BB962
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
>>
>> 1) rcu_read_lock is something like 4x faster than srcu_read_lock(), bu=
t
>> we are talking about nanoseconds on modern hardware (I think Paul quot=
ed
>> me 10ns vs 45ns on his rig).  I don't think either overhead is somethi=
ng
>> to be concerned about in this case.
>>
> If we can avoid why not? Nanoseconds tend to add up.
>=20

BTW: I didn't mean to imply that we should be cavalier in adding
overhead.  My point was that adding overhead is sometimes _necessary_ to
prevent a race above and beyond an RCU pointer acquisition, and 35ns is
not _terrible_ IMO.

I was suggesting to solve this by switching to SRCU, but an alternative
is copying the structure (when permitted with immutable objects), which
seems to work in this particular case.  It should be noted that the copy
has its own unquantified overhead beyond basic RCU as well, so its not
truly free (I'd guess its <=3D as the switch to SRCU without copies, thou=
gh).

IOW: sync hurts, but its sometimes a necessary evil ;)

Kind Regards,
-Greg


--------------enig537077F5FAF7ADF9D83BB962
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnJXEACgkQP5K2CMvXmqFMIgCff0BzVMMMwoFkMqFF/y5cneXN
fYQAnjB5v81rVznioi9eGPt5gDOQXLIj
=lAK1
-----END PGP SIGNATURE-----

--------------enig537077F5FAF7ADF9D83BB962--
