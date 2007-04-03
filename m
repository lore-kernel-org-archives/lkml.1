Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXDCULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXDCULb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422688AbXDCULb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:11:31 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:56887 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422689AbXDCULa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:11:30 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: getting processor numbers
Date: Tue, 3 Apr 2007 22:13:07 +0200
User-Agent: KMail/1.9.6
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <461286D6.2040407@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com> <46129619.8050107@redhat.com>
In-Reply-To: <46129619.8050107@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1842195.VXrHKpgWiW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704032213.20244.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1842195.VXrHKpgWiW
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ulrich,

On Tuesday 03 April 2007, Ulrich Drepper wrote:
> So, anybody else has a proposal?  This is a pressing issue and cannot
> wait until someday in the distant future NUMA topology information is
> easily and speedily accessible.

Since for now you just need a fast and dirty hack, which will be replaced=20
with better interfaces, I suggest creating a directory with some files in i=
t.
These should just contain, what you need to handle your most pressing cases.

I propose /sys/devices/system/topology_counters/ for that.
These can contain "online_cpu", "proped_cpu", "max_cpu"
and maybe the same for nodes. All that as a simple file with an integer
value.

Since sysfs-attribute files are pollable (if the owners notifies sysfs=20
on changes), you also have the notification system you need=20
(select, poll, epoll etc.).

If you promise to just keep the slow code around, than one day when the shi=
ny=20
NUMA topology stuff is ready, this directory can be completely removed and
glibc (plus all their users) keeps working. It will then even work better w=
ith a=20
new glibc version, which supports the shiny new NUMA topology stuff.

The kernel can create these counters quiete easy, since most of them are=20
the hamming weight (or population count) of some bitmaps.

Does this sound like a proper hacky solution? :-)

Regards

Ingo Oeser

--nextPart1842195.VXrHKpgWiW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGErVgU56oYWuOrkARAjfQAKC6P37r5xy64/xwj4IYOG0D3mKpYgCeIzWa
PLygB9QyTRF7q9e81PRt8JI=
=TJFo
-----END PGP SIGNATURE-----

--nextPart1842195.VXrHKpgWiW--
