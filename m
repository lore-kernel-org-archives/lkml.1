Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0BNDQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 22:16:13 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:50250 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab0BNDQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 22:16:11 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Subject: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 13 Feb 2010 22:11:07 -0500
Message-ID: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100214:linux-kernel@vger.kernel.org::+QAfMJPQBEOlFlAg:00000000000000000000000000000000Y5CxY
X-Hashcash: 1:30:100214:linux-fsdevel@vger.kernel.org::LCUr/eniW/zJEpgw:0000000000000000000000000000000HTF4J
X-Hashcash: 1:30:100214:linux-ext4@vger.kernel.org::qTXaNLZTOKxNSgF4:0000000000000000000000000000000000Cf5k/
X-Hashcash: 1:30:100214:linux-btrfs@vger.kernel.org::1Xs44fwpmcLKcYGn:000000000000000000000000000000000RYqLd
X-Hashcash: 1:30:100214:jfs-discussion@lists.sourceforge.net::x9xoLaTbc3nWSWpk:000000000000000000000000HC3Y5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
usually on the order of 60% sys, 40% user.

I've tried this with each of ext4, jfs and btrfs filesystems.  All show
the same issue.

Using dd(1) to read from the block specials directly works as well and
as fast as it always has; only reading or writing to mounted filesystems
is affected.

Box is 32-bit x86, PentiumIII-M; drives are ide using libata.

If the btrfs fs is mounted, the slowdown is enought to trigger the
hung_task call trace (120s) on the btrfs-transac process.

But the regression is just as apparent when only jfs and ext4 are mounted.

The only filesystems I've found which avoid the regression are tmpfs and
devtmpfs.

I didn't have time to write up a report when I noticed this in rc7 but
had to boot back into rc6 for work.

Some of the commits since rc7 looked like they might have addressed this
regression, but it persists in rc8.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
