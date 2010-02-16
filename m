Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0BPIlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:41:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46263 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0BPIlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:41:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 03/12] Export unusable free space index via /proc/pagetypeinfo
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20100216083612.GA26086@csn.ul.ie>
References: <20100216152106.72FA.A69D9226@jp.fujitsu.com> <20100216083612.GA26086@csn.ul.ie>
Message-Id: <20100216173832.730F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 17:41:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 16, 2010 at 04:03:29PM +0900, KOSAKI Motohiro wrote:
> > > Unusuable free space index is a measure of external fragmentation that
> > > takes the allocation size into account. For the most part, the huge page
> > > size will be the size of interest but not necessarily so it is exported
> > > on a per-order and per-zone basis via /proc/pagetypeinfo.
> > 
> > Hmmm..
> > /proc/pagetype have a machine unfriendly format. perhaps, some user have own ugly
> > /proc/pagetype parser. It have a little risk to break userland ABI.
> > 
> 
> It's very low risk. I doubt there are machine parsers of
> /proc/pagetypeinfo because there are very few machine-orientated actions
> that can be taken based on the information. It's more informational for
> a user if they were investigating fragmentation problems.
> 
> > I have dumb question. Why can't we use another file?
> 
> I could. What do you suggest?

I agree it's low risk. but personally I hope fragmentation ABI keep very stable because
I expect some person makes userland compaction daemon. (read fragmentation index
from /proc and write /proc/compact_memory if necessary).
then, if possible, I hope fragmentation info have individual /proc file.



