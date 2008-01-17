Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYAQNA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYAQNA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYAQNAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:00:10 -0500
Received: from tamago.serverit.net ([91.189.209.155]:49156 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750965AbYAQNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:00:08 -0500
X-Greylist: delayed 1768 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 08:00:08 EST
Date: Thu, 17 Jan 2008 14:29:47 +0200 (EET)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Daniel Phillips <phillips@google.com>
cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
In-Reply-To: <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
Message-ID: <Pine.LNX.4.62.0801171130560.12451@tamago.serverit.net>
References: <200801090022.55589.a1426z@gawab.com>  <200801090740.12989.a1426z@gawab.com>
  <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> 
 <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> 
 <20080113171916.GB4132@ucw.cz>  <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
  <20080115201653.GA5639@elf.ucw.cz> <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Daniel Phillips wrote:

> Along with this effort, could you let me know if the world actually
> cares about online fsck?  Now we know how to do it I think, but is it
> worth the effort.

Most users seem to care deeply about "things just work". Here is why 
ntfs-3g also took the online fsck path some time ago.

NTFS support had a highly bad reputation on Linux thus the new code was 
written with rigid sanity checks and extensive automatic, regression 
testing. One of the consequences is that we're detecting way too many 
inconsistencies left behind by the Windows and other NTFS drivers, 
hardware faults, device drivers.

To better utilize the non-existing developer resources, it was obvious to 
suggest the already existing Windows fsck (chkdsk) in such cases. Simple 
and safe as most people like us would think who never used Windows. 

However years of experience shows that depending on several factors chkdsk 
may start or not, may report the real problems or not, but on the other 
hand it may report bogus issues, it may run long or just forever, and it 
may even remove completely valid files. So one could perhaps even consider 
suggestions to run chkdsk a call to play Russian roulette.

Thankfully NTFS has some level of metadata redundancy with signatures and 
weak "checksums" which make possible to correct some common and obvious 
corruptions on the fly.

Similarly to ZFS, Windows Server 2008 also has self-healing NTFS:
http://technet2.microsoft.com/windowsserver2008/en/library/6f883d0d-3668-4e15-b7ad-4df0f6e6805d1033.mspx?mfr=true

	Szaka

--
NTFS-3G:  http://ntfs-3g.org
