Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYEOINB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYEOINB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYEOIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:12:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45088 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYEOIMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:12:43 -0400
Date: Thu, 15 May 2008 13:50:33 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080515082033.GA14823@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080509155240.GH3612@linux.vnet.ibm.com> <1210556351.3151.2.camel@ymzhang> <20080512023758.GN3612@linux.vnet.ibm.com> <1210563200.3151.10.camel@ymzhang> <20080512045246.GP3612@linux.vnet.ibm.com> <1210568533.3151.13.camel@ymzhang> <1210583090.7402.4.camel@marge.simson.net> <1210584047.6524.12.camel@lappy.programming.kicks-ass.net> <20080514134414.GA12693@linux.vnet.ibm.com> <1210777967.10126.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210777967.10126.17.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 05:12:47PM +0200, Peter Zijlstra wrote:
> A few other things I found that make a significant difference:

One more observation: access to aggregate()->rq_weight etc arent
correctly synchronized i.e while a cpu is doing a aggregate_walk_tree()
in a domain, and thus possibly modifying rq_weight, load etc, other cpus could 
be concurrently accessing the same data. As a result, its possible to
see inconsistent rq_weight, load, task_weight combination?

-- 
Regards,
vatsa
