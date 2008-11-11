Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKKVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKKVb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYKKVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:31:50 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:52267 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYKKVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:31:50 -0500
Date: Tue, 11 Nov 2008 15:31:18 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Izik Eidus <ieidus@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
In-Reply-To: <4919F7EE.3070501@redhat.com>
Message-ID: <Pine.LNX.4.64.0811111527500.27767@quilx.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
 <1226409701-14831-2-git-send-email-ieidus@redhat.com>
 <1226409701-14831-3-git-send-email-ieidus@redhat.com>
 <20081111114555.eb808843.akpm@linux-foundation.org> <4919F1C0.2050009@redhat.com>
 <Pine.LNX.4.64.0811111520590.27767@quilx.com> <4919F7EE.3070501@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Izik Eidus wrote:

> > What do you mean by kernel page? The kernel can allocate a page and then
> > point a user space pte to it. That is how page migration works.
> >
> i mean filebacked page (!AnonPage())

ok.

> ksm need the pte inside the vma to point from anonymous page into filebacked
> page
> can migrate.c do it without changes?

So change anonymous to filebacked page?

Currently page migration assumes that the page will continue to be part
of the existing file or anon vma.

What you want sounds like assigning a swap pte to an anonymous page? That
way a anon page gains membership in a file backed mapping.


