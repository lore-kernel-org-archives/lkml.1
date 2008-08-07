Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYHGSxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYHGSxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYHGSxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:53:41 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:33389 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYHGSxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:53:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18587.17566.499689.722996@stoffel.org>
Date: Thu, 7 Aug 2008 14:53:18 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linasvepstas@gmail.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
In-Reply-To: <yq17iasg4k3.fsf@sermon.lab.mkp.net>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<18580.48861.657366.629904@stoffel.org>
	<3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	<18581.6873.353028.695909@stoffel.org>
	<3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	<20080803231628.1361b75f@lxorguk.ukuu.org.uk>
	<3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
	<20080805182119.75913fa3@lxorguk.ukuu.org.uk>
	<3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
	<yq1fxphfs2y.fsf@sermon.lab.mkp.net>
	<3ae3aa420808062132x52860092p9dee56705ba99a3@mail.gmail.com>
	<yq17iasg4k3.fsf@sermon.lab.mkp.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:
Linas> My problem is that the corruption I see is "silent": so
Linas> redundancy is useless, as I cannot distinguish good blocks from
Linas> bad.  I'm running RAID, one of the two disks returns bad data.
Linas> Without checksums, I can't tell which version of a block is the
Linas> good one.

Martin> But btrfs can.

Maybe.  I'd not trust btrfs even now because the on-disk format is
going to change yet again from the currently released version.  I'm
personally interested in it, but not quite enough to use it.  :]

Linas> There is also in interesting possibility that offers a middle
Linas> ground between raw performance and safety: instead of verifying
Linas> checksums on *every* read access, it could be enough to verify
Linas> only every so often -- say, only one out of every 10 reads, or
Linas> maybe triggered by a cron job in the middle of the night: turn
Linas> on verification, touch a bunch of files for an hour or two,
Linas> turn off verification before 6AM.

If you're reading the file off disk, it doesn't cost anything to
verify it then, esp if the checksum is either in the metadata or next
to the blocks themselves.  

It's corruption in files which aren't read which turns into a
problem.  

Martin> All evidence suggests that scrubbing is a good way to keep
Martin> your data healthy.

Yup.  And mirroring anything you think is important.  Disk is cheap,
mirroring is good.

Heck, I'd pay good money for a SATA disk which mirrored inside itself
or which joined two seperate spindle/head assemblies into one and did
all the error correction at a low level.  

