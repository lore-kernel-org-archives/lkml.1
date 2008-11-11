Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbYKKVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbYKKVsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYKKVr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:47:59 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38082 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKKVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:47:58 -0500
Date: Tue, 11 Nov 2008 15:47:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Avi Kivity <avi@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
In-Reply-To: <4919FB95.4060105@redhat.com>
Message-ID: <Pine.LNX.4.64.0811111544350.28346@quilx.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
 <1226409701-14831-2-git-send-email-ieidus@redhat.com>
 <1226409701-14831-3-git-send-email-ieidus@redhat.com>
 <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random>
 <Pine.LNX.4.64.0811111522150.27767@quilx.com> <4919FB95.4060105@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Avi Kivity wrote:

> Christoph Lameter wrote:
> > page migration requires the page to be on the LRU. That could be changed
> > if you have a different means of isolating a page from its page tables.
> >
>
> Isn't rmap the means of isolating a page from its page tables?  I guess I'm
> misunderstanding something.

In order to migrate a page one first has to make sure that userspace and
the kernel cannot access the page in any way. User space must be made to
generate page faults and all kernel references must be accounted for and
not be in use.

The user space portion involves changing the page tables so that faults
are generated.

The kernel portion isolates the page from the LRU (to exempt it from
kernel reclaim handling etc).

Only then can the page and its metadata be copied to a new location.

Guess you already have the LRU portion done. So you just need the user
space isolation portion?

