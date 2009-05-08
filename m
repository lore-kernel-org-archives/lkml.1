Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZEHDSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZEHDSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZEHDSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:18:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34484 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbZEHDSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:18:04 -0400
Message-ID: <4A03A45D.2050102@novell.com>
Date: Thu, 07 May 2009 23:17:49 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <20090507234311.GA9517@amt.cnet>
In-Reply-To: <20090507234311.GA9517@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2791DD40DCC0F1447AFC6F7F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2791DD40DCC0F1447AFC6F7F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marcelo Tosatti wrote:
> On Thu, May 07, 2009 at 08:35:03PM -0300, Marcelo Tosatti wrote:
>  =20
>> Also for PIO/MMIO you're adding this unoptimized lookup to the=20
>> measurement:
>>
>>         pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
>>         if (pio_dev) {
>>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>>                 complete_pio(vcpu);=20
>>                 return 1;
>>         }
>>
>> Whereas for hypercall measurement you don't. I believe a fair comparis=
on
>> would be have a shared guest/host memory area where you store guest/ho=
st
>> TSC values and then do, on guest:
>>
>> 	rdtscll(&shared_area->guest_tsc);
>> 	pio/mmio/hypercall
>> 	... back to host
>> 	rdtscll(&shared_area->host_tsc);
>>
>> And then calculate the difference (minus guests TSC_OFFSET of course)?=

>>    =20
>
> Test Machine: Dell Precision 490 - 4-way SMP (2x2) x86_64 "Woodcrest"
> Core2 Xeon 5130 @2.00Ghz, 4GB RAM.
>
> Also it would be interesting to see the MMIO comparison with EPT/NPT,
> it probably sucks much less than what you're seeing.
>
>  =20

Agreed.  If you or someone on this thread has such a beast, please fire
up my test and post the numbers.

-Greg


--------------enig2791DD40DCC0F1447AFC6F7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDpF0ACgkQlOSOBdgZUxkOUACbBSnwGgsdlFH2x6Ab2x05GIiU
vqUAn1T5M01EIakX7kxl5vTXhWaGKGDt
=X7zr
-----END PGP SIGNATURE-----

--------------enig2791DD40DCC0F1447AFC6F7F--
