Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXCVVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXCVVk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXCVVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:40:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58724 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161095AbXCVVkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:40:25 -0400
Date: Thu, 22 Mar 2007 16:39:45 -0600
From: Cliff Wickman <cpw@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dino@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpusets/sched_domain reconciliation
Message-ID: <20070322223945.GA22206@sgi.com>
References: <4600329B.mailxHGH16L00Y@eag09.americas.sgi.com> <20070322142152.5f6fa41c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322142152.5f6fa41c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Thu, Mar 22, 2007 at 02:21:52PM -0700, Andrew Morton wrote:
> On Tue, 20 Mar 2007 13:14:35 -0600
> cpw@sgi.com (Cliff Wickman) wrote:
> 
> > This patch reconciles cpusets and sched_domains that get out of sync
> > due to disabling and re-enabling of cpu's.
> 
> I get three-out-of-three rejects in cpuset.c.  I could fix them, but I
> wouldn't be very confident that the result works at runtime.  2.6.20-rc6 was
> a long time ago - please, always raise patches against the latest mainline
> kernel (the daily git snapshot suffices).

Will do.
 
> Recursion is a big no-no in kernel.  Is there any way in which it can be
> avoided?  Is Dinakar's implementation also recursive?

I was a little reluctant to use recursion, but this use parallels another,
existing such use in cpuset.c  The depth of the recursion is only the depth of
the cpuset hierarchy, which is set up by an administrator, and which is
logically limited by the number of cpus in the system.  e.g. it would be
hard to even deliberately organize 16 cpus into a hierarchy greater
than 16 layers deep, even if you wanted cpusets of single cpus.
We've not run into such a problem on systems of hundreds of cpus.
I would think it's safe.  What do you think?

Dinakar's solution is not written yet, as far as I know.  I'll copy him
for his status.

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
