Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZLVThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZLVThg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZLVThd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:37:33 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:64150 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZLVThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=kuqd4kgButWoYsvmHZhrPdYHVDXKjivhk3rbTC+6XKMzrOjM0Rhd1fbIASWo0Gykx8
         xoFOit6TglbI1gQjbbEsy07EnK6+ZfsyNKWRE74b+9JiN2TZyC82MxBLXWUt5t0/3RJM
         uLOt/3tRvc2M1SS2DdjdZKTBAXukme2JsH5Pc=
Message-ID: <4B311FF8.7000804@gmail.com>
Date: Tue, 22 Dec 2009 14:37:28 -0500
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
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <4B3115C1.4070303@redhat.com> <4B311ADA.4000700@gmail.com> <4B311D20.7020400@redhat.com> <4B311ECB.6040205@gmail.com>
In-Reply-To: <4B311ECB.6040205@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig684F93E4DC44D9C0FAF9CB2F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig684F93E4DC44D9C0FAF9CB2F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/22/09 2:32 PM, Gregory Haskins wrote:
> On 12/22/09 2:25 PM, Avi Kivity wrote:

>>
>> If you're not doing something pretty minor, you're better of waking up=
 a
>> thread (perhaps _sync if you want to keep on the same cpu).  With the
>> new user return notifier thingie, that's pretty cheap.
>=20
> We have exploits that take advantage of IO heuristics.  When triggered
> they do more work in vcpu context than normal, which reduces latency
> under certain circumstances.  But you definitely do _not_ want to do
> them in-atomic ;)

And I almost forgot:  dev->call() is an RPC to the backend device.
Therefore, it must be synchronous, yet we dont want it locked either.  I
think that was actually the primary motivation for the change, now that
I think about it.

-Greg


--------------enig684F93E4DC44D9C0FAF9CB2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksxH/gACgkQP5K2CMvXmqGV3ACfQJWsxAl29eA9aDFyBd72YK7T
8JcAnR0e2riD4WmPtnK1KmdSf/8I3Maf
=tyPD
-----END PGP SIGNATURE-----

--------------enig684F93E4DC44D9C0FAF9CB2F--
