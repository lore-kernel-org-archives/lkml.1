Return-Path: <linux-kernel-owner+w=401wt.eu-S637770AbXDSNyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637770AbXDSNyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637769AbXDSNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:54:14 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:22630 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766704AbXDSNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:54:13 -0400
X-IronPort-AV: i="4.14,427,1170662400"; 
   d="scan'208"; a="479488231:sNHT1959561956"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, reiserfs-dev@namesys.com, linux-mm@kvack.org
Subject: Re: dio_get_page() lockdep complaints
X-Message-Flag: Warning: May contain useful information
References: <20070419073828.GB20928@kernel.dk>
	<20070419012540.bed394e2.akpm@linux-foundation.org>
	<20070419083407.GD20928@kernel.dk> <200704191643.38367.vs@namesys.com>
	<20070419124933.GE11780@kernel.dk> <20070419125236.GF11780@kernel.dk>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 19 Apr 2007 06:53:55 -0700
In-Reply-To: <20070419125236.GF11780@kernel.dk> (Jens Axboe's message of "Thu, 19 Apr 2007 14:52:36 +0200")
Message-ID: <adavefstqq4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Apr 2007 13:53:55.0829 (UTC) FILETIME=[2BFA9A50:01C7828A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > As I mentioned, the rootfs is on reiser. So something in the boot up
 > scripts may trigger something that gets reiser to run through that path
 > with the wrong locking order. After the box is done booting, the dmesg
 > is clean. I then mount the ext3 fs and run the fio test, the lockdep
 > trace shows up immediately.

Maybe you could add some hack really early on (say at the beginning of
the reiserfs mount code) that took instances of the locks in the
correct order, so you would get a lockdep trace of where the ordering
is violated when it first happens?

 - R.
