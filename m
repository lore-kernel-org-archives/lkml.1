Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYDHJjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYDHJjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYDHJjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:39:45 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:12178 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYDHJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:39:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.379
Date: Tue, 8 Apr 2008 11:39:38 +0200 (CEST)
From: "Andreas K. Huettel" <A.K.Huettel@tudelft.nl>
X-X-Sender: huettel@localhost
Reply-To: "Andreas K. Huettel" <mail@akhuettel.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [tainted,fglrx] page allocation failure: basic meaning of log
 messages?
In-Reply-To: <1207234830.8514.838.camel@twins>
Message-ID: <alpine.LNX.1.00.0804081125140.22515@localhost>
References: <alpine.LNX.1.00.0804031117030.10277@localhost>  <20080403183021.028C.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <alpine.LNX.1.00.0804031318480.10277@localhost>  <20080403144852.GD24239@csclub.uwaterloo.ca> <1207234830.8514.838.camel@twins>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
X-Information: My public GPG key can be obtained at http://www.akhuettel.de/
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160


#]> > #]> Apr  3 09:01:30 bellini hal-system-powe: page allocation failure. order:10, mode:0x4020
#]> > #]> Apr  3 09:01:30 bellini Pid: 327, comm: hal-system-powe Tainted: PF       2.6.24-gentoo-r3 #1
#]> > #]> Apr  3 09:01:30 bellini [<c0140c48>] __alloc_pages+0x2bd/0x2ce
#]> > #]> Apr  3 09:01:30 bellini [<c0140c92>] __get_free_pages+0x39/0x47
#]> > #]> Apr  3 09:01:30 bellini [<f8adcd9e>] firegl_cmmqs_save_fb+0x8e/0x200 [fglrx]
#]> > #]
#]> > #]this messages doesn't mean bug, merely indicate allocation failure.
#]> > #]if any other bad thind doen't happend, you can ignore it.
#]> > 
#]> > Swapping like mad without any obvious cause (500M swap in use, 1.5G RAM 
#]> > - - which is normally not such a big problem). This however stopped when 
#]> > I closed some memory-intensive applications (firefox, vmware).
#]> > 
#]> > Since then the machine is running without problems. 
(...)
#]
#]An order 10 alloc (4 mb contiguous) isn't likely to succeed by any
#]measure. Lumpy reclaim will try very hard and likely cause that swap
#]storm you taked about, but relying on order 10 allocs is insane.


Question - this seems to me not to be a kernel issue (correct me if I'm 
wrong) and thus I'd like to take it to the proper place...
Where should I file this as bug? Is this a hald problem or something more 
complicated?

The swap storm is perfectly reproducible with X/fglrx, compiz and vmware 
workstation running - after resume from suspend2ram it starts. No compiz - 
no problem. No vmware - no problem... Closing vmware -> swapping stops.

If you think this is hopeless since too much closed source software is 
involved, tell me... :-]


Thanks, Andreas




- --
This message is transmitted using 100% recycled electrons.
- --
- ---------------------------------------------------------------------
Dr. Andreas K. Huettel                  tel. +31 15 27 88102  (univ.)
Molecular Electronics and Devices            +31 6 42527466  (mobile)
Kavli Institute of Nanoscience Delft
Delft University of Technology                 A.K.Huettel@tudelft.nl
PO Box 5046, 2600 GA Delft                          mail@akhuettel.de
The Netherlands                     http://www.akhuettel.de/research/
- ---------------------------------------------------------------------
Please use GNUPG or PGP for signed and encrypted email. My public key
can be found at  http://www.akhuettel.de/pgp_key.php

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH+z1f3ao2Zwy3NWoRA8/iAJ0bLbIFJ9FfHolzuw4eOsNalMhMQACfTBxm
IEKmTD381DwK2Atl4mJB/24=
=jvjl
-----END PGP SIGNATURE-----
