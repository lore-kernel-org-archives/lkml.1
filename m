Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXCFCQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXCFCQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbXCFCQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:16:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933857AbXCFCQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:16:19 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Mar 2007 13:15:00 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] knfsd: revised patches to fix IPv6/sunrpc link error and other fixes
Message-ID: <20070306131103.26638.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revised version of previous patches:
 - Fixed the 'nfsd hang when stopped' problem
 - Dropped the 'avoid checking udp checksum' as I'm no longer convinced it is
   the right way to go.
 - Added a paranoia check that the control message returned by recvfrom
   is in-fact a PKTINFO message.

Tested that a udp mount still works, and the the nfsd server can be stopped and
restarted successfully.  Found that it still doesn't if there is active
traffic so fixed that.
Also patch from Greg Banks to make the thread-pool stuff non-default as
it is not optimal on all machines, and often needs tuning where it can
be optimal.

Thanks,
NeilBrown

 [PATCH 001 of 4] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
 [PATCH 002 of 4] knfsd: Remove CONFIG_IPV6 ifdefs from sunrpc server code.
 [PATCH 003 of 4] knfsd: Fix recently introduced problem with shutting down a busy NFS server.
 [PATCH 004 of 4] knfsd: Provide sunrpc pool_mode module option
