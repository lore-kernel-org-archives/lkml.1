Return-Path: <linux-kernel-owner+w=401wt.eu-S934275AbZHEP7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbZHEP7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934012AbZHEP7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:59:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbZHEP7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:59:07 -0400
Date: Wed, 5 Aug 2009 17:58:05 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090805155805.GC23385@random.random>
References: <20090805024058.GA8886@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805024058.GA8886@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:40:58AM +0800, Wu Fengguang wrote:
>  			 */
> -			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> +			if ((vm_flags & VM_EXEC) || PageAnon(page)) {
>  				list_add(&page->lru, &l_active);
>  				continue;
>  			}
> 

Please nuke the whole check and do an unconditional list_add;
continue; there.
