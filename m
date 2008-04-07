Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbYDGGWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbYDGGWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYDGGWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:22:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34711 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYDGGWH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:22:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm1 - BUG: scheduling while atomic: swapper/0/0xffffffff
In-Reply-To: Your message of "Tue, 01 Apr 2008 21:32:14 PDT."
             <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207549282_5425P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Apr 2008 02:21:22 -0400
Message-ID: <4487.1207549282@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207549282_5425P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/

Been seeing these crop up once in a while - can take hours after a reboot
before I see the first one, but once I see one, I'm likely to see more, at
a frequency of anywhere from ~5seconds to ~10 minutes between BUG msgs.

BUG: scheduling while atomic: swapper/0/0xffffffff
Pid: 0, comm: swapper Tainted: P          2.6.25-rc8-mm1 #4

Call Trace:
 [<ffffffff8020b2f4>] ? default_idle+0x0/0x74
 [<ffffffff8022be19>] __schedule_bug+0x5d/0x61
 [<ffffffff80552aea>] schedule+0x11a/0x9e4
 [<ffffffff805536ce>] ? preempt_schedule+0x3c/0xaa
 [<ffffffff802480f1>] ? hrtimer_forward+0x82/0x96
 [<ffffffff804600a4>] ? cpuidle_idle_call+0x0/0xd5
 [<ffffffff8020b2f4>] ? default_idle+0x0/0x74
 [<ffffffff8020b2e0>] cpu_idle+0xf6/0x10a
 [<ffffffff80540cb2>] rest_init+0x86/0x8a

Eventually, I end up with a basically hung system, and need to alt-sysrq-B.

Yes, I know it's tainted, and it's possible the root cause is a self-inflicted
buggy module - but the traceback above seems odd.  Did some of my code manage
to idle the CPU while is_atomic was set, or is the path from cpu_idle on down
doing something it shouldn't be?

(I admit being confused - if my code was the source of the is_atomic error,
shouldn't it have been caught on the *previous* call to schedule - the one
that ran through all the queues and decided we should invoke idle?


--==_Exmh_1207549282_5425P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH+b1icC3lWbTT17ARAtQHAJ916CNMzqH/AoUYIrbeQZNlNDFbGgCgzYKP
mz55GG6B4KbTiB07zzyMYc0=
=ip0K
-----END PGP SIGNATURE-----

--==_Exmh_1207549282_5425P--
