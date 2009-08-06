Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZHFVcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZHFVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZHFVcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:32:15 -0400
Received: from [198.99.130.12] ([198.99.130.12]:47769 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZHFVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:32:14 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 17:32:11 EDT
Date: Thu, 6 Aug 2009 17:09:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Rik van Riel <riel@redhat.com>, "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090806210955.GA14201@c2.user-mode-linux.org>
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806130631.GB6162@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Side question -
	Is there a good reason for this to be in shrink_active_list()
as opposed to __isolate_lru_page?

		if (unlikely(!page_evictable(page, NULL))) {
			putback_lru_page(page);
			continue;
		}

Maybe we want to minimize the amount of code under the lru lock or
avoid duplicate logic in the isolate_page functions.

But if there are important mlock-heavy workloads, this could make the
scan come up empty, or at least emptier than we might like.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
