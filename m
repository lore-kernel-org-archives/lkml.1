Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYH2Kwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYH2Kwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYH2KwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:52:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:48961 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYH2KwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:52:24 -0400
Date: Fri, 29 Aug 2008 19:51:56 +0900 (JST)
Message-Id: <20080829.195156.31189122.ryusuke@osrg.net>
To: arnd@arndb.de
Cc: joern@logfs.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
From: konishi.ryusuke@lab.ntt.co.jp
In-Reply-To: <200808291040.06917.arnd@arndb.de>
References: <20080827181904.GD1371@logfs.org>
	<200808290629.AA00218@capsicum.lab.ntt.co.jp>
	<200808291040.06917.arnd@arndb.de>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 10:40:06 +0200, Arnd Bergmann wrote:
> On Friday 29 August 2008, Ryusuke Konishi wrote:
> > >Do you do wear leveling or scrubbing?
> > 
> > NILFS does not support scrubbing. (as you guessed)
> > Under the current GC daemon, it writes logs sequentially and circularly
> > in the partition, and as you know, this leads to the wear levelling
> > except for superblock.
> 
> I don't see how that would cope with file systems that have a lot
> of static data. The classic problem of most cheap devices that implement
> wear leveling in hardware is that they never move data in an erase block
> that is used for read-only data. If 90% of the file system is read-only,
> your wear leveling will only work on 10% of the medium, wearing it down
> 10 times faster than it should.
>
> Can the GC daemon handle this case, e.g. by moving around aging read-only
> erase blocks?

Yeah, exactly.  Thank you for this comment.

To minimize aging of the device itself, the userland GC daemon would
need another cleaning policy.  So, in that sense, the answer of the
above question is NO.

Since the primary purpose of NILFS is providing continuous
snapshotting, the GC is not necessarily designed with such requirement
in mind.

Regards,
Ryusuke Konishi
