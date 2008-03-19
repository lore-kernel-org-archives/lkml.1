Return-Path: <linux-kernel-owner+w=401wt.eu-S967298AbYCTA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967298AbYCTA2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965905AbYCSXuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:50:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55572 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761811AbYCSXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:50:40 -0400
X-Sasl-enc: +bKxL+ic32aOhcEZnT9B8gRvFHP+tP89QrhLe7TQ5cNs 1205970638
Message-ID: <47E1A6CA.7070608@imap.cc>
Date: Thu, 20 Mar 2008 00:50:34 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dave Hansen <haveblue@us.ibm.com>, Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>	 <1205525184.12763.32.camel@nimitz.home.sr71.net>	 <47DAE55C.3080506@tremplin-utc.net>	 <1205530551.8167.20.camel@nimitz.home.sr71.net>	 <47DB013D.3060102@tremplin-utc.net>	 <1205537395.8167.31.camel@nimitz.home.sr71.net>  <47DBC578.7050101@imap.cc>	 <1205698279.8167.44.camel@nimitz.home.sr71.net> <1205756615.8514.311.camel@twins>
In-Reply-To: <1205756615.8514.311.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6BA0E70E9347D3E7759D1B6E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6BA0E70E9347D3E7759D1B6E
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 17.03.2008 13:23 schrieb Peter Zijlstra:
> On Sun, 2008-03-16 at 13:11 -0700, Dave Hansen wrote:
>=20
>>>  ACPI: Core revision 20070126
>>> +INFO: trying to register non-static key.
>>> +the code is fine but needs lockdep annotation.
>>> +turning off the locking correctness validator.
>>> +Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #3
>>> + [<c014321e>] __lock_acquire+0x144/0xb6e
>>> + [<c010b1a2>] ? native_sched_clock+0xe0/0xff
>>> + [<c017fc57>] ? kmem_cache_alloc+0x89/0xc9
>>> + [<c0142ce0>] ? trace_hardirqs_on+0xe8/0x11d
>>> + [<c014404f>] lock_acquire+0x6a/0x90
>>> + [<c013b460>] ? down_trylock+0xc/0x27
>>> + [<c03016cb>] _spin_lock_irqsave+0x42/0x72
>>> + [<c013b460>] ? down_trylock+0xc/0x27
>>> + [<c013b460>] down_trylock+0xc/0x27
>>> + [<c021fa65>] acpi_os_wait_semaphore+0x67/0x13d
>>> + [<c023a39e>] acpi_ut_acquire_mutex+0x65/0xcf
>>> + [<c0230261>] acpi_ns_root_initialize+0x1a/0x289
>>> + [<c043ad54>] acpi_initialize_subsystem+0x47/0x6a
>>> + [<c043afd4>] acpi_early_init+0x57/0xf8
>>> + [<c04248ff>] start_kernel+0x34d/0x35a
>>> + [<c0424019>] i386_start_kernel+0x8/0xa
>>> + =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

>>>  ACPI: Checking initramfs for custom DSDT
[...]
> Looks like another of the semaphore thingies.. Does this go away once
> you apply the semaphore lockdep fixup from here:
>=20
>   http://lkml.org/lkml/2008/3/12/63

Yes, it does. With that patch on top of Dave's, I see no stack
backtraces in dmesg anymore.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6BA0E70E9347D3E7759D1B6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH4abKMdB4Whm86/kRApucAJ4iM0kk6tR52+iNAPS7g6dXsLA+1QCePpm1
OfDDZfS22n8WiK8Zh5PBNEk=
=NP1u
-----END PGP SIGNATURE-----

--------------enig6BA0E70E9347D3E7759D1B6E--
