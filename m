Return-Path: <linux-kernel-owner+w=401wt.eu-S1765774AbXHWSpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765774AbXHWSpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764859AbXHWSp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:45:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33053 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764534AbXHWSpZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:45:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - irda goes belly up
In-Reply-To: Your message of "Thu, 23 Aug 2007 21:37:55 +0400."
             <20070823173754.GA1818@martell.zuzino.mipt.ru>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu>
            <20070823173754.GA1818@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187894716_3088P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Aug 2007 14:45:16 -0400
Message-ID: <12593.1187894716@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187894716_3088P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <12577.1187894702.1@turing-police.cc.vt.edu>

On Thu, 23 Aug 2007 21:37:55 +0400, Alexey Dobriyan said:
> On Thu, Aug 23, 2007 at 09:33:46AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> > OK, so I don't actually *use* the irDA on my laptop for much, but I figure if
> > I have the hardware, I should at least make sure the driver comes up.
> > 
> > 23-rc3-mm1 causes massive spewage, apparently at least partially as a fall-out
> > of the sysctl rework.  Not sure if those caused the 'unknown symbol' issues or
> > not.  The 'cannot allocate memory' is somewhat odd too, I can't believe it was
> > *really* out of memory while still in /etc/rc5.d when I have 2G of ram...
> 
> Eric is a bit sadistic with sysctls. If sysctl_check_table() fails
> irda_sysctl_register() will think there is no memory.

Ahh.. overloading a failure code. OK, I can deal with that...

> As for unknown symbols, hell knows. Same as with multiple syscts errors.
> What have you modprobed exactly and what is $(grep IRDA .config) ?

>From the .config ("turn them all on and see what sticks" here)

CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m


On my doesn't-complain -rc2-mm1 kernel:

% lsmod | grep -i ir
irnet                  21409  0 
ppp_generic            22177  1 irnet
irtty_sir               8321  0 
sir_dev                14473  1 irtty_sir
ircomm_tty             35345  0 
ircomm                 20425  1 ircomm_tty
irda                  188973  5 irnet,irtty_sir,sir_dev,ircomm_tty,ircomm
crc_ccitt               2817  1 irda

My guess is that irda fails to insmod because of the sysctl errors, so when
the other ir* modules try to load, they come up empty on symbols that irda
provides.

--==_Exmh_1187894716_3088P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGzdW8cC3lWbTT17ARAm7vAKCRBdVN7ytdB3ouimWB6dn5ep75WQCfTf9L
+A/1Zs8WE3cqtgwaeChrQms=
=gcqh
-----END PGP SIGNATURE-----

--==_Exmh_1187894716_3088P--
