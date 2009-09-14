Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZINQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZINQJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZINQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:08:59 -0400
Received: from mail-qy0-f185.google.com ([209.85.221.185]:56033 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZINQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=EG0YwqCm9eQ165dNOgGoGN5q+A/9YnlmHch3x2a7IcLUptKoOTXGVsFpj2BggtwkEk
         zaiSkDA4lBRpCPKvMth4CYJfKl3eTh0H3mDDSNRiadyOfIaRTZ8K7J5vaIwTxaRukElK
         osy+Ms05mi9lLrQZWyr42ZwvwhMfa8Ho9opvg=
Message-ID: <4AAE6A97.7090808@gmail.com>
Date: Mon, 14 Sep 2009 12:08:55 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu> <4AAA7415.5080204@gmail.com> <20090913120140.GA31218@redhat.com>
In-Reply-To: <20090913120140.GA31218@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A7B9E21588ECA3868FA009B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A7B9E21588ECA3868FA009B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Fri, Sep 11, 2009 at 12:00:21PM -0400, Gregory Haskins wrote:
>> FWIW: VBUS handles this situation via the "memctx" abstraction.  IOW,
>> the memory is not assumed to be a userspace address.  Rather, it is a
>> memctx-specific address, which can be userspace, or any other type
>> (including hardware, dma-engine, etc).  As long as the memctx knows ho=
w
>> to translate it, it will work.
>=20
> How would permissions be handled?

Same as anything else, really.  Read on for details.

> it's easy to allow an app to pass in virtual addresses in its own addre=
ss space.

Agreed, and this is what I do.

The guest always passes its own physical addresses (using things like
__pa() in linux).  This address passed is memctx specific, but generally
would fall into the category of "virtual-addresses" from the hosts
perspective.

For a KVM/AlacrityVM guest example, the addresses are GPAs, accessed
internally to the context via a gfn_to_hva conversion (you can see this
occuring in the citation links I sent)

For Ira's example, the addresses would represent a physical address on
the PCI boards, and would follow any kind of relevant rules for
converting a "GPA" to a host accessible address (even if indirectly, via
a dma controller).


>  But we can't let the guest specify physical addresses.

Agreed.  Neither your proposal nor mine operate this way afaict.

HTH

Kind Regards,
-Greg


--------------enig4A7B9E21588ECA3868FA009B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkquapcACgkQP5K2CMvXmqEsZQCfcQ2o0HqEYlWAuk3Qckq/ciWq
JrgAn0itJih00Z/pLWaEa7xiy99pwjUj
=Y/uW
-----END PGP SIGNATURE-----

--------------enig4A7B9E21588ECA3868FA009B--
