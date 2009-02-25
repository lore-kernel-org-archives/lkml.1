Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZBYTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZBYTTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZBYTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:19:45 -0500
Received: from frost.carfax.org.uk ([212.13.194.111]:4462 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZBYTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:19:44 -0500
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 14:19:43 EST
Date: Wed, 25 Feb 2009 18:54:13 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Chris Mason <chris.mason@oracle.com>
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
Message-ID: <20090225185413.GA2816@selene>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090224230249.GA6859@vlad.carfax.org.uk> <1235586986.32346.48.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1235586986.32346.48.camel@think.oraclecorp.com>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.18 (2008-05-17)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "admin.kwak.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Wed, Feb 25, 2009 at 01:36:26PM -0500, Chris Mason wrote:
	> On Tue, 2009-02-24 at 23:02 +0000, Hugo Mills wrote: > > This is essentially
	a repost of a mail I made last week, to which I > > didn't get a reply. >
	> Sorry I missed replying to this one last week, thanks for resending. [...]
	Content analysis details:   (0.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2009 at 01:36:26PM -0500, Chris Mason wrote:
> On Tue, 2009-02-24 at 23:02 +0000, Hugo Mills wrote:
> > This is essentially a repost of a mail I made last week, to which I
> > didn't get a reply.
> 
> Sorry I missed replying to this one last week, thanks for resending.

   Not a problem. I know things go astray sometimes.

> >    I'm getting huge numbers of kernel warnings whilst using
> > btrfs. They're all "warn_slowpath", and all seem to be in
> > fs/btrfs/disk-io.c. I've included one typical example at the end of
> > this mail.
> > 
> >    Kernel versions are 2.6.29-rc2, -rc4 and -rc6.
> > 
> 
> The warnings look like i386, exactly what hardware is this?  Is your
> kernel compiled for SMP or UP?

   amd64 and a UP kernel:

hrm@vlad:linux-2.6 $ uname -a
Linux vlad 2.6.29-rc6 #1 Mon Feb 23 19:53:22 GMT 2009 x86_64 GNU/Linux

   Hardware is an original-series Turion 64 (i.e. one core) in a
Socket 745 desktop motherboard. The btrfs filesystem is in
LVM-on-RAID1 in an eSATA port-multiplier storage rack.

> The warning you're getting is that clean_tree_block expects this block
> to be locked, and giving out a warning because it is showing up as
> unlocked.
> 
> So, hopefully you're on a UP kernel and my test for a locked spinlock is
> broken in that config.

   OK. I can try patches if necessary.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- UNIX: British manufacturer of modular shelving units. ---      

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJpZPVIKyzvlFcI40RAkQiAKCiFmWYJwB9XcKUNE6M+Mb80xYLegCeOYCr
YdActk+KX9hbb5tr2U+dtAs=
=RJBi
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
