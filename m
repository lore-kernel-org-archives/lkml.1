Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYHKQIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYHKQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYHKQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:07:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47090 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHKQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:07:54 -0400
X-IronPort-AV: E=Sophos;i="4.31,342,1215388800"; 
   d="scan'208";a="138558111"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <489C8BEB.8060001@opengridcomputing.com>
	<489CC58D.4010606@pobox.com> <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 11 Aug 2008 09:07:51 -0700
In-Reply-To: <20080809.224637.69833549.davem@davemloft.net> (David Miller's
	message of "Sat, 09 Aug 2008 22:46:37 -0700 (PDT)")
Message-ID: <adafxpbzga0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2008 16:07:51.0780 (UTC) FILETIME=[680F6A40:01C8FBCC]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Why show these special connections if the user cannot interact with or
 > shape the stream at all like normal ones?

So that an admin can see what connections are open, so that the stack
doesn't try to reuse the same 4-tuple for another connection, etc, etc.

 > And I even wonder, these days, if you probably get %90 or more of the
 > gain these "optimized" iSCSI connections obtain from things like LRO.

Yes, that's the question -- are stateless offloads (plus CRC32C in the
CPU etc) going to give good enough performance that the whole TCP
offload exercise is pointless?  The only issue is that I don't see how
to avoid the fundamental 3X increase in memory bandwidth that is chewed
up if the NIC can't do direct placement.

 - R.
