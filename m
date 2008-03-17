Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYCQU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYCQU4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYCQU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:56:16 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:34160 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYCQU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:56:15 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather than pid_t
X-Message-Flag: Warning: May contain useful information
References: <47DE683E.3050005@openvz.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 17 Mar 2008 13:56:14 -0700
In-Reply-To: <47DE683E.3050005@openvz.org> (Pavel Emelyanov's message of "Mon, 17 Mar 2008 15:46:54 +0300")
Message-ID: <adatzj5f4sx.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Mar 2008 20:56:14.0387 (UTC) FILETIME=[567E7830:01C88871]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The task_struct->tgid field is about to become deprecated, due to
 > pid namespaces make tasks have many pids, not one. The infiniband
 > driver is one of the code, that still uses it in some places.

Looks fine in terms of the changes it makes, but actually it seems
that the ehca use of this is completely bogus and the ownership
checking should be removed.

The core ib_uverbs module has checks that make sure that objects can
only be accessed through the file that they were created through; of
course there are tricky ways a file can be passed from one process to
another, but I don't think we want to disallow userspace processes
from trying to do interesting stuff as long as it doesn't hurt anything.

In other words-- ehca shouldn't be looking at tgids or anything like
that at all.  If there are missing checks then they should be in the
core userspace verbs stuff; but I think what we have is actually OK.

ehca guys, what do you think?

 - R.
