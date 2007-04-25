Return-Path: <linux-kernel-owner+w=401wt.eu-S1161794AbXDYSC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161794AbXDYSC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161798AbXDYSC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:02:29 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:43203 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161794AbXDYSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:02:28 -0400
X-IronPort-AV: i="4.14,451,1170662400"; 
   d="scan'208"; a="770736886:sNHT45075016"
To: ebiederm@xmission.com (Eric W. Biederman), linux-kernel@vger.kernel.org
Cc: mst@mellanox.co.il, jackm@mellanox.co.il, ak@suse.de
Subject: pgprot_writecombine() and PATs on x86
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 25 Apr 2007 11:02:26 -0700
Message-ID: <ada1wi8xrgt.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2007 18:02:26.0657 (UTC) FILETIME=[E200E510:01C78763]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Where do your patches to add an implementation of
pgprot_writecombine() using PATs on x86 stand?  The mlx4 driver I'm
planning on merging for 2.6.22 would really like writecombining, and
I'm interested in doing the work to finally get the PAT stuff merged
(probably for 2.6.23 I guess).

Just to give a little background on my motivation: the mlx4 hardware
allows a page in its PCI space to be mapped, where the driver can write
descriptors and payloads directly, instead of ringing a doorbell and
having the HW fetch the descriptor from system memory, for better latency.

The driver allows this page to be mapped to userspace and used
directly from latency sensitive stuff like MPI applications.  I added
a hacked up version of the PAT stuff to map the page into userspace
with pgprot_writecombine(), and that lowered the measured MPI latency
by 450 nsecs, which doesn't seem like much until I tell you that the
latency when from ~1.85 usec to ~1.4 usec.  So copying the descriptor
is a huge part of the total latency and users are definitely going to
want that 25% improvement.

Anyway as I said I want to get the PAT stuff upstream, so I'm posting
this to find out the latest state and avoid duplicating work.

Thanks,
  Roland
