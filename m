Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZLVTcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZLVTcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZLVTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:32:33 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:61483 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZLVTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Vveax3S2knkhywy01zmHe3fApcSfs5v4tWuo+18oSLqKFE8g8LFbFOiM9qqLaLif0j
         KBPV7s5qoz+57RML3J9RjE3XR2tZs43tYh7K1+xUQ8kv9Wck1d3wFJBg3RQOGr/+Oowk
         PbPfEjnU6DAJxCan0KozAQaqaWTOJ8bnf9GQY=
Message-ID: <4B311ECB.6040205@gmail.com>
Date: Tue, 22 Dec 2009 14:32:27 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <4B311D20.7020400@redhat.com>
In-Reply-To: <4B311D20.7020400@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig933A54EB715F664AF186183B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig933A54EB715F664AF186183B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/22/09 2:25 PM, Avi Kivity wrote:
> On 12/22/2009 09:15 PM, Gregory Haskins wrote:
>> On 12/22/09 1:53 PM, Avi Kivity wrote:
>>  =20
>>> I asked why the irqfd/ioeventfd mechanisms are insufficient, and you
>>> did not reply.
>>>
>>>     =20
>> BTW: the ioeventfd issue just fell through the cracks, so sorry about
>> that.  Note that I have no specific issue with irqfd ever since the
>> lockless IRQ injection code was added.
>>
>> ioeventfd turned out to be suboptimal for me in the fast path for two
>> reasons:
>>
>> 1) the underlying eventfd is called in atomic context.  I had posted
>> patches to Davide to address that limitation, but I believe he rejecte=
d
>> them on the grounds that they are only relevant to KVM.
>>   =20
>=20
> If you're not doing something pretty minor, you're better of waking up =
a
> thread (perhaps _sync if you want to keep on the same cpu).  With the
> new user return notifier thingie, that's pretty cheap.

We have exploits that take advantage of IO heuristics.  When triggered
they do more work in vcpu context than normal, which reduces latency
under certain circumstances.  But you definitely do _not_ want to do
them in-atomic ;)

>=20
>> 2) it cannot retain the data field passed in the PIO.  I wanted to hav=
e
>> one vector that could tell me what value was written, and this cannot =
be
>> expressed in ioeventfd.
>>
>>   =20
>=20
> It would be easier to add data logging support to ioeventfd, if it was
> needed that badly.

"Better design"? perhaps.  "More easily"?  no.  Besides, Davide has
already expressed dissatisfaction with the KVM-isms creeping into
eventfd, so its not likely to ever be accepted regardless of your own
disposition.

xinterface, as it turns out, is a great KVM interface for me and easy to
extend, all without conflicting with the changes in upstream.  The old
way was via the kvm ioctl interface, but that sucked as the ABI was
always moving.  Where is the problem?  ioeventfd still works fine as it i=
s.

Kind Regards,
-Greg



--------------enig933A54EB715F664AF186183B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksxHssACgkQP5K2CMvXmqEwlQCdFszWrw9+/J0udBfJSeaMKH5K
uf0AnjqTzUTYJNj+z7jjHV+LJLWeYW6X
=cCLx
-----END PGP SIGNATURE-----

--------------enig933A54EB715F664AF186183B--
