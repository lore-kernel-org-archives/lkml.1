Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZFQQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZFQQln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZFQQle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:41:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38504 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbZFQQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:41:33 -0400
Message-ID: <4A391CB4.8090405@novell.com>
Date: Wed, 17 Jun 2009 12:41:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based	notifier
 interface
References: <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <20090616175300.GA24514@redhat.com> <4A37DFE2.2020506@novell.com> <20090617144540.GB3089@redhat.com> <4A39056E.1060409@novell.com> <20090617162521.GE3089@redhat.com>
In-Reply-To: <20090617162521.GE3089@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF33B196201A38A51CD4336B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF33B196201A38A51CD4336B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Jun 17, 2009 at 11:02:06AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Tue, Jun 16, 2009 at 02:09:38PM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>>> What do you mean by copy_to_user(other->mm) here?  If you are going=
 to switch
>>>>> to another mm, then I think current->mm must be valid (I think it's=
 not enough
>>>>> that you can sleep). So preemptible() might not be enough.
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> I dont currently use switch_mm, if that is what you mean.  I save th=
e
>>>> task_struct into the appropriate context so current->mm doesn't matt=
er
>>>> to me.  I never use it.  All I need (afaik) is to acquire the proper=

>>>> mutex first.  I am not an MM expert, so perhaps I have this wrong bu=
t it
>>>> does appear to work properly even from kthread context.
>>>>
>>>> -Greg
>>>>
>>>>
>>>>    =20
>>>>        =20
>>> I think I saw get_user_pages + memcpy in your patch. Yes, that works
>>> without switching contexts but it's slower than copy to user if you a=
re
>>> in the right context, and AFAIK it's slower than get_user_pages_fast.=

>>>
>>>  =20
>>>      =20
>> Yeah, understood.  It will definitely be interesting to try that
>> optimization with switch_mm that you suggested.
>>    =20
>
> BTW, I'm kind of confused - in your patch you do get_task_struct: does =
this
> guarantee that mm is not going aways?
>  =20

Well, again, I am not an expert on MM, but I would think so.  If p holds
a reference to p->mm (which I would think it would have to), and we hold
a reference to p, p->mm should be indirectly stable coincident with the
lifetime of our p reference.  OTOH, I have not actually looked at
whether p actually takes a p->mm reference or not via inspection, so
this is just an educated guess at this point. ;)

I guess if this is broken, the solution is simple:  Modify the code to
take an mm reference as well.

-Greg


--------------enigBF33B196201A38A51CD4336B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko5HLQACgkQlOSOBdgZUxlYlACeMTxkttrV4Y90D8yutsr7Dbza
dAMAnj1rj9NLdbkVSB/wYYQeldTxkT3N
=+UiO
-----END PGP SIGNATURE-----

--------------enigBF33B196201A38A51CD4336B--
