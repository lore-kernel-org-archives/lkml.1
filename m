Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZEKR33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZEKR33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZEKR3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:29:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:15362 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZEKR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=l2dP+wKOnEL8tyqC7TsdsogBSBlgEKLq2yMJikyKVH7ISmp2ovQGthS9J9IGY0umYd
         QzB2PoKtHIT3CibamzvEEZ5iBWaeQMOstzOctwOMqPgsEm4tBfRSJPfGXUpPV0iP5J+z
         QIwNyGkOlMWfruMowvClIKGzNEEj8HZK5H8jk=
Message-ID: <4A086065.2090600@gmail.com>
Date: Mon, 11 May 2009 13:29:09 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Hollis Blanchard <hollisb@us.ibm.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws>	 <4A0824C2.4000109@gmail.com> <1242059712.29194.12.camel@slate.austin.ibm.com> <4A085B06.4080803@redhat.com>
In-Reply-To: <4A085B06.4080803@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD97507B686790E422673F29B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD97507B686790E422673F29B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Hollis Blanchard wrote:
>> I haven't been following this conversation at all. With that in mind..=
=2E
>>
>> AFAICS, a hypercall is clearly the higher-performing option, since you=

>> don't need the additional memory load (which could even cause a page
>> fault in some circumstances) and instruction decode. That said, I'm
>> willing to agree that this overhead is probably negligible compared to=

>> the IOp itself... Ahmdal's Law again.
>>  =20
>
> It's a question of cost vs. benefit.  It's clear the benefit is low
> (but that doesn't mean it's not worth having).  The cost initially
> appeared to be very low, until the nested virtualization wrench was
> thrown into the works.  Not that nested virtualization is a reality --
> even on svm where it is implemented it is not yet production quality
> and is disabled by default.
>
> Now nested virtualization is beginning to look interesting, with
> Windows 7's XP mode requiring virtualization extensions.  Desktop
> virtualization is also something likely to use device assignment
> (though you probably won't assign a virtio device to the XP instance
> inside Windows 7).
>
> Maybe we should revisit the mmio hypercall idea again, it might be
> workable if we find a way to let the guest know if it should use the
> hypercall or not for a given memory range.
>
> mmio hypercall is nice because
> - it falls back nicely to pure mmio
> - it optimizes an existing slow path, not just new device models
> - it has preexisting semantics, so we have less ABI to screw up
> - for nested virtualization + device assignment, we can drop it and
> get a nice speed win (or rather, less speed loss)
>
Yeah, I agree with all this.  I am still wrestling with how to deal with
the device-assignment problem w.r.t. shunting io requests into a
hypercall vs letting them PF.  Are you saying we could simply ignore
this case by disabling "MMIOoHC" when assignment is enabled?  That would
certainly make the problem much easier to solve.

-Greg


--------------enigD97507B686790E422673F29B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoIYGUACgkQP5K2CMvXmqHFhACfVM3BS9Ilmv6+oXDvZez+VqnI
vwAAoIRsYbN174LoleL//jaGKOMA9tdu
=ca1E
-----END PGP SIGNATURE-----

--------------enigD97507B686790E422673F29B--
