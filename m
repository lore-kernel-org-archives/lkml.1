Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbXKCDKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbXKCDKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 23:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbXKCDKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 23:10:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45181 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbXKCDKD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 23:10:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Pavel Machek <pavel@ucw.cz>, Rik van Riel <riel@surriel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: Your message of "Mon, 29 Oct 2007 17:44:52 EDT."
             <20071029214452.GA27643@csclub.uwaterloo.ca>
From: Valdis.Kletnieks@vt.edu
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz> <20071029194820.GC27646@csclub.uwaterloo.ca> <20071029201911.GB3537@elf.ucw.cz>
            <20071029214452.GA27643@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1194059303_5560P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Nov 2007 23:08:23 -0400
Message-ID: <12100.1194059303@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1194059303_5560P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Oct 2007 17:44:52 EDT, Lennart Sorensen said:
> On Mon, Oct 29, 2007 at 09:19:11PM +0100, Pavel Machek wrote:

Sorry for the late reply, it's been a zoo of a week here... ;)

> If it doesn't it seems the compression feature is going to be rather
> unpredictable and my optimization would be perfectly within spec and
> make it pretty much useless.
> 
> > Yes. Typically for all zeros. It will be similar for
> > highly-compressible data (pictures, timetables, ....)

And most executables.  There's a reason why my vmlinux files are 11M and my
vmlinuz files are 2m. :)

> That would make it tricky to say if you should ever skip compression due
> to cpu load.  There is a chance cpu load would be better off by doing
> the compression.

IBM's AIX supported file system compression on the JFS filesystem years ago. I
was able to get up to 30% throughput increases by converting the /usr
filesystem to compressed - because even a 33mhz Power chipset could read in 5
512-byte blocks and decompress it to the original 4K faster than the disk could
read in 8 512-byte blocks.  Oh, and it worked for compression on r/w workloads
as well - that was one of the ways to get a RS6K model 250 (which was a
PowerPC601 chipset, a dead heat with a Mac 6600 (same chipset, same clock) to
handle a million e-mail msgs/day - even /var/spool/mqueue worked better.

Given that today there's an even *bigger* disparity in CPU speed versus disk
speed, I'd be surprised if it doesn't help today too.  As a first try, you
might consider compressing each 4K filesystem block in-place, and only write as
many sectors as the compressed takes (with the obvious fix for the pathological
"grows with compression" case of "just write it without").  Probably even
more wins can be found if you find a way to store the compressed chunks in a
way that minimizes seeks, but that's a filesystem design issue and probably
a too-large project (It's easy to do the stupid way - just store the whole
file as compressed - the tough part is doing it and not making lseek() *too*
painful.  Trying to figure out where in a .gz file byte 65536... ouch. ;)


--==_Exmh_1194059303_5560P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHK+YncC3lWbTT17ARAuzhAKCNNdF+xHCDpyYEOxSs8SMwwsiEOQCdEvyl
mm4BQBc+T6hHIJ6osRMyUi4=
=nLqP
-----END PGP SIGNATURE-----

--==_Exmh_1194059303_5560P--
