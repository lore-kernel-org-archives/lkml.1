Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbZFRLqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbZFRLqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbZFRLqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:46:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56398 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbZFRLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:46:22 -0400
Message-ID: <4A3A2907.1070409@novell.com>
Date: Thu, 18 Jun 2009 07:46:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 1/2] KVM: make io_bus interface more robust
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134230.14362.39612.stgit@dev.haskins.net> <4A3A2685.4060500@redhat.com>
In-Reply-To: <4A3A2685.4060500@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7F3F517CBC56B3FDE74E17A5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7F3F517CBC56B3FDE74E17A5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/16/2009 04:42 PM, Gregory Haskins wrote:
>> +
>> +/* assumes kvm->lock held */
>> +void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
>> +                   struct kvm_io_device *dev)
>> +{
>> +    int i;
>> +
>> +    for (i =3D 0; i<  bus->dev_count; i++) {
>> +
>> +        if (bus->devs[i] =3D=3D dev) {
>> +            int j;
>> +
>> +            /* backfill the hole */
>> +            for (j =3D i; j<  bus->dev_count-1; j++)
>> +                bus->devs[j] =3D bus->devs[j+1];
>> +
>> +            bus->dev_count--;
>> +
>> +            break;
>>   =20
>
> Could be simplified to
>
>     if (bus->devs[i] =3D=3D dev) {
>         bus->devs[i] =3D bus->devs[--bus->dev_count];
>         return;
>     }
>
Clever!

Will do.

-Greg


--------------enig7F3F517CBC56B3FDE74E17A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6KQcACgkQlOSOBdgZUxl72wCfcYSUR4TfMYCwM9XBln1qvc2X
gs8AoI4Yd++IiJCzDVK8Of1g6IeOHw3j
=rGUi
-----END PGP SIGNATURE-----

--------------enig7F3F517CBC56B3FDE74E17A5--
