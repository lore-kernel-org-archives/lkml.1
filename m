Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYKKWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYKKWZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKKWY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:24:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYKKWYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:24:55 -0500
Date: Tue, 11 Nov 2008 23:24:21 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
	one page into another
Message-ID: <20081111222421.GL10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <4919F1C0.2050009@redhat.com> <Pine.LNX.4.64.0811111520590.27767@quilx.com> <4919F7EE.3070501@redhat.com> <Pine.LNX.4.64.0811111527500.27767@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811111527500.27767@quilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:31:18PM -0600, Christoph Lameter wrote:
> > ksm need the pte inside the vma to point from anonymous page into filebacked
> > page
> > can migrate.c do it without changes?
> 
> So change anonymous to filebacked page?
>
> Currently page migration assumes that the page will continue to be part
> of the existing file or anon vma.
> 
> What you want sounds like assigning a swap pte to an anonymous page? That
> way a anon page gains membership in a file backed mapping.

KSM needs to convert anonymous pages to PageKSM, which means a page
owned by ksm.c and only known by ksm.c. The Linux VM will free this
page in munmap but that's about it, all we do is to match the number
of anon-ptes pointing to the page with the page_count. So besides
freeing the page when the last user exit()s or cows it, the VM will do
nothing about it. Initially. Later it can swap it in a nonlinear way.
