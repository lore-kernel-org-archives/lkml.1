Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZLUQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZLUQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZLUQqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:46:19 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:50132 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZLUQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=ohe3jBW1sKbLsJPdB61NzVZ3GEUDK/kzcs3PWRzGtvObSR7fDlD/A0pF5lSoUuge8x
         Owg6YbVZ9Xt0bDmHzwi3dIhPxXW2rOMLutseeyweLsBBTS3pmc/B+Dwlg/TYD0+0oTkY
         73iYkWo3fU/hv9EAfYWPFnRCtght17290SSBc=
Message-ID: <4B2FA655.6030205@gmail.com>
Date: Mon, 21 Dec 2009 11:46:13 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws>
In-Reply-To: <4B2FA42F.3070408@codemonkey.ws>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF6EF3FBD5F225B60CBED56A8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF6EF3FBD5F225B60CBED56A8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/21/09 11:37 AM, Anthony Liguori wrote:
> On 12/21/2009 10:04 AM, Gregory Haskins wrote:
>> No, B and C definitely are, but A is lacking.  And the performance
>> suffers as a result in my testing (vhost-net still throws a ton of exi=
ts
>> as its limited by virtio-pci and only adds about 1Gb/s to virtio-u, fa=
r
>> behind venet even with things like zero-copy turned off).
>>   =20
>=20
> How does virtio-pci limit vhost-net?  The only time exits should occur
> are when the guest notifies the host that something has been placed on
> the ring.  Since vhost-net has no tx mitigation scheme right now, the
> result may be that it's taking an io exit on every single packet but
> this is orthogonal to virtio-pci.
>=20
> Since virtio-pci supports MSI-X, there should be no IO exits on
> host->guest notification other than EOI in the virtual APIC.

The very best you can hope to achieve is 1:1 EOI per signal (though
today virtio-pci is even worse than that).  As I indicated above, I can
eliminate more than 50% of even the EOIs in trivial examples, and even
more as we scale up the number of devices or the IO load (or both).

> This is a
> light weight exit today and will likely disappear entirely with newer
> hardware.

By that argument, this is all moot.  New hardware will likely obsolete
the need for venet or virtio-net anyway.  The goal of my work is to
provide an easy to use framework for maximizing the IO transport _in
lieu_ of hardware acceleration.  Software will always be leading here,
so we don't want to get into a pattern of waiting for new hardware to
cover poor software engineering.  Its simply not necessary in most
cases.  A little smart software design and a framework that allows it to
be easily exploited/reused is the best step forward, IMO.

Kind Regards,
-Greg





--------------enigF6EF3FBD5F225B60CBED56A8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksvplUACgkQP5K2CMvXmqEr4gCcD77IW07qp4uZvo3sFrMNKxgp
KKcAoIPUd2xPt5G57TydRznBMp5v4PWd
=mOYF
-----END PGP SIGNATURE-----

--------------enigF6EF3FBD5F225B60CBED56A8--
