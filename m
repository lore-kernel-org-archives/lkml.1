Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZGUSAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZGUSAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGUSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:00:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZGUSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:00:05 -0400
Date: Tue, 21 Jul 2009 19:59:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, chrisw@redhat.com,
       avi@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] ksm resend
Message-ID: <20090721175909.GF2239@random.random>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 08:30:40PM +0300, Izik Eidus wrote:
> The code still need to get Andrea Arcangeli acks.
> (he was busy and will ack it later).

Ack it all except that detail in 6/10 as I'm unconvinced about ksm
pages having to return 1 on PageAnon check. I believe they deserve a
different bitflag in the mapping pointer. The smallest possible
alignment for mapping pointer is 4 on 32bit archs so there is space
for it and later it can be renamed EXTERNAL to generalize. We shall
make good use of that bitflag as it's quite precious to introduce
non-linearity in linear vmas, and not wire it to KSM only. But in
meantime we'll get better testing coverage by not having that PageKsm
== PageAnon invariant I think that I doubt we're going to retain (at
least with this implementation of PageKsm).
