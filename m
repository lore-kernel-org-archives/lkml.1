Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbZHLL4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbZHLL4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZHLL4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:56:10 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:34753 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZHLL4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=FHQFw8pwV1ddE9Xf3kVQQPfhgfuPr8de3w6pZqz40XU9FKlfTVHHr5m+8KMvg6N0nR
         2KmWsP6ZUcnEjRQWz8A0KSAlnwfv/kQxWV6mtqGUN0emozHCRJJg3+X7eD4WJ6QgNtth
         l/fLsmbx59+nQTs4ZnqqYpLBp5tKDA8ulVXVQ=
Message-ID: <4A82ADD5.6040909@gmail.com>
Date: Wed, 12 Aug 2009 07:56:05 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org,
       "akpm@linux-foundation.org >> Andrew Morton" 
	<akpm@linux-foundation.org>,
       hpa@zytor.com, Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
References: <20090811212743.GA26309@redhat.com> <4A820391.1090404@gmail.com> <20090812071636.GA26847@redhat.com>
In-Reply-To: <20090812071636.GA26847@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7605C67DFA4B328715B65EB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7605C67DFA4B328715B65EB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Aug 11, 2009 at 07:49:37PM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> This implements vhost: a kernel-level backend for virtio,
>>> The main motivation for this work is to reduce virtualization
>>> overhead for virtio by removing system calls on data path,
>>> without guest changes. For virtio-net, this removes up to
>>> 4 system calls per packet: vm exit for kick, reentry for kick,
>>> iothread wakeup for packet, interrupt injection for packet.
>>>
>>> Some more detailed description attached to the patch itself.
>>>
>>> The patches are against 2.6.31-rc4.  I'd like them to go into linux-n=
ext
>>> and down the road 2.6.32 if possible.  Please comment.
>> I will add this series to my benchmark run in the next day or so.  Any=

>> specific instructions on how to set it up and run?
>>
>> Regards,
>> -Greg
>>
>=20
> 1. use a dedicated network interface with SRIOV, program mac to match
>    that of guest (for testing, you can set promisc mode, but that is
>    bad for performance)

Are you saying SRIOV is a requirement, and I can either program the
SRIOV adapter with a mac or use promis?  Or are you saying I can use
SRIOV+programmed mac OR a regular nic + promisc (with a perf penalty).


> 2. disable tso,gso,lro with ethtool

Out of curiosity, wouldnt you only need to disable LRO on the adapter,
since the other two (IIUC) are transmit path and are therefore
influenced by the skb's you generate in vhost?


> 3. add vhost=3DethX

You mean via "ip link" I assume?

Regards,
-Greg


--------------enigD7605C67DFA4B328715B65EB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqCrdUACgkQP5K2CMvXmqEOwACeNAOQtMMRFiCXlgHvg9A3/BC2
g4AAnRa44uxf7P8j1pmsxBIk2t1ehw2Q
=Khle
-----END PGP SIGNATURE-----

--------------enigD7605C67DFA4B328715B65EB--
