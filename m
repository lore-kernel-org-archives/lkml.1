Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZDRO7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZDRO7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZDRO7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:59:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46386 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZDRO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:59:36 -0400
Date: Sat, 18 Apr 2009 16:58:06 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090418145806.GA15228@random.random>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <1239249521-5013-2-git-send-email-ieidus@redhat.com> <1239249521-5013-3-git-send-email-ieidus@redhat.com> <1239249521-5013-4-git-send-email-ieidus@redhat.com> <1239249521-5013-5-git-send-email-ieidus@redhat.com> <20090414150929.174a9b25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414150929.174a9b25.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:09:29PM -0700, Andrew Morton wrote:
> We need a comment here explaining why we can't use the much preferable
> lock_page().
> 
> Why can't we use the much preferable lock_page()?

We might but then it'd risk to waste time waiting. It's not worth
waiting, we want kksmd to be allowed to keep one (in future more than
one as we scale it smp/numa) CPU busy at all times running memcmp and
not schedule (other than for need_resched()) to try to free memory at
the fastest peace possible.
