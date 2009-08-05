Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZHEPQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZHEPQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZHEPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:16:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZHEPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:16:09 -0400
Message-ID: <4A79A1FB.6010406@redhat.com>
Date: Wed, 05 Aug 2009 11:15:07 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com> <4A7993F4.9020008@redhat.com> <4A79A16A.1050401@redhat.com>
In-Reply-To: <4A79A16A.1050401@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

>> If so, we could unmap them when they get moved from the
>> active to the inactive list, and soft fault them back in
>> on access, emulating the referenced bit for EPT pages and
>> making page replacement on them work like it should.
> 
> It should be easy to implement via the mmu notifier callback: when the 
> mm calls clear_flush_young(), mark it as young, and unmap it from the 
> EPT pagetable.

You mean "mark it as old"?

>> Your approximation of pretending the page is accessed the
>> first time and pretending it's not the second time sounds
>> like it will just lead to less efficient FIFO replacement,
>> not to anything even vaguely approximating LRU.
> 
> Right, it's just a hack that gives EPT pages higher priority, like the 
> original patch suggested.  Note that LRU for VMs is not a good 
> algorithm, since the VM will also reference the least recently used 
> page, leading to thrashing.

That is one of the reasons we use a very coarse two
handed clock algorithm instead of true LRU.

LRU has more overhead and more artifacts :)

-- 
All rights reversed.
