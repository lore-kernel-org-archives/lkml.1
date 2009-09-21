Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZIUSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZIUSHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZIUSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:07:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58818 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZIUSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:07:34 -0400
Date: Mon, 21 Sep 2009 19:07:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
Message-ID: <20090921180739.GT12726@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie> <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 01:54:12PM -0400, Christoph Lameter wrote:
> Lets just keep SLQB back until the basic issues with memoryless nodes are
> resolved.

It's not even super-clear that the memoryless nodes issues are entirely
related to SLQB. Sachin for example says that there was a stall issue
with memoryless nodes that could be triggered without SLQB. Sachin, is
that still accurate?

If so, it's possible that SLQB somehow exasperates the problem in some
unknown fashion.

> There does not seem to be an easy way to deal with this. Some
> thought needs to go into how memoryless node handling relates to per cpu
> lists and locking. List handling issues need to be addressed before SLQB.
> can work reliably. The same issues can surface on x86 platforms with weird
> NUMA memory setups.
> 

Can you spot if there is something fundamentally wrong with patch 2? I.e. what
is wrong with treating the closest node as local instead of only the
closest node?

> Or just allow SLQB for !NUMA configurations and merge it now.
> 

Forcing SLQB !NUMA will not rattle out any existing list issues
unfortunately :(.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
