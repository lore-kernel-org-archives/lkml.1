Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZF3U10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZF3U10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZF3U1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:27:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60221 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZF3U1S (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:27:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
In-Reply-To: Your message of "Tue, 30 Jun 2009 16:15:52 EDT."
             <54770.1246392952@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
            <54770.1246392952@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246393621_3574P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jun 2009 16:27:01 -0400
Message-ID: <56465.1246393621@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246393621_3574P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 16:15:52 EDT, Valdis.Kletnieks@vt.edu said:
>
> Yowza.  Not sure what makes it think there's an issue at line 20, looks to
> *me* like the actual patch starts on line 77.

>From the patch:

A sample output of /proc/<pid>/task/<tid>/maps looks like:

08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
a7d12000-a7d13000 ---p 00000000 00:00 0
a7d13000-a7f13000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
a7f13000-a7f14000 ---p 00000000 00:00 0

The line with '[heap]' gives it the indigestion - deleting that line and
we get:

% quilt push procfs-provide-stack-information-for-threads-v08.patch
Applying patch procfs-provide-stack-information-for-threads-v08.patch
patching file Documentation/filesystems/proc.txt
patching file fs/exec.c
Hunk #1 succeeded at 1340 (offset -4 lines).
patching file fs/proc/array.c
patching file fs/proc/task_mmu.c
patching file include/linux/sched.h
Hunk #1 succeeded at 1486 (offset 26 lines).
patching file kernel/fork.c
Hunk #1 succeeded at 1094 (offset -1 lines).

Now at patch procfs-provide-stack-information-for-threads-v08.patch

Not sure why that line did it.  Repeated truncate-and-try shows that if the
line contained just the 4 chars '0804', it applied fine, but '0804a' dies.

<Cue twilight zone theme>,


--==_Exmh_1246393621_3574P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKSnUVcC3lWbTT17ARApOdAJ9bwESu5YCahb5btISV9LQLeBEq5wCgnVoV
f2lc7Bnbu8a7T5WJC7c7u7c=
=UJ5L
-----END PGP SIGNATURE-----

--==_Exmh_1246393621_3574P--
