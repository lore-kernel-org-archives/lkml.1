Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbXBFFDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbXBFFDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXBFFDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:03:08 -0500
Received: from sandeen.net ([209.173.210.139]:28381 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXBFFDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:03:07 -0500
Message-ID: <45C80C05.6090807@sandeen.net>
Date: Mon, 05 Feb 2007 23:03:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: How far should BLKROSET/set_device_ro() go?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at another bug a while ago, I noticed that in 2.6 at 
least, set_device_ro() sets the policy on the hd_struct to mark it 
readonly, but it appears that IO is only really blocked from userspace, 
via generic_write_checks().

There are bdev_read_only() checks in other places, but nothing in a 
common spot to reject all possible IO.

Should we have something in generic_make_request() to reject ALL IO on a 
readonly bdev, or is that further than the policy is supposed to go?  Or 
is it up to each location that might possibly issue that IO to check it 
and be well-behaved?

The motivation for this investigation was ext3 happily doing orphan 
inode recovery on read-only lvm snapshot....

Thanks,

-Eric
