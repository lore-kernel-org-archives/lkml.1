Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbYKKVjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbYKKVjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYKKViy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:38:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34044 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYKKVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:38:53 -0500
Message-ID: <4919FB31.7090506@redhat.com>
Date: Tue, 11 Nov 2008 23:37:53 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <4919F1C0.2050009@redhat.com> <Pine.LNX.4.64.0811111520590.27767@quilx.com> <4919F7EE.3070501@redhat.com> <Pine.LNX.4.64.0811111527500.27767@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811111527500.27767@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>
>
> Currently page migration assumes that the page will continue to be part
> of the existing file or anon vma.
>   

exactly, and ksm really need it to get out of the existing anon vma!

> What you want sounds like assigning a swap pte to an anonymous page? That
> way a anon page gains membership in a file backed mapping.
>
>
>   

No, i want pte that is found inside vma and point to anonymous page, 
will stop point into the anonymous page
and will point to a whole diffrent page that i chose (for ksm it is 
needed because this way we are mapping alot
of ptes into the same write_protected page and save memory)

