Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZLVTx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZLVTx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZLVTx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:53:27 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56505 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZLVTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:53:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=cIw/lRbZOKAfXGZQXwtSqiZtu1ys/tK6C3t98Lxyx1TOupCkbWiVh4JsJ3yUQy/zkT
         MGqCfmruSrovPXr4UA2QINT1inDTi29jAqNx/U5BJxeVRYTHHrSPosdbMYqTzTNl5eLY
         tSizm7mISY2pu3jUbTchX7iSj5HkWTT8pLFGc=
Message-ID: <4B3123AA.8040205@gmail.com>
Date: Tue, 22 Dec 2009 14:53:14 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <alpine.DEB.2.00.0912221137380.29381@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0912221137380.29381@makko.or.mcafeemobile.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6BEE5224B97AF759C77EB7E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6BEE5224B97AF759C77EB7E8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/22/09 2:39 PM, Davide Libenzi wrote:
> On Tue, 22 Dec 2009, Gregory Haskins wrote:
>=20
>> On 12/22/09 1:53 PM, Avi Kivity wrote:
>>> I asked why the irqfd/ioeventfd mechanisms are insufficient, and you =
did not reply.
>>>
>>
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
>=20
> I thought we addressed this already, in the few hundreds of email we=20
> exchanged back then :)

We addressed the race conditions, but not the atomic callbacks.  I can't
remember exactly what you said, but the effect was "no", so I dropped it.=
 ;)

This was the thread.

http://www.archivum.info/linux-kernel@vger.kernel.org/2009-06/08548/Re:_[=
KVM-RFC_PATCH_1_2]_eventfd:_add_an_explicit_srcu_based_notifier_interface=


>=20
>=20
>=20
>> 2) it cannot retain the data field passed in the PIO.  I wanted to hav=
e
>> one vector that could tell me what value was written, and this cannot =
be
>> expressed in ioeventfd.
>=20
> Like might have hinted in his reply, couldn't you add data support to t=
he=20
> ioeventfd bits in KVM, instead of leaking them into mainline eventfd?
>=20

Perhaps, or even easier I could extend xinterface.  Which is what I did ;=
)

The problem with the first proposal is that you would no longer actually
have an eventfd based mechanism...so any code using ioeventfd (like
Michael Tsirkin's for instance) would break.

Kind Regards,
-Greg


--------------enig6BEE5224B97AF759C77EB7E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksxI6oACgkQP5K2CMvXmqFyggCfbUVH1csVX9xmLrU2Hx47KEIr
4AcAnRX32LyUqFlGex4HTp1poudYaUmo
=rZ6D
-----END PGP SIGNATURE-----

--------------enig6BEE5224B97AF759C77EB7E8--
