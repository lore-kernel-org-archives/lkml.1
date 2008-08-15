Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbYHOTaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbYHOTaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYHOT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:29:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37028 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbYHOT36 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:29:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: Peter Dolding <oiaohm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
In-Reply-To: Your message of "Fri, 15 Aug 2008 14:50:01 EDT."
             <OF1D7319B5.AB5A1EFB-ON852574A6.0066E026-852574A6.006775BA@us.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <OF1D7319B5.AB5A1EFB-ON852574A6.0066E026-852574A6.006775BA@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218828172_3568P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Aug 2008 15:22:52 -0400
Message-ID: <26206.1218828172@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218828172_3568P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Aug 2008 14:50:01 EDT, Kenneth Goldman said:
> "Peter Dolding" <oiaohm@gmail.com> wrote on 08/15/2008 06:37:27 AM:
> 
> > Remember even soldered on stuff can fail.   How linux handles the
> > death of the TPM module needs to be covered.
> 
> Is fault tolerance a requirement just for the TPM, or is it a general>
> Linux requirement?  Has it always been there, or is it new?
> 
> For example, does kernel software have to gracefully handle
> failures in the disk controller, processor, memory controller, BIOS
> flash memory, etc?

Well, on a dual/quad core/socket/whatever system, a failing processor
can be downed and the system keep going.  On a NUMA box, you can yank a
node with a bad memory controller after you take it down.  Similarly for
a disk controller if you have more than one, and the failed one isn't
critical for system operation.

And the TPM chip is more like a USB controller, in that there's a *high*
degree of probability that the system will still be able to run even if it
fails or goes insane (consider that on my laptop, the TPM driver was broken
for a while, and I was still ableto work).  So you need to write code to
do things like detect TPM downage or insanity, decide what to do on the
kernel level, what to reflect up to any security modules running in
userspace, etc....

--==_Exmh_1218828172_3568P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpdeMcC3lWbTT17ARAr5VAJ4vGL/aihFid/5cB85Do+1SdSBjZgCdHENs
MC55uwDkXGbJi2aN8musrUY=
=iIYg
-----END PGP SIGNATURE-----

--==_Exmh_1218828172_3568P--
