Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZFDS5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZFDS5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZFDS4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:56:53 -0400
Received: from mail-qy0-f176.google.com ([209.85.221.176]:37999 "EHLO
	mail-qy0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFDS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=M9AfRPPNkHz18ykxfJzLHI0Ix9OWCnBZRjLRAHR4q9FF9Ycsa1s4Bm7GdIgptEYWoI
         cnMYCY8vr1dahLpu2ksDg+taTPHjoZ8KamcluYzMEuyy06mfQ/X/cKbJGcR/4z1wqpwa
         bf3K5qMu3shhHCAd+1xlFFtjslLZIlB9yMzMA=
Message-ID: <4A28172D.6010906@gmail.com>
Date: Thu, 04 Jun 2009 14:49:17 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org, bhutchings@solarflare.com,
       andi@firstfloor.org, gregkh@suse.de, herber@gondor.apana.org.au,
       chrisw@sous-sol.org, shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 00/19] virtual-bus
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <49DE26EE.9030402@novell.com> <49E0C93E.5030205@redhat.com>
In-Reply-To: <49E0C93E.5030205@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE69DFCACFFF2A40B0584741"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE69DFCACFFF2A40B0584741
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Avi,
>>
>> Gregory Haskins wrote:
>> =20
>>> Todo:
>>> *) Develop some kind of hypercall registration mechanism for KVM so
>>> that
>>>    we can use that as an integration point instead of directly hookin=
g
>>>    kvm hypercalls
>>>      =20
>>
>> What would you like to see here?  I now remember why I removed the
>> original patch I had for registration...it requires some kind of
>> discovery mechanism on its own.  Note that this is hard, but I figured=

>> it would make the overall series simpler if I didn't go this route and=

>> instead just integrated with a statically allocated vector.  That bein=
g
>> said, I have no problem adding this back in but figure we should discu=
ss
>> the approach so I don't go down a rat-hole ;)
>>
>>  =20
>
>
> One idea is similar to signalfd() or eventfd().  Provide a kvm ioctl
> that takes a gsi and returns an fd.  Writes to the fd change the state
> of the line, possible triggering an interrupt.  Another ioctl takes a
> hypercall number or pio port as well as an existing fd.  Invocations
> of the hypercall or writes to the port write to the fd (using the same
> protocol as eventfd), so the other end can respond.
>
> The nice thing is that this can be used by both kernel and userspace
> components, and for kernel components, hypercalls can be either
> buffered or unbuffered.


And thus the "kvm-eventfd" (irqfd/iosignalfd) interface project was born.=
 ;)

(Michael FYI: so I will be pushing a vbus-v4 series at some point in the
near future that is expressed in terms of irqfd/iosignalfd, per the
conversation above.  The patches in v3 and earlier are more intrusive to
the KVM core than they will be in final form)

-Greg



--------------enigEE69DFCACFFF2A40B0584741
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkooFzEACgkQP5K2CMvXmqETSACfesRvtvolvnXx9zuk8chaddMb
ZzcAnjsZiWBxN/43owi64lXl/4k4m5Jv
=f3Sq
-----END PGP SIGNATURE-----

--------------enigEE69DFCACFFF2A40B0584741--
