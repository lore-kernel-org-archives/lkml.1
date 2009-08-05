Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZHEPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZHEPcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbZHEPcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:32:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40766 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZHEPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:32:53 -0400
Message-ID: <4A79A743.6020209@redhat.com>
Date: Wed, 05 Aug 2009 18:37:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
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
       linux-mm <linux-mm@kvack.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com> <4A794008.6030204@redhat.com> <4A79984C.2010508@redhat.com>
In-Reply-To: <4A79984C.2010508@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 05:33 PM, Rik van Riel wrote:
> Avi Kivity wrote:
>
>> The attached patch implements this.
>
> The attached page requires each page to go around twice
> before it is evicted, but they will still get evicted in
> the order in which they were made present.
>
> FIFO page replacement was shown to be a bad idea in the
> 1960's and it is still a terrible idea today.
>

Which is why we have accessed bits in page tables... but emulating the 
accessed bit via RWX (note no present bit in EPT) is better than 
ignoring it.

-- 
error compiling committee.c: too many arguments to function

