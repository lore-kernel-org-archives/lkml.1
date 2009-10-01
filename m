Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZJAKys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZJAKys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZJAKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:54:47 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:4033 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276AbZJAKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:54:46 -0400
X-Trace: 265406197/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.44.42/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.44.42
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEACYnxEpQKSwq/2dsb2JhbACBUdR/hCgE
X-IronPort-AV: E=Sophos;i="4.44,487,1249254000"; 
   d="scan'208";a="265406197"
Date: Thu, 1 Oct 2009 11:54:34 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
In-Reply-To: <alpine.DEB.1.10.0909291019100.15549@gentwo.org>
Message-ID: <Pine.LNX.4.64.0910011134240.10818@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au> <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
 <4ABC80B0.5010100@crca.org.au> <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
 <4AC0234F.2080808@crca.org.au> <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
 <20090928033624.GA11191@localhost> <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0909281637160.25798@sister.anvils>
 <a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
 <Pine.LNX.4.64.0909282134100.11529@sister.anvils>
 <20090929105735.06eea1ee.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.10.0909291019100.15549@gentwo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Christoph Lameter wrote:
> 
> Another concern that has not been discussed is the increased cache
> footprint due to a slightly enlarged vm data working set (there is also a
> corresponding icache issue since additional accesses are needed).

Using unsigned long long vm_flags makes no difference to cache footprint
on 64-bit systems, being a no-op there; and I think these days, though
we sure like our 32-bit systems to run well, we're not so anxious about
saving every last cycle on them.

> 
> Could we stick with the current size and do combinations of flags like we
> do with page flags?

Are we doing that?  If you have some example like, when PG_slab is set
then PG_owner_priv_1 means such-and-such, but if not not: okay, I'm
fine with that.

But if you're saying something like, if PG_reclaim is set at the same
time as PG_buddy, then they mean the page is not a buddy or under
reclaim, but brokenbacked: then I'm a bit (or even 32 bits) worried.

> VM_HUGETLB cannot grow up and down f.e. and there are
> certainly lots of other impossible combinations that can be used to put
> more information into the flags.

Where it makes sense, where it's understandable, okay: there may be a
few which could naturally use combinations.  But in general, no, I
think we'd be asking for endless maintenance trouble if we change the
meaning of some flags according to other flags.

Hugh
