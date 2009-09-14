Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZINT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZINT2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZINT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:28:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:47939 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZINT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UHFJWtPeGReshzEW4Uqt0f39Pz1AAYhtNOgA2nDaSqXCyycIj/aXb7jDPqPOwpv/ST
         gFHPc2OVVKgIzm07tsXW6YRDzsKZmyuBKDFfPQAoFuB3PsEisjX9pW8c30cSTtSvDGBo
         IdJL9nUcuygeTEptyzrRPpcgTYqS1hZcrZghY=
Message-ID: <4AAE9967.9060406@gmail.com>
Date: Mon, 14 Sep 2009 15:28:39 -0400
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
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu> <4AAA7415.5080204@gmail.com> <20090913120140.GA31218@redhat.com> <4AAE6A97.7090808@gmail.com> <20090914165320.GA3851@redhat.com>
In-Reply-To: <20090914165320.GA3851@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA42345AD71EBB21A4FC6AED0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA42345AD71EBB21A4FC6AED0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Sep 14, 2009 at 12:08:55PM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> On Fri, Sep 11, 2009 at 12:00:21PM -0400, Gregory Haskins wrote:
>>>> FWIW: VBUS handles this situation via the "memctx" abstraction.  IOW=
,
>>>> the memory is not assumed to be a userspace address.  Rather, it is =
a
>>>> memctx-specific address, which can be userspace, or any other type
>>>> (including hardware, dma-engine, etc).  As long as the memctx knows =
how
>>>> to translate it, it will work.
>>> How would permissions be handled?
>> Same as anything else, really.  Read on for details.
>>
>>> it's easy to allow an app to pass in virtual addresses in its own add=
ress space.
>> Agreed, and this is what I do.
>>
>> The guest always passes its own physical addresses (using things like
>> __pa() in linux).  This address passed is memctx specific, but general=
ly
>> would fall into the category of "virtual-addresses" from the hosts
>> perspective.
>>
>> For a KVM/AlacrityVM guest example, the addresses are GPAs, accessed
>> internally to the context via a gfn_to_hva conversion (you can see thi=
s
>> occuring in the citation links I sent)
>>
>> For Ira's example, the addresses would represent a physical address on=

>> the PCI boards, and would follow any kind of relevant rules for
>> converting a "GPA" to a host accessible address (even if indirectly, v=
ia
>> a dma controller).
>=20
> So vbus can let an application

"application" means KVM guest, or ppc board, right?

> access either its own virtual memory or a physical memory on a PCI devi=
ce.

To reiterate from the last reply: the model is the "guest" owns the
memory.  The host is granted access to that memory by means of a memctx
object, which must be admitted to the host kernel and accessed according
 to standard access-policy mechanisms.  Generally the "application" or
guest would never be accessing anything other than its own memory.

> My question is, is any application
> that's allowed to do the former also granted rights to do the later?

If I understand your question, no.  Can you elaborate?

Kind Regards,
-Greg


--------------enigA42345AD71EBB21A4FC6AED0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqumWcACgkQP5K2CMvXmqFy7ACgi8TyUR3Jecgzz5GkKkFbPghh
68MAnjdJj8I2gXA9aTDBmumt62C11d3G
=yoUM
-----END PGP SIGNATURE-----

--------------enigA42345AD71EBB21A4FC6AED0--
