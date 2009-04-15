Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZDOVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZDOVN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZDOVNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:13:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36392 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbZDOVNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:13:16 -0400
Message-ID: <49E64DE1.8070909@novell.com>
Date: Wed, 15 Apr 2009 17:13:05 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, henrix@sapo.pt
Subject: Re: Trouble with make-install from a NFS mount
References: <49E500F6.8060401@novell.com> <49E501D4.6000605@oracle.com> <49E627AA.5080105@novell.com> <49E641D4.2000604@oracle.com>
In-Reply-To: <49E641D4.2000604@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDE7CF949F925791958E70101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDE7CF949F925791958E70101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> Gregory Haskins wrote:
>  =20
>> Randy Dunlap wrote:
>>    =20
>>> Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>>
>>>> Looking into this, I couldnt track down where the "filechk" magic wa=
s
>>>> coming from (any hints from the kbuild gurus?).  So I thought that I=

>>>>        =20
>
> filechk is defined in scripts/Kbuild.include .
>
>  =20

ah, thx.

>>>
>>> See this patch, already applied/merged:
>>>
>>> Gitweb:     http://git.kernel.org/linus/556b0f58bbcdc96ba8ed67001b4e5=
7c50198da89
>>> Commit:     556b0f58bbcdc96ba8ed67001b4e57c50198da89
>>> Parent:     8e320d02718d2872d52ef88a69a493e420494269
>>> Author:     David Woodhouse <David.Woodhouse@intel.com>
>>> AuthorDate: Sat Jan 10 14:53:15 2009 +0000
>>> Committer:  David Woodhouse <David.Woodhouse@intel.com>
>>> CommitDate: Mon Apr 6 14:27:17 2009 -0700
>>>
>>>     Revert "fix modules_install via NFS"
>>>    =20
>>>     This reverts commit 8b249b6856f16f09b0e5b79ce5f4d435e439b9d6.
>>>    =20
>>>     This 'fix' is not necessary; we just need to undo the damage caus=
ed
>>>     accidentally by Igor/Mauro in 4b29631db33292d416dc395c56122ea865e=
7635c
>>>     ("V4L/DVB (9533): cx88: Add support for TurboSight TBS8910 DVB-S =
PCI card")
>>>    =20
>>>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>>>
>>>
>>>  =20
>>>      =20
>> Thanks Randy.  I was running on 0882e8dd3aad33eca41696d463bb896e6c8817=
eb
>> so I had these patches all applied.  I think you were trying to tell m=
e
>> that perhaps a similar fix could be found among these patches, but I w=
as
>> unfortunately not able to find any and this is still broken for me.
>>    =20
>
> No, I wasn't trying to say that.=20
Ah, sorry for the confusion.

>  Your very first paragraph said
> "regression in 30-rc1" and David's patch fixes that problem.
>
> So is there still some other problem in linus-current?
>
>  =20
Yes, this is still broken in current, though I think its a slightly
different problem than the one David addressed.  I think he addressed
"make modules_install", whereas I see the issue with "make install".

The problem seems to be that 30-rcX thinks that there are dependencies
to update (such as include/config/kernel.release and version.h.tmp)
during a make-install operation.  Since I am on a root-squashed NFS
mount, these files cannot be updated and thus the install fails.=20
Previous trees prior to linux-current (at least up to 2.6.29) did not
try to update these files so the install would succeed.

FWIW, I ran the make with -d, and at least part of the reason for the
dep-failure was the FORCE psuedo dependency against kernel.release and
version.h.  However, I didn't find that FORCE was a recent addition to
the Makefile so I am not sure why the behavior suddenly changed.

I can try things to debug this for anyone who is interested in sending
me suggestions.  However, I am currently unblocked by the issue since I
added the posted "push" script to my workflow, so this is not critical
to me anymore.

-Greg


--------------enigDE7CF949F925791958E70101
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknmTeUACgkQlOSOBdgZUxk1OQCcDX7GVIQioU014G/rdq1GXvBe
VlAAoIaaZsMnkp1DCzs2Iq8EpKcR89Zw
=9WFz
-----END PGP SIGNATURE-----

--------------enigDE7CF949F925791958E70101--
