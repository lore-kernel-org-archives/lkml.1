Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZCSLxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZCSLxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZCSLxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:53:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53395 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZCSLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:53:42 -0400
Message-ID: <49C232D4.7050004@novell.com>
Date: Thu, 19 Mar 2009 07:56:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
References: <20090318225137.GA3766@hades.domain.com> <20090318225428.GA3769@hades.domain.com> <20090319074949.GB17144@elte.hu>
In-Reply-To: <20090319074949.GB17144@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7A16D84FD2F3721464DFE2F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7A16D84FD2F3721464DFE2F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Luis Henriques <henrix@sapo.pt> wrote:
>
>  =20
>>
>> Btw: I tried Greg schedtop with this patch and the app behaviour is as=
 expected:
>>
>>   $ ./schedtop=20
>>   Exception: unsupported version
>>    =20
>
> Mind updating the app too and post it here please? It's the only app=20
> that relies on this file AFAIK.
>  =20

I can take care of the update if Luis can just confirm that this patch
works as expected against his new ABI?

--
commit 336a22f597769bb5759d561773d05ce666019677
Author: Gregory Haskins <ghaskins@novell.com>
Date:   Thu Mar 19 07:54:10 2009 -0400

    Update to proposed v15 ABI
  =20
    Signed-off-by: Gregory Haskins <ghaskins@novell.com>

diff --git a/schedtop.cc b/schedtop.cc
index 4d4c510..f3c9468 100644
--- a/schedtop.cc
+++ b/schedtop.cc
@@ -114,7 +114,7 @@ public:
                            throw std::runtime_error("error parsing
version");
                      =20
                        lis >> m_version;
-                       if (m_version !=3D 14)
+                       if ((m_version < 14) || (m_version > 15))
                            throw std::runtime_error("unsupported version=
");
                      =20
                        state =3D state_timestamp;
@@ -219,9 +219,11 @@ private:
            std::string basename("/" + FormIndex("cpu", m_cpu) + "/rq/");=

            Importer importer(m_smap, is, basename);
=20
-           importer +=3D "yld_both_empty";
-           importer +=3D "yld_act_empty";
-           importer +=3D "yld_exp_empty";
+           if (m_version < 15){
+             importer +=3D "yld_both_empty";
+             importer +=3D "yld_act_empty";
+             importer +=3D "yld_exp_empty";
+           }
            importer +=3D "yld_count";
            importer +=3D "sched_switch";
            importer +=3D "sched_count";



----------------

If this patch works, you have my "Acked-by" for Luis' kernel-side patch.

-Greg



--------------enigC7A16D84FD2F3721464DFE2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknCMtUACgkQlOSOBdgZUxmSFwCcDj9c4iURzHxecP3wMem6Zqyt
huQAn2sQfZObZAufhjlnyIZi/GUMQTip
=p7+W
-----END PGP SIGNATURE-----

--------------enigC7A16D84FD2F3721464DFE2F--
