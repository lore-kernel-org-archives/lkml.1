Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbXK0HQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbXK0HQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXK0HQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:16:30 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33147 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXK0HQa (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:16:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
In-Reply-To: Your message of "Tue, 20 Nov 2007 20:45:25 PST."
             <20071120204525.ff27ac98.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196147785_2790P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 02:16:26 -0500
Message-ID: <4210.1196147786@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196147785_2790P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Nov 2007 20:45:25 PST, Andrew Morton said:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/

Finally got both time and motivation to at least start a bisect..

2.6.23-mm1 works on my D820 (x86_64 kernel, Core2 Duo T7200)

24-rc3-mm1 (plus 3 patches from hotfixes/) bricks *instantly* at boot - grub
prints its 3 or 4 lines saying what it loaded, the screen clears, and *blam*
dead. No serial console output, no pair of penguins on the monitor, no
netconsole, no earlyprintk=vga output, no alt-sysrq, only thing that does
*anything* is "hold the power button for 5 seconds".  Whatever it is, it
happens *very* early (before we get as far as the 'Linux version 2.6.mumble'
banner), and happens *hard*.

I've bisected it down this far:

git-ipwireless_cs.patch GOOD
git-x86.patch
git-x86-fixup.patch
git-x86-thread_order-borkage.patch
git-x86-thread_order-borkage-fix.patch
git-x86-identify_cpu-fix.patch
git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
git-x86-inlining-borkage.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch BAD

Anybody got any good debugging ideas before I go through and do the final
3 or 4 bisects?  I suspect I'll need them once I find the offending patch
to tell *why* said patch dies on my box - I've seen enough traffic regarding
-rc3-mm1 dying *later* to know it's probably a subtle issue and not one
that will be obvious once I finger a specific patch.  For example, it's
probably not the IO-APIC panic that people are seeing, because their kernels
live long enough to panic. ;)


--==_Exmh_1196147785_2790P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS8RJcC3lWbTT17ARAurnAJ47/0iFwvPXkT++WyYMJ2HKF/KRXACgj1xS
8qtVBhefYVsjljbz7ei4RMU=
=DE5W
-----END PGP SIGNATURE-----

--==_Exmh_1196147785_2790P--
