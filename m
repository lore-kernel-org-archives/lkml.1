Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbZE0Rke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbZE0Rke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZE0RkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:40:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42464 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbZE0RkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:40:23 -0400
Message-ID: <4A1D7AFD.40004@novell.com>
Date: Wed, 27 May 2009 13:40:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net>	 <20090526191539.20860.1385.stgit@dev.haskins.net>	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>
In-Reply-To: <1243445144.16318.15.camel@blaa>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig14254BC946717CCE5FEC045F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig14254BC946717CCE5FEC045F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mark McLoughlin wrote:
> On Wed, 2009-05-27 at 15:11 +0300, Avi Kivity wrote:
>
>  =20
>> Multiple cookies on the same address are required by virtio.  You can'=
t=20
>> mux since the data doesn't go anywhere.
>>
>> Virtio can survive by checking all rings on a notify, and we can later=
=20
>> add a mechanism that has a distinct address for each ring, but let's s=
ee=20
>> if we can cope with multiple cookies.  Mark?
>>    =20
>
> Trying to catch up, but you're talking about replacing virtio-pci
> QUEUE_NOTIFY handling with iosignalfd ?
>
> For a perfect replacement, what you really need is to be able to
> register multiple cookies per address range, but only have them trigger=

> if the written data matches a provided value.
>  =20

Hmm..thats an interesting idea.  To date, the "cookie" has really been
for identifying the proper range selected for deassignment.  I never
thought of using it as an actual trigger value at run-time.

> If the data is lost, virtio has no way of knowing which queue is being
> notified, so we either end up with per-device, rather than per-queue,
> notifications (probably not too bad for net, at least) or a different
> notify address per queue (limiting the number of queues per device).
>  =20

The addr-per-queue is how I was envisioning it, but the trigger value
concept hadn't occurred to me.  I could make this an option during
assignment (e.g. "COOKIE" flag means only trigger on writes of the
provided cookie, otherwise trigger on any write).  Sound good?

Thanks Mark,
-Greg



--------------enig14254BC946717CCE5FEC045F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodewAACgkQlOSOBdgZUxnBrACeMUoZEoIaIDGBzRkJW+44v6at
+18An1ikOi+GgoLkoob104UtA58RHnOY
=j0VY
-----END PGP SIGNATURE-----

--------------enig14254BC946717CCE5FEC045F--
