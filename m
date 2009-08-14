Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZHNWik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZHNWik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZHNWij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:38:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZHNWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:38:39 -0400
Message-ID: <4A85E722.8030706@redhat.com>
Date: Fri, 14 Aug 2009 18:37:22 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com> <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org> <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org> <20090814095106.GA3345@localhost> <9EECC02A4CC333418C00A85D21E89326B6611AC5@azsmsx502.amr.corp.intel.com>
In-Reply-To: <9EECC02A4CC333418C00A85D21E89326B6611AC5@azsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dike, Jeffrey G wrote:
> A side note - I've been doing some tracing and shrink_active_list is called a humongous number of times (25000-ish during a ~90 kvm run), with a net result of zero pages moved nearly all the time.  Your test is rescuing essentially all candidate pages from the inactive list.  Right now, I have the VM_EXEC || PageAnon version of your test.

That is exactly why the the split LRU VM does an unconditional
deactivation of active anon pages :)

-- 
All rights reversed.
