Return-Path: <linux-kernel-owner+w=401wt.eu-S1763172AbXEPTyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763172AbXEPTyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXEPTyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:54:15 -0400
Received: from tuxrocks.com ([63.99.9.217]:53874 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888AbXEPTyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:54:13 -0400
Message-ID: <464B5FF7.5070701@tuxrocks.com>
Date: Wed, 16 May 2007 14:48:07 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
References: <1178485128.31213.98.camel@localhost.localdomain> <1179309789.3764.20.camel@chaos>
In-Reply-To: <1179309789.3764.20.camel@chaos>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> I'm pleased to announce an updated version of the x86_64 highres/dyntick
> support patches against 2.6.22-rc1:
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v5.patch
> 
> Broken out version is available here:
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v5.patches.tar.bz2
> 
> Changes since the last version:
> 
> - Enforced enabling of HPET (Venki Pallipadi)
> 	Detects and enables HPET on Intel ICHx chipsets, when the BIOS
> 	hides it.
> 
> 	Venki, great work, thanks !
> 
> - Another variant of PIT wreckage fixup
> 	Frank, does this one work for you ?

Unfortunately, no.

After adding *lots* of early_printks, I see that it hangs in
hpet_is_known(hdp) called from hpet_alloc(&hd), so something in the hpet
code is still buggy.  Adding nohpet to the kernel command line allows it
to boot correctly.

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGS1/3aI0dwg4A47wRAuaIAKD1MG5x4cvWXGRCwkHEGBzhUHyJlQCfez+S
ODHcJ4FEJ4W4LB7NzW32X6Q=
=r1q5
-----END PGP SIGNATURE-----
