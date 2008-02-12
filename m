Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYBLWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYBLWFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYBLWEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:04:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40780 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbYBLWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:04:52 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Miller <davem@davemloft.net>
Subject: Re: BTRFS only works with PAGE_SIZE <= 4K
Date: Tue, 12 Feb 2008 17:03:34 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <20080212.135547.82632980.davem@davemloft.net>
In-Reply-To: <20080212.135547.82632980.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121703.34980.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, David Miller wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Wed, 6 Feb 2008 12:00:13 -0500
>
> > So, here's v0.12.
>
> Any page size larger than 4K will not work with btrfs.  All of the
> extent stuff assumes that PAGE_SIZE <= sectorsize.

Yeah, there is definitely clean up to do in that area.

>
> I confirmed this by forcing mkfs.btrfs to use an 8K sectorsize on
> sparc64 and I was finally able to successfully mount a partition.

Nice

>
> With 4K there are zero's in the root tree node header, because it's
> extent's location on disk is at a sub-PAGE_SIZE multiple and the
> extent code doesn't handle that.
>
> You really need to start validating this stuff on other platforms.
> Something that isn't little endian and something that doesn't use 4K
> pages.  I'm sure you have some powerpc parts around somewhere. :)

Grin, I think around v0.4 I grabbed a ppc box for a day and got things 
working.  There has been some churn since then...

My first prio is the newest set of disk format changes, and then I'll sit down 
and work on stability on a bunch of arches.

>
> Anyways, here is a patch for the kernel bits which fixes most of the
> unaligned accesses on sparc64.

Many thanks, I'll try these out here and push them into the tree.

-chris
