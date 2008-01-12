Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYALRwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYALRwD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 12:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYALRvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 12:51:53 -0500
Received: from kanga.kvack.org ([66.96.29.28]:44297 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbYALRvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 12:51:52 -0500
Date: Sat, 12 Jan 2008 12:51:35 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andi Kleen <ak@suse.de>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH/RFC] synchronize_rcu(): high latency on idle system
Message-ID: <20080112175135.GK28570@kvack.org>
References: <20080112012626.GI28570@kvack.org> <20080112023759.GG21068@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112023759.GG21068@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 03:37:59AM +0100, Andi Kleen wrote:
> > And yes, the 
> > network stack shouldn't call synchronize_rcu() quite so much, but fixing that 
> > is a little more involved.
> 
> ... but the correct solution.

There has to be at least 1 synchronize_rcu() or equivalent in the 
unregister_netdev() path.  I suspect the easiest way to fix it might be to 
use call_rcu() to actually free the network device, as anything else will 
limit performance of single threaded teardown (ie, when an l2tp daemon 
gets terminated via kill -9).  This means an API change that exposes 
rcu for unregister_netdev().

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
