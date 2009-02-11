Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbZBKAwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbZBKAwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbZBKAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:38:07 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:53651 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbZBKAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:38:04 -0500
X-IronPort-AV: E=Sophos;i="4.38,188,1233532800"; 
   d="scan'208";a="140681789"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Feb 2009 16:38:03 -0800
In-Reply-To: <20090210184448.22891.31130.stgit@dell3.ogc.int> (Steve Wise's
	message of "Tue, 10 Feb 2009 12:44:48 -0600")
Message-ID: <adamyctajv8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 00:38:03.0683 (UTC) FILETIME=[FFC55F30:01C98BE0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll roll this into the offending patch (that is in -next).

But:

 > -		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
 > -				(1UL << (12 + page_size[i])));
 > +		wqe->recv.sgl[i].to = cpu_to_be64(((u64) wr->sg_list[i].addr) &
 > +				((1UL << (12 + page_size[i]))-1));

Is this required?  Strength reduction optimization should do this
automatically (and the code has been there for quite a while, so
obviously it isn't causing problems)

 - R.
