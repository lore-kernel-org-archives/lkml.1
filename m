Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbZD3NIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbZD3NIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbZD3NIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:08:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51495 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762089AbZD3NIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:08:22 -0400
Message-ID: <49F9A2B6.6070801@redhat.com>
Date: Thu, 30 Apr 2009 09:08:06 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Elladan <elladan@eskimo.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
References: <20090428044426.GA5035@eskimo.com> <20090428192907.556f3a34@bree.surriel.com> <1240987349.4512.18.camel@laptop> <20090429114708.66114c03@cuia.bos.redhat.com> <20090430072057.GA4663@eskimo.com>
In-Reply-To: <20090430072057.GA4663@eskimo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elladan wrote:

>> Elladan, does this smaller patch still work as expected?

> The system does seem relatively responsive with this patch for the most part,
> with occasional lag.  I don't see much evidence at least over the course of a
> few minutes that it pages out applications significantly.  It seems about
> equivalent to the first patch.

OK, good to hear that.

> This seems ok (not disastrous, anyway).  I suspect desktop users would
> generally prefer the VM were extremely aggressive about keeping their
> executables paged in though, 

I agree that desktop users would probably prefer something even
more aggressive.  However, we do need to balance this against
other workloads, where inactive file pages need to be given a
fair chance to be referenced twice and promoted to the active
file list.

Because of that, I have chosen a patch with a minimal risk of
regressions on any workload.

-- 
All rights reversed.
