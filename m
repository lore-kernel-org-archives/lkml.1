Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXG0QiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXG0QiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbXG0Qh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:37:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57719 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbXG0Qh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:37:58 -0400
Subject: Re: [PATCH] remove hugetlb_instantiation_mutex
From: Adam Litke <agl@us.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1185523069.4688.115.camel@ymzhang>
References: <1185523069.4688.115.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 11:37:57 -0500
Message-Id: <1185554277.23817.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey... I am amazed at how quickly you came back with a patch for this :)
Thanks for looking at it.  Unfortunately there is one show-stopper and I
have some reservations (pun definitely intended) with your approach:

First, your patch does not pass the libhugetlbfs test
'alloc-instantiate-race' which was written to tickle the the race which
the mutex was introduced to solve.  Your patch works for shared
mappings, but not for the private case.

Second, the introduction of another pair of global counters triggers my
internal warning system... These global counters are known to cause
problems with NUMA and cpusets.  Have you considered these interactions?
Additionally, the commit/rollback logic you are using closely parallels
what we already do with the huge page reservation mechanism.  Is there
any way you could integrate your stuff into the reservation system to
avoid all the duplicated logic?

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

