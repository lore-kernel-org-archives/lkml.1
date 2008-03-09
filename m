Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYCIWGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYCIWGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 18:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCIWGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 18:06:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60933 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055AbYCIWF7 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:05:59 -0400
Date: Mon, 10 Mar 2008 09:05:47 +1100
From: David Chinner <dgc@sgi.com>
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <20080309220547.GR155407@sgi.com>
References: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:25:59PM +0100, Frantisek Rysanek wrote:
> A few days ago, I've had my first opportunity to put my hands on a 
> 24bay RAID unit - configured for RAID 60, that's 20 TB of space in a 
> single chunk. I know that RAID units capable of this sort of capacity 
> have been on the market for some time now, so I was somewhat 
> surprised to discover that there are pending issues against Linux...
> 
> The block device is detected/reported just fine.
> I didn't even try Ext3, I know it's not appropriate for this sort of 
> capacity. I've tried Reiser3, and already mkfs.reiserfs (user-space 
> util) refused to create such a big FS. Then I tried XFS. The user-
> space mkfs.xfs had no objections - so far so good. But when I tried 
> to mount the volume thus created, the kernel-space XFS driver 
> (including the one in 2.6.24.2) refused to mount the FS, complaining 
> about the FS being too big to be mounted on this platform.

Sure. the largest address space that can be used on a 32bit platform
with 4k pages is 16TB (2^32 * 2^12 = 2^44 = 16TB). For XFS, that
means metadata can't be placed higher in the filesystem than 16TB,
and seeing as we only have a single address space for metadata, the
filesystem is limited to 16TB. It could be fixed with software
changes, but really there's no excuse for using x86 given how
cheap x86_64 is now.....

> So far I've been using kernels compiled for 32bit mode x86.
> Obviously I have LBD support enabled, and it's always worked 
> flawlessly. Would it be any help if I switched to 64bit mode?
> My machines have been capable of that for a few years now, but so far 
> I had no reason to switch, as the memory capacities installed hardly 
> ever reached 4 GB...

Yes, switching to 64 bit machines will fix this problem as the
address space will now hold 2^64*2^12 bytes.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
