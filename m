Return-Path: <linux-kernel-owner+w=401wt.eu-S1945930AbXC3Eiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930AbXC3Eiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 00:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXC3Eiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 00:38:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945930AbXC3Eiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 00:38:54 -0400
From: Neil Brown <neilb@suse.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Fri, 30 Mar 2007 14:38:48 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17932.37976.65001.735686@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
In-Reply-To: message from Justin Piszcz on Thursday March 29
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
	<17931.23488.160031.119117@notabene.brown>
	<Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 29, jpiszcz@lucidpixels.com wrote:
> 
> >
> > Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> > running at?
> Around 44MB/s.
> 
> I do use the following optimization, perhaps a bad idea if I want other 
> processes to 'stay alive'?
> 
> echo "Setting minimum resync speed to 200MB/s..."
> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
> echo 200000 > /sys/block/md0/md/sync_speed_min
> echo 200000 > /sys/block/md1/md/sync_speed_min
> echo 200000 > /sys/block/md2/md/sync_speed_min
> echo 200000 > /sys/block/md3/md/sync_speed_min
> echo 200000 > /sys/block/md4/md/sync_speed_min
> 

Yes, well....

You told it to use up to 200MB/s and the drives are only delivering
44MB/s, so they will be taking nearly all of the available bandwidth.
You shouldn't be too surprised if other things suffer.

NeilBrown
