Return-Path: <linux-kernel-owner+w=401wt.eu-S1765378AbXKPL2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765378AbXKPL2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbXKPL2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:28:45 -0500
Received: from mail.clusterfs.com ([74.0.229.162]:48421 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbXKPL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:28:44 -0500
Date: Fri, 16 Nov 2007 04:28:41 -0700
From: Andreas Dilger <adilger@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Rai <abhishekrai@google.com>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-ID: <20071116112841.GS3966@webber.adilger.int>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <20071115230219.1fe9338c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115230219.1fe9338c.akpm@linux-foundation.org>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007  23:02 -0800, Andrew Morton wrote:
> So we have a section of blocks around the middle of the blockgroup which
> are used for indirect blocks.
> 
> Presmably it starts around 50% of the way into the blockgroup?
> 
> An important question is: how does it stand up over time?  Simply laying
> files out a single time on a fresh fs is the easy case.  But what happens
> if that disk has been in continuous create/delete/truncate/append usage for
> six months?

In the ext4-devel discussion, I asked about placement of the reserved
blocks.  Placement at the beginning of the group showed at worst
marginally less performance and in some cases better performance.
I suspect putting the reserved blocks at the beginning of the group
would have a better long-term effect on performance because they are
not in the middle of large contiguous allocations in the middle of
the group.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

