Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab0BRQnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:43:21 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54977 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab0BRQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:43:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stupid futex question - 2.6.33-rc7-mmotm0210
In-Reply-To: Your message of "Thu, 18 Feb 2010 15:37:59 +0100."
             <1266503879.26719.702.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <10057.1266501862@localhost>
            <1266503879.26719.702.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1266511334_3979P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Feb 2010 11:42:15 -0500
Message-ID: <7380.1266511335@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B7D6DE9.0068,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1266511334_3979P
Content-Type: text/plain; charset=us-ascii

(Adding some cc: to the list)

On Thu, 18 Feb 2010 15:37:59 +0100, Peter Zijlstra said:
> On Thu, 2010-02-18 at 09:04 -0500, Valdis.Kletnieks@vt.edu wrote:
> > Kernel: x86_64 2.6.33-rc7-mmotm0210
> > 
> > I'm debugging a problem where pulseaudio is getting killed with a SIGKILL
> > out of the blue.  It appears to be a problem where pulseaudio sets
> > RLIMIT_RTTIME and the bound gets exceeded.  Analysis with 'top' shows
> > a short spike of 96% system time, and the tail end of strace shows this:
> > 
> > [pid 25065] 01:50:20.371484 ioctl(28, USBDEVFS_CONTROL, 0x7fd3d76f630c) = 0 <0.000015>
> > [pid 25065] 01:50:20.371548 ioctl(28, 0x40045532, 0x7fd3d76f636c) = 0 <0.000016>
> > [pid 25065] 01:50:20.371611 open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_CLOEXEC <unfinished ...>
> > [pid 25064] 01:50:20.371678 <... write resumed> ) = 8 <0.002104>
> > [pid 25064] 01:50:20.371718 futex(0xc2ec00, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
> > [pid 25066] 01:50:21.408392 +++ killed by SIGKILL +++
> > PANIC: handle_group_exit: 25066 leader 25064
> > [pid 25065] 01:50:21.408442 +++ killed by SIGKILL +++
> > PANIC: handle_group_exit: 25065 leader 25064
> > 01:50:21.420354 +++ killed by SIGKILL +++
> > 
> > thread 25064 apparently gets gunned down due to RTTIME because it spent a whole
> > second in a futex() call - is it reasonable for futex() to not return for that
> > long?
> > 
> > In other words - kernel bug because futex() should return, or pulseaudio bug
> > for not understanding futex() can snooze a while?
> > 
> > If a kernel bug, anybody got a better idea than nuking the RLIMIT_RTTIME call,
> > waiting for it to repeat (takes between 1 minute and 1 hour or so), and
> > whomping it a few times with sysrq-T?
> 
> is that second spend in processing sysrq-t?

No, currently that second is spent in a futex() syscall - I'm wondering:

1) should it get killed for RLIMIT_RTTIME because it's been in a futex()
for multiple seconds? It seems suspicious - docs say a blocking syscall
resets RTTIME - so if futex() blocks it shouldn't kill, and if it's in the
kernel for a second without blocking it's a bug too.

2) Is sysrq-T my best bet here, or should I be trying something else first?

--==_Exmh_1266511334_3979P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLfW3mcC3lWbTT17ARAs7vAJwMLR6Zg1vGLFlDsdEJgfMZRVld7ACg8Gd3
ujujCNYVugWsjgHdwzLBQCA=
=aKe7
-----END PGP SIGNATURE-----

--==_Exmh_1266511334_3979P--

