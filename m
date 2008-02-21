Return-Path: <linux-kernel-owner+w=401wt.eu-S1765231AbYBUU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765231AbYBUU3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYBUU26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:28:58 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:52956 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851AbYBUU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:28:56 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
X-Message-Flag: Warning: May contain useful information
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 21 Feb 2008 12:28:55 -0800
In-Reply-To: <20080221154951.GA28328@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Thu, 21 Feb 2008 17:49:51 +0200")
Message-ID: <adahcg2awag.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Feb 2008 20:28:55.0672 (UTC) FILETIME=[616AA780:01C874C8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This driver should really have gotten some review before being included 
 > in the kernel.

 > Even a simple checkpatch run finds more than > 250 stylistic errors
 > (not code bugs but cases where the driver violates the standard code 
 > formatting rules of kernel code).

Linus has strongly stated that we should merge hardware drivers early,
and I agree: although the nes driver clearly needs more work, there's
no advantage to users with the hardware in forcing them to wait for
2.6.26 to merge the driver, since they'll just have to patch the
grungy code in themselves anyway.  And by merging the driver early, we
get fixed up for any tree-wide changes and allow janitors to help with
the cleanup.

(By the way, the code is not that pretty but it a lot closer to
upstream style than most driver submissions)

 > And these are just comments from someone with zero knowledge about 
 > InfiniBand, but I'd expect InfiniBand-specifig bugs might be found 
 > before they hit users if an InfiniBand maintainer would review the 
 > complete driver.

Just for the record, although this driver is under drivers/infiniband,
it is actually for a device that does iWARP/10 Gb ethernet.  At some
point we may want to rename drivers/infiniband to drivers/rdma, but so
far the churn hasn't seemed worth it for what is basically a cosmetic
issue.

 - R.
