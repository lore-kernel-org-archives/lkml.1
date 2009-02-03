Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZBCMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZBCMa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZBCMaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:30:07 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:50765 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZBCMaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:30:05 -0500
Date: Tue, 3 Feb 2009 10:30:28 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203123028.GA3788@vespa.holoscopio.com>
Mail-Followup-To: "Daniel P. Berrange" <berrange@redhat.com>,
	debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20090203102416.GA8886@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 03, 2009 at 10:24:16AM +0000, Daniel P. Berrange wrote:
> On Mon, Feb 02, 2009 at 07:41:53PM -0200, Thadeu Lima de Souza Cascardo w=
rote:
> > From what I've seen, most of them are in the same phases as Debian, or,
> > perhaps, behind. Fedora seems to plan that for Fedora 11, and they have
> > some support in libvirt.
>=20
> libvirt is not going to impose any policy for mount points, nor mount
> anything itself. When we use cgroups, libvirt just looks up the mount
> table to find out where the admin or distro has put the mount points
> for each cgroups controller.
>
> I've also not done anything in default Fedora install to automatically
> setup cgroups, since doing that hits the hard-to-answer question of
> whether to mount all controllers in one, or a separate mount per
> controller, or a hybrid.

Sorry. I didn't mean to imply that libvirt or Fedora did anything in
respect to the mountpoint themselves. But that they are supporting or
planning to support cgroups. And I think that one time we will need to
sort the problem of the mountpoint, either let the applications mount it
(in this case, libvirt) or the system do it (Fedora install, Debian
initscripts, et al).

I have some experience with lxc tools from http://lxc.sf.net/ and these
tools also look up the mountpoint at /proc/mounts. So it is up to the
system or the user to mount it.

> > So, we have some more options now: /cgroups, /containers, /dev/cpuset,
> > /dev/cpuctl, /opt/cgroup, /opt/cpuset.
>=20
> Putting new mount points in / is not really acceptable, so that rules
> out the first two. /opt is just totally wrong, since that is intended
> for add on software packages. /dev/ feels a little odd, since it is
> not really device nodes, but perhaps that doesn't matter. So my pref
> would be something in /dev/cgroups or /sys/cgroups

My suggestions were /proc/cgroup, /sys/cgroup, /cgroup or /dev/cgroup. I
sent the problems with the former two, and the rationale for the latter
two in a previous message.

I agree that /opt/ is not the place for it (and that's the one I called
'funny'). I've head some people telling that /dev/ is for devices, but I
can't see a problem (/dev/log is a socket and it is there, the FHS
refers to special files).

/proc/ and /sys/ are two good options if the kernel does not put anything
else there. /proc/cgroups already exist, for example.

Could you please give your rationale why / is not really acceptable?

> I also think 'cgroups' is a better name than 'containers', since=20
> 'containers' is refering to just one specific use case.

Agreed on this one, although I still prefer the singular (it is also the
name of the filesystem type).

> Regards,
> Daniel
> --=20
> |: Red Hat, Engineering, London   -o-   http://people.redhat.com/berrange=
/ :|
> |: http://libvirt.org  -o-  http://virt-manager.org  -o-  http://ovirt.or=
g :|
> |: http://autobuild.org       -o-         http://search.cpan.org/~danberr=
/ :|
> |: GnuPG: 7D3B9505  -o-  F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 950=
5 :|

Regards,
Cascardo.

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmIOOQACgkQyTpryRcqtS1cAgCeO1/pdNbB1W8bK4GEYClvrDIY
QpYAnjdDLhrpufaM0EB2T0E4oofJr2Ft
=NxVw
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
