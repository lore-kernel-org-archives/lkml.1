Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0BOPrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:47:25 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:31925 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0BOPrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:47:22 -0500
Date: Mon, 15 Feb 2010 10:45:16 -0500
From: Chris Mason <chris.mason@oracle.com>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Message-ID: <20100215154516.GB11057@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	James Cloos <cloos@jhcloos.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B796C6F.00FC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 10:11:07PM -0500, James Cloos wrote:
> Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
> usually on the order of 60% sys, 40% user.
> 
> I've tried this with each of ext4, jfs and btrfs filesystems.  All show
> the same issue.
> 
> Using dd(1) to read from the block specials directly works as well and
> as fast as it always has; only reading or writing to mounted filesystems
> is affected.
> 
> Box is 32-bit x86, PentiumIII-M; drives are ide using libata.
> 
> If the btrfs fs is mounted, the slowdown is enought to trigger the
> hung_task call trace (120s) on the btrfs-transac process.
> 
> But the regression is just as apparent when only jfs and ext4 are mounted.
> 
> The only filesystems I've found which avoid the regression are tmpfs and
> devtmpfs.

Could you please hit sysrq-l a few times during the high CPU usage and
send us the results?  Also, please send along the full dd command line
you are using and how much ram your system has.

(Even better would be running perf record <your dd command line>, if
you're willing to setup perf)

Thanks!
