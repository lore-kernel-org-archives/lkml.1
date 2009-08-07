Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZHGDRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZHGDRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZHGDRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:17:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43241 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZHGDRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:17:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <4A7AD5DF.7090801@redhat.com>
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com>
Message-Id: <20090807121443.5BE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  7 Aug 2009 12:17:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrea Arcangeli wrote:
> 
> > Likely we need a cut-off point, if we detect it takes more than X
> > seconds to scan the whole active list, we start ignoring young bits,
> 
> We could just make this depend on the calculated inactive_ratio,
> which depends on the size of the list.
> 
> For small systems, it may make sense to make every accessed bit
> count, because the working set will often approach the size of
> memory.
> 
> On very large systems, the working set may also approach the
> size of memory, but the inactive list only contains a small
> percentage of the pages, so there is enough space for everything.
> 
> Say, if the inactive_ratio is 3 or less, make the accessed bit
> on the active lists count.

Sound reasonable. How do we confirm the idea correctness?
Wu, your X focus switching benchmark is sufficient test?



