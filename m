Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZEZI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZEZI6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZEZI6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:58:06 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48175 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZEZI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=GEZBwh/DXvSmHUR7XALtZMuquPSwp57VMJGUxHKg1qBs2Y0qOkMWTpB5TlihyH8Jnd
         lnTbkVt10/8zSBEzQ2CTVZSb7e6DA2z+EW9Ox5BnLnaE3pcrRNAywlhd3UY/t5bjt2Y3
         wpg3PszAqy7tQvWUDZJHh131/tNcXaqcL9lEY=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Tue, 26 May 2009 10:58:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <200905251323.07845.IvDoorn@gmail.com> <1243255326.6297.53.camel@varda>
In-Reply-To: <1243255326.6297.53.camel@varda>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Z86GKBFekEKSJxr"
Message-Id: <200905261058.01039.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Z86GKBFekEKSJxr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 25 May 2009, Alejandro Riveira Fern=E1ndez wrote:
> El lun, 25-05-2009 a las 13:23 +0200, Ivo van Doorn escribi=F3:
> > On Monday 25 May 2009, Alejandro Riveira Fern=E1ndez wrote:
> > > I reported it previously but i'm resending it as a regresion
> > >=20
> > > More info on the bugzilla
> > >=20
> > >  http://bugzilla.kernel.org/show_bug.cgi?id=3D13362
> > >=20
> > > I bisected it in the estable tree (it regresses too) and the revert
> > > helps there but reverting the upstream commit in mainline does not he=
lp
> > > to fix it completely...
> >=20
> > Bug 9273 -  rt2500pci: low TCP throughput
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=3D9273
> >=20
> > Bug 443203 -  Fedora rawhide + ralink =3D slow bit rate
> > 	https://bugzilla.redhat.com/show_bug.cgi?id=3D443203
> >=20
> > [Hardy][Intrepid] Low bandwidth with rt2400 / rt2500 drivers
> > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/190515
> >=20
> > I can't call this a regression, dozens people have reported the problems
> > ranging from kernels 2.6.25 to 2.6.29. Perhaps in your case it worked s=
lightly
> > better once, but that was not the case for all other users.
> >=20
> > Have you tried the "iwconfig wlan0 rate54M" workaround?
>=20
>    Yep during various releases I used that workaround but once I
> switched to minstrel rate choosing alg (that's the neme isn't it) the
> problem gone away and i got allways a good connection for several
> releases and many kernels tried; till this patch. If I revert this patch
> the problem goes away completly and reliably (i'm using 2.6.29.4 with
> the patch reveted) so something has clearly regressed for me.
>=20
>  You can see my coments ( ariveira ) on rt2x00 forums regarding the
> issues you mention (low speed that gets fixed forcing the rate) in the
> long thread about rt2500pci low rate[1].
> =20
>  Checking the message i see that it was 2.6.27  when i began using
> minstrel and got a rock solid connection in 2.6.27.x, 2.6.28.x and
> 2.6.29 minus 64e1b00c974ddeae6a60ebb02e1c487371905cea
>=20
>  The problem is not that I get a low rate on connect (1Mbit) that i can
> easily fix with iwconfig the problem is that with 54M (and 48M and the
> like) connections I get a bumpy and low speed connection.
> =20
> So I honesty think it is not the same issue and I hope you read this as
> an interesting data point and not just as a duplicate.
>=20
> Would the output of this script[2] for 2.6.29.4 with and without the
> revert help you ?

Yes please try it. but for 2.6.29 you probably need attached script instead.
I am not sure if it would produce something useful, because I think Johannes
assertion is right. With his patch the correct bitmask is send to the driver
and the driver actually needs _that_ bitmask without any editing
(rather then the incorrect one which was send before that patch).

Ivo

--Boundary-00=_Z86GKBFekEKSJxr
Content-Type: application/x-shellscript;
  name="rt2x00_regdump.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt2x00_regdump.sh"

#!/bin/bash

#
# Copyright (C) 2008 Ivo van Doorn <IvDoorn@gmail.com>
#
# This script can be used to dump the contents of the rt2x00
# registers which are found in debugfs.
#

#
# regexp matches for mac80211 interfaces and the rt2x00 drivers
#
MAC80211_REGEXP='phy*'
RT2X00_REGEXP='rt[0-9]*'

#
# Find where debugfs is mounted, when it isn't we might as well
# bail out immediately.
#
DEBUG_ROOT=`grep debugfs /proc/mounts | cut -d' ' -f2 | head -n 1`
if [ -z ${DEBUG_ROOT} ]; then
	echo "debugfs not mounted!"
	exit 1
fi

#
# When no argument is given, we are looping over all mac80211 interfaces
# which contain a valid rt2x00 entry (a folder which matches RT2X00_REGEXP).
# If an argument is given, we check if it is a directory, if that is the case,
# we try to use that as root for the register dump. Otherwise we check the
# argument against MAC80211_REGEXP and RT2X00_REGEXP to limit the number
# of interfaces to check. When the argument matches MAC80211_REGEXP we only
# need to loop that interface, while when it matches RT2X00_REGEXP we must
# loop over all interfaces for that driver.
#
if [ -z ${1} ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${MAC80211_REGEXP}/${RT2X00_REGEXP}/
elif [ -d ${1} ]; then
	DEBUG_ROOT_RT2X00=${1}/
elif [ `expr "${1}" : "${RT2X00_REGEXP}"` -gt 0 ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${MAC80211_REGEXP}/${1}/
elif [ `expr "${1}" : "${MAC80211_REGEXP}"` -gt 0 ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${1}/${RT2X00_REGEXP}/
else
	echo "Unknown argument: ${1}"
fi

function doPrint()
{
	REGISTER_DIR=${1}/register
	CHIPSET_FILE=${1}/chipset
	DRIVER_FILE=${1}/driver
	FLAGS_FILE=${1}/dev_flags

	echo -n "kernel: "
	uname -r
	cat ${DRIVER_FILE}
	echo -n "dev_flags: "
	cat ${FLAGS_FILE}
	cat ${CHIPSET_FILE}

	#
	# All register statistics is formatted as:
	# name	base	words	wordsize
	#
	while read line
	do
		IFS=":"
		DATA=( $line )

		echo -e "\n${DATA[0]}"
		for (( x=0; x<${DATA[1]}; x=x+1 )); do
			echo $x > "${REGISTER_DIR}/${DATA[0]}_offset"
			echo -n $x :
			cat "${REGISTER_DIR}/${DATA[0]}_value"
		done
	done < <(awk --posix '/^[a-zA-Z]+(\t[0-9]+){3}$/ { print $1":"$3 }' ${CHIPSET_FILE})

	echo -e "\n"
}

for entry in `ls -d1 ${DEBUG_ROOT_RT2X00}`; do
	doPrint ${entry}
done

--Boundary-00=_Z86GKBFekEKSJxr--
