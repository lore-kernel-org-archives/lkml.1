Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYHULx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYHULx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbYHULxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:53:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40302 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbYHULxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:53:12 -0400
Date: Thu, 21 Aug 2008 05:53:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Message-ID: <20080821115310.GP8318@parisc-linux.org>
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821060418.GC5706@disturbed>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> One thing I just found out - my old *laptop* is 4-5x faster than the
> 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> if the long delays in dispatch is caused by an interaction with CTQ
> but I can't change it on the cciss raid controllers. Are you using
> ctq/ncq on your machine?  If so, can you reduce the depth to
> something less than 4 and see what difference that makes?

I don't think that's going to make a difference when using CFQ.  I did
some tests that showed that CFQ would never issue more than one IO at a
time to a drive.  This was using sixteen userspace threads, each doing a
4k direct I/O to the same location.  When using noop, I would get 70k
IOPS and when using CFQ I'd get around 40k IOPS.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
