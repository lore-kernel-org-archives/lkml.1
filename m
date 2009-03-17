Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZCQQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZCQQ44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZCQQ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:56:47 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55934 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZCQQ4q (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:56:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oliver Neukum <oliver@neukum.org>
Cc: jkosina@suse.cz, gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
In-Reply-To: Your message of "Tue, 17 Mar 2009 16:07:20 BST."
             <200903171607.20942.oliver@neukum.org>
From: Valdis.Kletnieks@vt.edu
References: <6648.1237271589@turing-police.cc.vt.edu>
            <200903171607.20942.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237308917_3640P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Mar 2009 12:55:17 -0400
Message-ID: <23407.1237308917@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237308917_3640P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Mar 2009 16:07:20 BST, Oliver Neukum said:
> Am Dienstag 17 M=C3=A4rz 2009 07:33:09 schrieb Valdis.Kletnieks@vt.edu:
> > Yes, there's an NVidia driver loaded - but this looks like an HID/USB
> > bug, where it's shooting itself in the foot by flushing the workqueue while
> > not realizing it's in a worker thread already, thus deadlocking.

> I am looking into it. Do you know why you get a reset?

This is a good question indeed - and I suspect the answer is "flaky hardware".

During the evening at home, I usually have 2 things plugged into USB ports. One
is a Microsoft mouse, and the other is a Targa USB-powered cooling pad
(basically just 2 USB-powered fans). The pad in question:

http://www.amazon.com/Targus-PA248U-Notebook-Chill-Pad/dp/B0000AKA8Y

There's zero actual smarts inside the cooling pad as far as I can tell - it
just draws its milliamps to drive the fans.

I noticed that most of the wedges happened right after I moved the laptop,
and there's apparently an intermittent short in the USB power cable for the
Targa - at one point the fans stopped until I moved the cable a little.

So I'm suspecting that the Targa glitched and did something the USB hub
noticed, the USB system concluded there was a confused device and tried to
reset it back to sanity - but did it from a thread it shouldn't have done it
from (guessing here, not having looked at the code).

--==_Exmh_1237308917_3640P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJv9X1cC3lWbTT17ARAgEsAJ98pYeAFPAjlGkD6ctxfMhhQfCFjACfUgTo
eV9XhbcJaRSJGGcPC4NkkKU=
=kQoy
-----END PGP SIGNATURE-----

--==_Exmh_1237308917_3640P--
