Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZHGDLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZHGDLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbZHGDLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:11:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42964 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbZHGDLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:11:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Cc: kosaki.motohiro@jp.fujitsu.com, Avi Kivity <avi@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <4A7AD6EB.9090208@redhat.com>
References: <4A7AC201.4010202@redhat.com> <4A7AD6EB.9090208@redhat.com>
Message-Id: <20090807120857.5BE2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  7 Aug 2009 12:11:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to memcg folks)

> Avi Kivity wrote:
> > On 08/06/2009 01:59 PM, Wu Fengguang wrote:
> 
> >> As a refinement, the static variable 'recent_all_referenced' could be
> >> moved to struct zone or made a per-cpu variable.
> > 
> > Definitely this should be made part of the zone structure, consider the 
> > original report where the problem occurs in a 128MB zone (where we can 
> > expect many pages to have their referenced bit set).
> 
> The problem did not occur in a 128MB zone, but in a 128MB cgroup.
> 
> Putting it in the zone means that the cgroup, which may have
> different behaviour from the rest of the zone, due to excessive
> memory pressure inside the cgroup, does not get the right
> statistics.

maybe, I heven't catch your point.

Current memcgroup logic also use recent_scan/recent_rotate statistics.
Isn't it enought?




