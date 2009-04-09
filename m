Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZDIDui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZDIDui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZDIDuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:50:06 -0400
Received: from main.gmane.org ([80.91.229.2]:35321 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbZDIDuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:50:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ryan Hill <dirtyepic@gentoo.org>
Subject: Re: Error: freeing invalid memtype
Date: Wed, 8 Apr 2009 21:00:13 -0600
Message-ID: <20090408210013.62e878c6@halo.dirtyepic.sk.ca>
References: <49C03208.6050603@gmail.com>
	<1237399938.4529.208.camel@localhost.localdomain>
	<49C572CC.6090704@gmail.com>
	<20090323190720.GA16831@linux-os.sc.intel.com>
	<49C95C66.2050100@gmail.com>
	<20090324222516.GA4292@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ysoNmJ5A9hYqFS6=iJW0PeP";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106001f3b27dbf9.mj.shawcable.net
X-Newsreader: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ysoNmJ5A9hYqFS6=iJW0PeP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2009 23:25:16 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> No, there was no fix in this area mainline, so it's this patch. I've=20
> queued up the fix for the .30 merge window with a -stable backport=20
> tag - so it will show up in .29.1 or .29.2 if it remains=20
> problem-free.
>=20
> Thanks a lot for your testing! Below is the final commit.

I'm running 2.6.29.1 which has this patch but I'm still seeing an insane
number of these.  I can't trigger them just by running glxinfo like
Kevin, however opening a few tabs containing large images in firefox does t=
he
trick and also freezes my system for about a minute.

cat /debug/x86/pat_memtype_list before the bug gives me ~17000 lines, of th=
e form

write-combining @ 0xeff70000-0xeff71000
write-combining @ 0xeff71000-0xeff72000
write-combining @ 0xeff72000-0xeff73000
write-combining @ 0xeff73000-0xeff74000
write-combining @ 0xeff74000-0xeff75000
write-combining @ 0xeff75000-0xeff76000
write-combining @ 0xeff76000-0xeff77000
write-combining @ 0xeff77000-0xeff78000
write-combining @ 0xeff78000-0xeff79000
write-combining @ 0xeff79000-0xeff7a000

checking pat_memtype_list after triggering the bug produced ~25000 lines, so
I'm thinking a diff isn't really helpful.

you can find my kernel log @
http://dev.gentoo.org/~dirtyepic/misc/logs/20090508-kern.log

what other info do you need?


--=20
gcc-porting,                                      by design, by neglect
treecleaner,                              for a fact or just for effect
wxwidgets @ gentoo     EFFD 380E 047A 4B51 D2BD C64F 8AA8 8346 F9A4 0662

--Sig_/ysoNmJ5A9hYqFS6=iJW0PeP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkndZMIACgkQiqiDRvmkBmL9YACeNElxaKhnFStSAlVk49bxfDP+
zbcAoJ84dkvZdH9ZMuAeCUIcenQKQ8MV
=S1o5
-----END PGP SIGNATURE-----

--Sig_/ysoNmJ5A9hYqFS6=iJW0PeP--


