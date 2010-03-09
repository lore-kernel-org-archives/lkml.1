Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0CIG15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:27:57 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34053 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0CIG1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:27:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: odd lockdep messages
In-Reply-To: Your message of "Tue, 09 Mar 2010 10:54:20 +0900."
             <4B95AA4C.2030303@kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>
            <4B95AA4C.2030303@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268116039_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Mar 2010 01:27:19 -0500
Message-ID: <4298.1268116039@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B95EA4A.0057,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268116039_4061P
Content-Type: text/plain; charset=us-ascii

On Tue, 09 Mar 2010 10:54:20 +0900, Tejun Heo said:
> On 03/09/2010 03:43 AM, Peter Zijlstra wrote:
> >> [    1.899537] BUG: key ffff88011c57e670 not in .data!
> >>
> >> (-0302 threw BUG: 3 times, the first 2 and the last. In -0304, the third
> >> one appears as well).
> >>
> >> Worth instrumenting and chasing down? If so, what should a crash test dummy
> >> be doing here? ;)
> > 
> > Can that be wreckage due to the new per-cpu stuff?
> > 
> > Its a message printed when the below function fails, and that per-cpu
> > stuff seems the one most likely to break, given that there was quite a
> > lot of churn in that department recently.
> 
> Yeap, PERCPU_ENOUGH_ROOM test doesn't hold anymore.  Does the
> following patch fix the problem?

Doesn't seem to make a difference, sorry.

For what it's worth, adding the iwlwifi-5000-2.ucode to the builtin firmware
list fixed the two BUG: messages related to the firmware load.  Not sure if
that tells you anything or not.

However, I still have left:

[    0.997904] Monitor-Mwait will be used to enter C-1 state
[    0.998045] Monitor-Mwait will be used to enter C-2 state
[    0.998184] Monitor-Mwait will be used to enter C-3 state
[    0.998300] Marking TSC unstable due to TSC halts in idle
[    0.998476] Switching to clocksource hpet
[    1.030681] BUG: key ffff88011c8c1d00 not in .data!
[    1.030787] BUG: key ffff88011c8c1d48 not in .data!
[    1.035288] thermal LNXTHERM:01: registered as thermal_zone0
[    1.035405] ACPI: Thermal Zone [THM] (54 C)
[    1.041622] Real Time Clock Driver v1.12b
[    1.041955] Linux agpgart interface v0.103
[    1.042266] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).

I'll stick a 'WAR_ON(1)' next to that BUG printk so we get an idea where it's
happening, probably be morning before that happens though...

--==_Exmh_1268116039_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlepHcC3lWbTT17ARAi6YAKDzilj6k2PLfewHeMK97jWS/3dYWACfQYsN
cVzS5A8rzkLiF9QY0c5YaDU=
=lRGQ
-----END PGP SIGNATURE-----

--==_Exmh_1268116039_4061P--

