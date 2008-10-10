Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbYJJVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbYJJVnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbYJJVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:43:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23236 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764584AbYJJVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:43:24 -0400
X-IronPort-AV: E=Sophos;i="4.33,391,1220227200"; 
   d="scan'208";a="172908403"
From: Roland Dreier <rdreier@cisco.com>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: "Tom Tucker" <tom@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       v9fs-devel@vger.kernel.org, rminnich@dancer.ca.sandia.gov,
       lionkov@lanl.gov
Subject: Re: [PATCH v2a] 9prdma: RDMA Transport Support for 9P
References: <1223388592-27719-1-git-send-email-tom@opengridcomputing.com>
	<a4e6962a0810101436l1297c28ewd1691f4ac7ddf412@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 10 Oct 2008 14:43:23 -0700
In-Reply-To: <a4e6962a0810101436l1297c28ewd1691f4ac7ddf412@mail.gmail.com>
	(Eric Van Hensbergen's message of "Fri, 10 Oct 2008 16:36:17 -0500")
Message-ID: <adavdw0ktxg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Oct 2008 21:43:23.0858 (UTC) FILETIME=[387FBB20:01C92B21]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > (in cq_comp_handler)
 > >  +               struct p9_rdma_context *c = (void *)wc.wr_id;

cast here should be

               struct p9_rdma_context *c = (void *) (unsigned long) wc.wr_id;

 > ...
 > >  +static int
 > >  +post_recv(struct p9_trans *trans, struct p9_rdma_context *c)
 > >  +       wr.wr_id = (u64)c;

and this should be

	wr.wr_id = (unsigned long) c;

 > Ouch.  I get warnings on these two compiling on 32-bit systems.
