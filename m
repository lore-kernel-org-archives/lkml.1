Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZDMTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZDMTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZDMTba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:31:30 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34540 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZDMTb3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:31:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, mm-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: Your message of "Mon, 13 Apr 2009 10:27:49 PDT."
             <20090413102749.4ca3a217.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu>
            <20090413102749.4ca3a217.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239650838_7306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Apr 2009 15:27:18 -0400
Message-ID: <7799.1239650838@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239650838_7306P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Apr 2009 10:27:49 PDT, Andrew Morton said:

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Atttempting to rid us of the problematic work_on_cpu().  Just use
> smp_call_fuction_single() here.
> 
> This repairs a 10% sysbench(oltp)+mysql regression which Mike reported,
> due to 
> 
> commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Thu Apr 9 09:50:37 2009 -0600
> 
>     work_on_cpu(): rewrite it to create a kernel thread on demand
> 
> It seems that the kernel calls these acpi-cpufreq functions at a quite
> high frequency.

I put the one reverted commit back on (making it back into what was stock
mmotm-0410 that had the problem) and then applied this patch.  I'm seeing
near-zero forks/second again,  the CPU is at 1Ghz when idling (as it should
be), if I kick off 2 'for(;;)' cycle-suckers it goes to 2Ghz,  And it even
puts 1 CPU at 1Ghz and the other at 2Ghz if there's only one running - I didn't
know a Core2 Duo could do that. ;)

So life is good again. ;)

--==_Exmh_1239650838_7306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ45IWcC3lWbTT17ARAg8VAKCxHgm7NH1btTKxsaSbGen0s1VspQCg9Sox
fglS1rkta0UGA8bbfjtGoa8=
=esOH
-----END PGP SIGNATURE-----

--==_Exmh_1239650838_7306P--
