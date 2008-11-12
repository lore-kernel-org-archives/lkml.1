Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYKLDL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYKLDL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYKLDLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:11:17 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:35351 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYKLDLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:11:16 -0500
Date: Tue, 11 Nov 2008 21:10:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
In-Reply-To: <20081112022701.GT10818@random.random>
Message-ID: <Pine.LNX.4.64.0811112109390.10501@quilx.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
 <1226409701-14831-2-git-send-email-ieidus@redhat.com>
 <1226409701-14831-3-git-send-email-ieidus@redhat.com>
 <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random>
 <Pine.LNX.4.64.0811111522150.27767@quilx.com> <20081111221753.GK10818@random.random>
 <Pine.LNX.4.64.0811111626520.29222@quilx.com> <20081111231722.GR10818@random.random>
 <Pine.LNX.4.64.0811111823030.31625@quilx.com> <20081112022701.GT10818@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Andrea Arcangeli wrote:

> So are you checking if there's an unresolved reference only in the
> very place I just quoted in the previous email? If answer is yes: what
> should prevent get_user_pages from running in parallel from another
> thread? get_user_pages will trigger a minor fault and get the elevated
> reference just after you read page_count. To you it looks like there
> is no o_direct in progress when you proceed to the core of migration
> code, but in effect o_direct just started a moment after you read the
> page count.

get_user_pages() cannot get to it since the pagetables have already been
modified. If get_user_pages runs then the fault handling will occur
which will block the thread until migration is complete.
