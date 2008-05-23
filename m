Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbYEWJld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbYEWJld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYEWJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:41:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56048 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbYEWJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:41:14 -0400
Subject: Re: fair group scheduler not so fair?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: "Li, Tong N" <tong.n.li@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, pj@sgi.com
In-Reply-To: <20080523094216.GK3780@linux.vnet.ibm.com>
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins>
	 <4835D14B.20904@nortel.com>
	 <1211486868.6463.134.camel@lappy.programming.kicks-ass.net>
	 <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
	 <20080523094216.GK3780@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 23 May 2008 11:39:21 +0200
Message-Id: <1211535561.6463.184.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 15:12 +0530, Srivatsa Vaddagiri wrote:
> On Thu, May 22, 2008 at 01:18:33PM -0700, Li, Tong N wrote:
> > Peter,
> > 
> > I didn't look at your patches, but I thought you were flattening group
> > weights down to task-level so that the scheduler only looks at per-task
> > weights.
> 
> Wouldnt that require task weight readjustment upon every fork/exit?

If you were to do that - yes that would get you into some very serious
trouble.

The route I've chosen is to basically recompute it every time I need the
weight. So every time I use a weight, I do:

  \Prod_{l=1} w_l/rw_{l-1}

Not doing that will get you O(n) recomputes on all sorts of situations.


