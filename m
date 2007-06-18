Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbXFRUHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbXFRUHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763360AbXFRUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:07:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34168 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbXFRUH2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:07:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
In-Reply-To: Your message of "Sat, 16 Jun 2007 10:36:00 -0000."
             <20070616101126.296384219@inhelltoy.tec.linutronix.de>
From: Valdis.Kletnieks@vt.edu
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1182197191_14795P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Jun 2007 16:06:31 -0400
Message-ID: <6972.1182197191@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1182197191_14795P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Jun 2007 10:36:00 -0000, Thomas Gleixner said:
> The following patch series contains:
> 
> - dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)
> 
> - updates and improvements to high resolution timer / dynticks 
> 
> - high resolution timer / dynticks support for x86_64

Am running with the 22-rc4-mm2-hrt4 patch on my Latitude D820.  Mostly seems
to work, but for some reason the Intel 'powertop' util thinks it's 100% busy:

     PowerTOP version 1.7       (C) 2007 Intel Corporation

Cn          Avg residency (5s)          P-states (frequencies)
C0 (cpu running)        (100.0%)
C1                0.0ms ( 0.0%)         2.00 Ghz     0.0%
C2                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C3                0.0ms ( 0.0%)         1333 Mhz     0.0%
                                        1000 Mhz   100.0%

In reality:

[/sys/devices/system/cpu/cpu0/cpuidle] for i in */*; do echo -n "$i: "; cat $i; done
state0/latency: 1
state0/power: 1000
state0/time: 0
state0/usage: 3
state1/latency: 1
state1/power: 500
state1/time: 1756017623
state1/usage: 1837402
state2/latency: 57
state2/power: 100
state2/time: -159524787
state2/usage: 15007443

I think we have a 32/64 bit issue on state2/time which is probably borking
things up....


--==_Exmh_1182197191_14795P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGduXHcC3lWbTT17ARApoqAJ0bqM6keQdiqRFj5BdEpvz737YKugCeM9sj
l8kwISgqweQHg2uy00tbF6E=
=j9tx
-----END PGP SIGNATURE-----

--==_Exmh_1182197191_14795P--
