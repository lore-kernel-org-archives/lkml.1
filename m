Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXLFDs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXLFDs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXLFDsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:48:21 -0500
Received: from ozlabs.org ([203.10.76.45]:59876 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXLFDsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:48:20 -0500
Subject: Re: drivers/net/iseries_veth.c dubious sysfs usage
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: "Kyle A. Lucke" <klucke@us.ibm.com>, David Gibson <dwg@au1.ibm.com>,
       linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071205214103.GA7074@kroah.com>
References: <20071205093054.GA23229@kroah.com>
	 <1196853031.6759.7.camel@concordia>  <20071205214103.GA7074@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WXUSAmZ3vjnQlWxZ9CC7"
Date: Thu, 06 Dec 2007 14:48:18 +1100
Message-Id: <1196912898.14754.13.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WXUSAmZ3vjnQlWxZ9CC7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-12-05 at 13:41 -0800, Greg KH wrote:
> On Wed, Dec 05, 2007 at 10:10:31PM +1100, Michael Ellerman wrote:
> > On Wed, 2007-12-05 at 01:30 -0800, Greg KH wrote:
> > > In doing a massive kobject cleanup of the kernel tree, I ran across t=
he
> > > iseries_veth.c driver.
> > >=20
> > > It looks like the driver is creating a number of subdirectories under
> > > the driver sysfs directory.  This is odd and probably wrong.  You wan=
t
> > > these virtual connections to show up in the main sysfs device tree, n=
ot
> > > under the driver directory.
> > >=20
> > > I'll be glad to totally guess and try to move it around in the sysfs
> > > tree, but odds are I'll get it all wrong as I can't really test this
> > > out :)
> > >=20
> > > Any hints on what this driver is trying to do in this sysfs directori=
es?
> >=20
> > I wrote the code, I think, but it's been a while - I'll have a look at
> > it tomorrow.
>=20
> Yes, can you send me the sysfs tree output of the driver directory, and
> what exactly the different files in there are supposed to be used for?

Sure. My version of tar (1.15.1) doesn't seem to be able to tar up /sys,
so hopefully this is sufficient:

igoeast:~# cd /sys/class/net/eth1/
igoeast:/sys/class/net/eth1# ls -la
total 0
drwxr-xr-x  4 root root    0 Dec  6 10:22 .
drwxr-xr-x  6 root root    0 Dec  6 10:21 ..
-r--r--r--  1 root root 4096 Dec  6 10:30 addr_len
-r--r--r--  1 root root 4096 Dec  6 10:30 address
-r--r--r--  1 root root 4096 Dec  6 10:30 broadcast
-r--r--r--  1 root root 4096 Dec  6 10:30 carrier
lrwxrwxrwx  1 root root    0 Dec  6 10:22 device -> ../../../devices/vio/3
-r--r--r--  1 root root 4096 Dec  6 10:30 dormant
-r--r--r--  1 root root 4096 Dec  6 10:30 features
-rw-r--r--  1 root root 4096 Dec  6 10:30 flags
-r--r--r--  1 root root 4096 Dec  6 10:30 ifindex
-r--r--r--  1 root root 4096 Dec  6 10:30 iflink
-r--r--r--  1 root root 4096 Dec  6 10:30 link_mode
-rw-r--r--  1 root root 4096 Dec  6 10:30 mtu
-r--r--r--  1 root root 4096 Dec  6 10:30 operstate
drwxr-xr-x  2 root root    0 Dec  6 10:30 statistics
lrwxrwxrwx  1 root root    0 Dec  6 10:30 subsystem -> ../../../class/net
-rw-r--r--  1 root root 4096 Dec  6 10:30 tx_queue_len
-r--r--r--  1 root root 4096 Dec  6 10:30 type
-rw-r--r--  1 root root 4096 Dec  6 10:30 uevent
drwxr-xr-x  2 root root    0 Dec  6 10:30 veth_port

Each net device has a port structure associated with it, the fields
should be fairly self explanatory, they're all read only I think.

igoeast:/sys/class/net/eth1# find veth_port/
veth_port/
veth_port/mac_addr
veth_port/lpar_map
veth_port/stopped_map
veth_port/promiscuous
veth_port/num_mcast


igoeast:/sys/class/net/eth1# cd device/driver

igoeast:/sys/class/net/eth1/device/driver# ls -l
total 0
lrwxrwxrwx  1 root root    0 Dec  6 10:21 2 -> ../../../../devices/vio/2
lrwxrwxrwx  1 root root    0 Dec  6 10:21 3 -> ../../../../devices/vio/3
--w-------  1 root root 4096 Dec  6 10:21 bind
drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx00
drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx02
drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx03
drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx04
lrwxrwxrwx  1 root root    0 Dec  6 10:21 module -> ../../../../module/iser=
ies_veth
--w-------  1 root root 4096 Dec  6 10:21 uevent
--w-------  1 root root 4096 Dec  6 10:21 unbind

The driver has a connection to all the other lpars, this is entirely
independent of the net devices.

igoeast:/sys/class/net/eth1/device/driver# find cnx00/
cnx00/
cnx00/outstanding_tx
cnx00/remote_lp
cnx00/num_events
cnx00/reset_timeout
cnx00/last_contact
cnx00/state
cnx00/src_inst
cnx00/dst_inst
cnx00/num_pending_acks
cnx00/num_ack_events
cnx00/ack_timeout


> > Why is it "odd and probably wrong" to create subdirectories under the
> > driver in sysfs?
>=20
> Because a driver does not have "devices" under it in the sysfs tree.
> All devices liven in the /sys/devices/ tree so we can properly manage
> them that way.  A driver will then bind to a device, and the driver core
> will set up the linkages in sysfs properly so that everthing looks
> uniform.

OK. They're not "devices" that we create under the driver, they're just
attributes of the driver, and they happen to be in groups so I put them
in subdirectories.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-WXUSAmZ3vjnQlWxZ9CC7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBHV3ECdSjSd0sB4dIRAkvWAJdG7IPHC00OzrXIWVIrnFhD6olrAKCbz8It
n9rCW1AWZH90YYs/CU/rVw==
=gd13
-----END PGP SIGNATURE-----

--=-WXUSAmZ3vjnQlWxZ9CC7--

