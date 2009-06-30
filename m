Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZF3MJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZF3MJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF3MJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:09:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51211 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZF3MJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:09:21 -0400
Message-ID: <4A4A0064.2000004@novell.com>
Date: Tue, 30 Jun 2009 08:09:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: steve@chygwyn.com, Steven Whitehouse <swhiteho@redhat.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix	races
 with module clients
References: <20090629191653.14240.44995.stgit@dev.haskins.net> <1246351383.3383.1.camel@localhost.localdomain> <20090630090715.GD29725@redhat.com> <20090630091832.GA14767@fogou.chygwyn.com> <20090630103001.GA30065@redhat.com>
In-Reply-To: <20090630103001.GA30065@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigABDA3883D43DE79F0BDF0672"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigABDA3883D43DE79F0BDF0672
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 30, 2009 at 10:18:32AM +0100, steve@chygwyn.com wrote:
>  =20
>> Hi,
>>
>> On Tue, Jun 30, 2009 at 12:07:15PM +0300, Michael S. Tsirkin wrote:
>>    =20
>>> On Tue, Jun 30, 2009 at 09:43:03AM +0100, Steven Whitehouse wrote:
>>>      =20
>>>> Hi,
>>>>
>>>> I'm happy to ACK this, but the race doesn't exist in GFS2's case bec=
ause
>>>> we wait for all work related to each GFS2 fs at umount time and the
>>>> module unload cannot happen until all GFS2 fs are umounted,
>>>>
>>>> Steve.
>>>>        =20
>>> I wonder whether the following holds:
>>>
>>> static void gfs2_recover_put_ref(struct slow_work *work)
>>> {
>>>         struct gfs2_jdesc *jd =3D container_of(work, struct gfs2_jdes=
c, jd_work);
>>>         clear_bit(JDF_RECOVERY, &jd->jd_flags);
>>>         smp_mb__after_clear_bit();
>>>         wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
>>>
>>> <- umount can complete here?
>>>
>>> }
>>>
>>>
>>> If yes, .text of the module could go away between the point marked by=
 <-
>>> and return from gfs2_recover_put_ref.
>>>
>>>
>>>      =20
>> Well in theory, yes. In reality I don't think it could ever happen
>>    =20
>
> Right. IIUC, that's all Gregory's patch is trying to address: a
> theoretical race condition.
>
>  =20
Yeah, I never actually saw a crash.  I just noticed the hole via code
inspection.

Regards,
-Greg


--------------enigABDA3883D43DE79F0BDF0672
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpKAGkACgkQlOSOBdgZUxmZHQCfW63m6Vpr+Ii4W+1LsoShlqul
0wwAmgOe0yyt8tFqHLsLFmiiRpyLph9T
=FKCR
-----END PGP SIGNATURE-----

--------------enigABDA3883D43DE79F0BDF0672--
