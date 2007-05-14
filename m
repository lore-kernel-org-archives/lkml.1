Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXENNvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXENNvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXENNu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:50:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:46013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXENNuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:50:54 -0400
Date: Mon, 14 May 2007 06:51:10 -0700
From: John Johansen <jjohansen@suse.de>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFD Patch 0/4] AppArmor - Don't pass NULL nameidata to vfs_create/lookup/permission IOPs
Message-ID: <20070514135110.GC5877@suse.de>
References: <20070514110650.866217377@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <20070514110650.866217377@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

sigh, and with the intoductory text attached

This post is a request for discussion on creating a second minimal
nameidata struct to eliminate conditionally passing of vfsmounts
to the LSM.

It contains a series of patches that apply on top of the AppArmor
patch series.  A previous version of these patches was posted by
Andreas Gruenbacher on April 16, and the issues raised then have been
addressed.

To remove conditionally passing of vfsmounts to the LSM, a nameidata
struct can be instantiated in the nfsd and mqueue filesystems.  This
however results in useless information being passed down, as not
all fields in the nameidata struct will be meaingful.  The nameidata
struct is split creating struct nameidata2 that contains only the fields
that will carry meaningful information.

The creation of the nameidata2 struct raises the possibility of
replacing the current dentry, vfsmount argument pairs in the
vfs and lsm patches with a single nameidata2 argument although these
patches do not currently do this.

A tarball of these patches and the AppArmor kernel patches  are
available at:

  http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGSGlOi/GH5xuqKCcRAj6nAKCeD/eIkOaC0UlNOfVmQvRrz1YrWACgic6d
lY8hQDX0t7aL++GeEgm44YU=
=nsiU
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
