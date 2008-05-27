Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYE0RTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYE0RTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYE0RT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:19:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55681 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYE0RTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:19:25 -0400
Date: Tue, 27 May 2008 22:58:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, dhaval@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080527172807.GF30285@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834B75A.40900@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:59:22PM -0600, Chris Friesen wrote:
> I then redid the test with two hogs in one group and three hogs in the 
> other group.  Unfortunately, the cpu shares were not equally distributed 
> within each group.  Using a 10-sec interval in "top", I got the following:

I ran with this combination (2 in Group a and 3 in Group b) on top of the 
experimental patch I sent and here's what I get:

 4350 root      20   0  1384  228  176 R 53.8  0.0  52:27.54  1 hoga
 4542 root      20   0  1384  228  176 R 49.3  0.0   3:39.76  0 hoga
 4352 root      20   0  1384  232  176 R 36.0  0.0  26:53.50  1 hogb
 4351 root      20   0  1384  228  176 R 32.0  0.0  26:47.54  0 hogb
 4543 root      20   0  1384  232  176 R 29.0  0.0   2:03.62  0 hogb

Note that fairness (using load balance approach we have currently) works
over a long window. Usually I observe with "top -d30". Higher the
asymmetry of task-load distribution, longer it takes to converge to
fairness.

-- 
Regards,
vatsa
