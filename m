Return-Path: <linux-kernel-owner+w=401wt.eu-S1031049AbXD1Fux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031049AbXD1Fux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031059AbXD1Fuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:50:52 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42164 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXD1Fuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:50:39 -0400
X-IronPort-AV: i="4.14,464,1170662400"; 
   d="scan'208"; a="141743683:sNHT44044146"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
X-Message-Flag: Warning: May contain useful information
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 27 Apr 2007 22:50:37 -0700
In-Reply-To: <20070427221803.2a117c23.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 27 Apr 2007 22:18:03 -0700")
Message-ID: <adaodl9m4ia.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 05:50:37.0940 (UTC) FILETIME=[259BA340:01C78959]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > box:/usr/src/25> ~/checkpatch.pl patches/git-infiniband.patch 

Yup, I ran this too.

 > Checking patches/git-infiniband.patch:  signoffs = 113
 > Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
 > 8143:+  BUG_ON(mlx4_ib_alloc_db_from_pgdir(pgdir, db, order));
 > 12629:+ BUG_ON(cmd->free_head < 0);
 > 16580:+         BUG_ON(index < dev->caps.num_mgms);
 > 16665:+                 BUG_ON(amgm_index_to_free < dev->caps.num_mgms);
 > 16681:+         BUG_ON(index < dev->caps.num_mgms);

I agree -- killing the kernel for a driver bug is dump.  I'll remove
all these BUGs before merging.

 > Don't init statics to 0/NULL:
 > 10333:+         path->static_rate = 0;

This is a false positive/opportunity for script improvement, obviously.

 > 15461:+static int msi_x = 0;
 > 16113:+ static int mlx4_version_printed = 0;

Already zapped these.

 - R.
