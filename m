Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZEGSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZEGSRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZEGSRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:17:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:16118 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZEGSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=rBJlQj+v/+hdtzrnIcw2wZdM7Dht2DHrsd13SqmEJ3alH8Q841s23QkdlbhdnPzuLN
         Cd9rRGYwXhcVxQzui26pLqFPoI4FczroyoAI94jonc0k9WxudixK3oG/fd6f4eNJFAWa
         VSdZ0XUVOpvQ5DiNO8j/vm5T91M1GZvIZ4Dug=
Message-ID: <4A03259B.3050500@gmail.com>
Date: Thu, 07 May 2009 14:16:59 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com>
In-Reply-To: <4A032472.4030106@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF03B0BB0D1BADDCD9123E37"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF03B0BB0D1BADDCD9123E37
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> What do you think of my mmio hypercall?  That will speed up all mmio
>>> to be as fast as a hypercall, and then we can use ordinary mmio/pio
>>> writes to trigger things.
>>>
>>>    =20
>> I like it!
>>
>> Bigger question is what kind of work goes into making mmio a pv_op (or=

>> is this already done)?
>>
>>  =20
>
> Looks like it isn't there.  But it isn't any different than set_pte -
> convert a write into a hypercall.
>
>

I guess technically mmio can just be a simple access of the page which
would be problematic to trap locally without a PF.  However it seems
that most mmio always passes through a ioread()/iowrite() call so this
is perhaps the hook point.  If we set the stake in the ground that mmios
that go through some other mechanism like PFs can just hit the "slow
path" are an acceptable casualty, I think we can make that work.

Thoughts?

-Greg


--------------enigEF03B0BB0D1BADDCD9123E37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDJZsACgkQP5K2CMvXmqEhvgCdH6VbUWBm2NoOdFRHfBSZyNKD
HhoAn0aykkwtIc0RDqzqUWXqGi7MvIIV
=bT5l
-----END PGP SIGNATURE-----

--------------enigEF03B0BB0D1BADDCD9123E37--
