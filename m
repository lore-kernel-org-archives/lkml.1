Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753081AbYLRG4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYLRG4V (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYLRG4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:56:09 -0500
Received: from vps1.tull.net ([66.180.172.116]:34569 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751288AbYLRG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:56:08 -0500
Date: Thu, 18 Dec 2008 17:56:04 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Dylan Taft <d13f00l@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MDADM Software Raid Woes
Message-ID: <20081218065603.GA21265@mail.local.tull.net>
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 11:33:31PM -0500, Dylan Taft wrote:
> I created the raids with the mdadm tool, originally configured manually
> /dev/md0 for sdb1/sdc1 raid1 to be mounted as /boot
> /dev/md1 for sdb2/sdc2 raid0
> 
> I created 3 partitions on md1, one for future /, one for swap, one for
> future /home.
> So I had /dev/md0, md1, and /dev/md1p1,/dev/md1p2/dev/md1p3

Why not use LVM for /dev/md1 ?

	pvcreate /dev/md1
	vgcreate myvg /dev/md1
	lvcreate -L 10G -n root myvg
	lvcreate -L 2G -n swap myvg
	lvcreate -L 20G -n home myvg

Also since you have specified raid0 for /dev/md1 you could
use striping under LVM instead of RAID:

	pvcreate /dev/sdb2 /dev/sdc2
	vgcreate myvg /dev/sdb2 /dev/sdc2
	lvcreate -L 10G -n root -i 2 -I 32 myvg
	lvcreate -L 2G -n swap -i 2 -I 32 myvg
	lvcreate -L 20G -n home -i 2 -I 32 myvg

That way you have some flexibility in your use of sdb2
and sdc2, e.g. you can move your LVs off sdc2 if you want
to replace or extend it later.

Nick.
