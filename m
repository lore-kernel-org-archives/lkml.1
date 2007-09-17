Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXIQP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXIQP4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXIQP4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:56:06 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:53764 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXIQP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:56:05 -0400
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="399528022"
To: John Blackwood <john.blackwood@ccur.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and ib_umad_close() issue
X-Message-Flag: Warning: May contain useful information
References: <46EE9BCC.1040301@ccur.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 17 Sep 2007 08:56:01 -0700
In-Reply-To: <46EE9BCC.1040301@ccur.com> (John Blackwood's message of "Mon, 17 Sep 2007 11:22:52 -0400")
Message-ID: <adaps0hnv5a.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2007 15:56:01.0600 (UTC) FILETIME=[3EDACC00:01C7F943]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > When using OFED-1.2.5 based infiniband kernel modules on 2.6.22 based
 > kernels with the Ingo Molnar CONFIG_PREEMPT_RT applied, then commands
 > such as ibnetdiscvoer, smpquery, sminfo, etc. will hang.  The problem
 > is with the downgrade_write() rw semaphore usage in the
 > ib_umad_close() routine.

Can you give a few more details on how PREEMPT_RT changes locking
rules (or just exposes existing bugs maybe?) so that the
downgrade_write() causes the issue?  I would like to fix this cleanly
but I don't really understand what the problem is.

 - R.
