Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbZEGSiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbZEGSiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZEGShy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:37:54 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43670 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZEGShx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:37:53 -0400
Message-ID: <4A032A74.2020809@novell.com>
Date: Thu, 07 May 2009 14:37:40 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com>
In-Reply-To: <4A032771.6050703@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA249882E0CC97E776BEBB51A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA249882E0CC97E776BEBB51A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> I guess technically mmio can just be a simple access of the page which=

>> would be problematic to trap locally without a PF.  However it seems
>> that most mmio always passes through a ioread()/iowrite() call so this=

>> is perhaps the hook point.  If we set the stake in the ground that mmi=
os
>> that go through some other mechanism like PFs can just hit the "slow
>> path" are an acceptable casualty, I think we can make that work.
>>  =20
>
> That's my thinking exactly.

Cool,  I will code this up and submit it.  While Im at it, Ill run it
through the "nullio" ringer, too. ;)  It would be cool to see the
pv-mmio hit that 2.07us number.  I can't think of any reason why this
will not be the case.

>
> Note we can cheat further.  kvm already has a "coalesced mmio" feature
> where side-effect-free mmios are collected in the kernel and passed to
> userspace only when some other significant event happens.  We could
> pass those addresses to the guest and let it queue those writes
> itself, avoiding the hypercall completely.
>
> Though it's probably pointless: if the guest is paravirtualized enough
> to have the mmio hypercall, then it shouldn't be using e1000.

Yeah...plus at least for my vbus purposes, all my my guest->host
transitions are explicitly to cause side-effects, or I wouldn't be doing
them in the first place ;)  I suspect virtio-pci is exactly the same.=20
I.e. the coalescing has already been done at a higher layer for
platforms running "PV" code.

Still a cool feature, tho.

-Greg



--------------enigA249882E0CC97E776BEBB51A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDKnQACgkQlOSOBdgZUxl1BgCfZ9CekGSJkwPcXs9vFIT2gdiQ
OXAAn0fxvrYaEnJiwya6ttHd/jBy/V0T
=QkMz
-----END PGP SIGNATURE-----

--------------enigA249882E0CC97E776BEBB51A--
