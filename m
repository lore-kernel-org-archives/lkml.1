Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZBEVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZBEVVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZBEVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:21:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZBEVVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:21:38 -0500
Date: Thu, 5 Feb 2009 22:20:58 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Robin Holt <holt@sgi.com>
Cc: linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
	retain extra mm_count.
Message-ID: <20090205212058.GK14011@random.random>
References: <20090205172303.GB8559@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205172303.GB8559@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:23:03AM -0600, Robin Holt wrote:
> 
> An application relying upon mmu_notifier_release for teardown of the
> mmu_notifiers will leak mm_structs.  At the do_mmu_notifier_register
> increments mm_count, but __mmu_notifier_release() does not decrement it.

Sure agreed, thanks! This got unnoticed this long because KVM uses the
unregister method instead of the self-disarming ->release and I guess
your systems have quite some ram so it'd take a while for the memleak
to trigger.
