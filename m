Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZHZU3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZHZU3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZHZU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZHZU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:29:19 -0400
Date: Wed, 26 Aug 2009 22:28:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
Message-ID: <20090826202843.GC14722@random.random>
References: <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
 <20090825145832.GP14722@random.random>
 <20090825152217.GQ14722@random.random>
 <Pine.LNX.4.64.0908251836050.30372@sister.anvils>
 <20090825181019.GT14722@random.random>
 <Pine.LNX.4.64.0908251958170.5871@sister.anvils>
 <20090825194530.GU14722@random.random>
 <Pine.LNX.4.64.0908261910530.15622@sister.anvils>
 <20090826194444.GB14722@random.random>
 <Pine.LNX.4.64.0908262048270.21188@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908262048270.21188@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 08:57:27PM +0100, Hugh Dickins wrote:
> that might be useful.  But KSM_RUN_UNMERGE wouldn't be able to use_mm
> since it's coming from a normal user process - perhaps it should be a
> kill-me-first like swapoff via PF_SWAPOFF.

That would sound just perfect if only there wasn't also a break_cow in
the kksmd context that will trigger page allocation as it can't
takeover the KSM page like it would normally be guaranteed to do for a
cow on a regular anon page mapped readonly in the pte after read
swapin for example. Still for the echo 2 kill me first definitely
makes sense, so maybe we should differentiate the two cases (kksmd and
sysfs).
