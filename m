Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZHZSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZHZSnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZHZSm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:42:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5690 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZHZSm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=DS9uJADmzdIG2Z73RAzqJN5etAqxLPidmeyuWXTsZO6IwsEdHb0iO9uoFjH/vphJHf
         fGdRMDkV++52TmomhDxGkNpgZd9YyZUELbDPjO3WovowxXKYSL7JKsAROoHKc5hYDIjX
         qgOSritop74ONTAyNvftAc7Odf5Z+nuU75RQo=
Message-ID: <4A95822D.9060207@gmail.com>
Date: Wed, 26 Aug 2009 14:42:53 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: alacrityvm-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM benchmark numbers updated
References: <4A948962.7090909@gmail.com> <4A950B75.5020409@redhat.com>
In-Reply-To: <4A950B75.5020409@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFC6960BF101ED27437A67DF7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFC6960BF101ED27437A67DF7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 08/26/2009 04:01 AM, Gregory Haskins wrote:
>> We are pleased to announce the availability of the latest networking
>> benchmark numbers for AlacrityVM.  We've made several tweaks to the
>> original v0.1 release to improve performance.  The most notable is a
>> switch from get_user_pages to switch_mm+copy_[to/from]_user thanks to =
a
>> review suggestion from Michael Tsirkin (as well as his patch to
>> implement it).
>>
>> This change alone accounted for freeing up an additional 1.2Gbps, whic=
h
>> is over 25% improvement from v0.1.  The previous numbers were 4560Gbps=

>> before the change, and 5708Gbps after (for 1500mtu over 10GE).  This
>> moves us ever closer to the goal of native performance under
>> virtualization.
>>   =20
>=20
> Interesting, it's good to see that copy_*_user() works so well.  Note
> that there's a possible optimization that goes in the opposite directio=
n
> - keep using get_user_pages(), but use the dma engine API to perform th=
e
> actual copy.  I expect that it will only be a win when using tso to
> transfer full pages.  Large pages may also help.
>=20
> Copyless tx also wants get_user_pages().  It makes sense to check if
> switch_mm() + get_user_pages_fast() gives better performance than
> get_user_pages().

Actually, I have already look at this and it does indeed seem better to
use switch_mm+gupf() over gup() by quite a large margin.  You could then
couple that with your DMA-engine idea to potentially gain even more
benefits (though probably not for networking since most NICs have their
own DMA engine anyway).

Kind Regards,
-Greg



--------------enigFC6960BF101ED27437A67DF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqVgi0ACgkQP5K2CMvXmqF9nwCfWf6IPAu7kF78fVbsgoaFUjSp
Cd4AnjZvSHEZuOtd8qhOXStUi2sALT19
=LNc6
-----END PGP SIGNATURE-----

--------------enigFC6960BF101ED27437A67DF7--
