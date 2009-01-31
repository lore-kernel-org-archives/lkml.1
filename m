Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZAaIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZAaIkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAaIkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:40:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48743 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZAaIkY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:40:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Holger Macht <hmacht@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded - docking station issues.
In-Reply-To: Your message of "Fri, 30 Jan 2009 21:03:52 PST."
             <20090130210352.cf9e4d7f.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org> <20830.1233246343@turing-police.cc.vt.edu>
            <20090130210352.cf9e4d7f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233391214_3882P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 31 Jan 2009 03:40:14 -0500
Message-ID: <4126.1233391214@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233391214_3882P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Jan 2009 21:03:52 PST, Andrew Morton said:
> On Thu, 29 Jan 2009 11:25:43 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 28 Jan 2009 02:19:09 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > >    http://userweb.kernel.org/~akpm/mmotm/

> > % ls -l /sys/devices/platform/dock.0/docked
> > -r--r--r-- 1 root root 4096 2009-01-29 10:49 /sys/devices/platform/dock.0/docked
> > % cat /sys/devices/platform/dock.0/docked
> > =F1=DEcat: write error: Bad address
> >
> > strace of the cat shows:
> >
> > open("/sys/devices/platform/dock.0/docked", O_RDONLY) = 3
> > fstat(3, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> > read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 1812586496

> > Under 2.6.29-rc2-mmotm0116, this would return either "0" or "1", not 4K
> > of nulls.

> Is it due to
>
> acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch

Bingo. Reverting that patch and the sysfs-read-simplified.patch fixed it.

So obviously something in there doesn't agree with the innards of my laptop -

Dell Latitude D820, BIOS is A09 (current), if that helps anybody...

--==_Exmh_1233391214_3882P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJhA5ucC3lWbTT17ARAt6iAKDovhSrQQvSJ4k/VbIRhZ4cVeAWoQCfR1KO
k+G8xjuIeCxrCGsaG26/ZL0=
=86Nx
-----END PGP SIGNATURE-----

--==_Exmh_1233391214_3882P--
