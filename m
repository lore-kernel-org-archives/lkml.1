Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYL2QOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYL2QOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYL2QNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:13:39 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:16400 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYL2QNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:13:38 -0500
X-IronPort-AV: E=Sophos;i="4.36,296,1228089600"; 
   d="scan'208";a="123366832"
From: Roland Dreier <rdreier@cisco.com>
To: Aleksey Senin <alekseys@voltaire.com>
Cc: "general\@lists.openfabrics.org" <general@lists.openfabrics.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 29 Dec 2008 08:13:36 -0800
In-Reply-To: <1230544737.4261.33.camel@alst60> (Aleksey Senin's message of
	"Mon, 29 Dec 2008 11:58:57 +0200")
Message-ID: <adavdt3t0wf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 16:13:36.0817 (UTC) FILETIME=[678CE210:01C969D0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > After another investigation of this problem, I think that proposed
 > solution is #ifdef as good for a first stage. IPv6 support is mandatory
 > when we are talking about running linux in some organization. But, of
 > course, the way how it implemented in IB stack should be changed. So on
 > the second stage, I'd like drop out these "defines" and at the time of
 > module initialization obtain addresses of IPv6 functions and in the case
 > if they are present at the runtime, call them. It should be nice
 > solution for RMDA_CM and IPoIB modules.

I don't think this second stage sounds like a good idea.  Suppose
someone loads the RDMA CM first, so it doesn't find the ipv6 functions,
and then later loads and configures ipv6.  You'll end up in a situation
where trying to make an IPv6 connection fails spuriously.  (And just the
ugliness of looking up function pointers isn't very nice either)

 - R.
