Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZHYSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZHYSOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZHYSOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbZHYSOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:14:35 -0400
Date: Tue, 25 Aug 2009 20:10:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
Message-ID: <20090825181019.GT14722@random.random>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
 <20090825145832.GP14722@random.random>
 <20090825152217.GQ14722@random.random>
 <Pine.LNX.4.64.0908251836050.30372@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908251836050.30372@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 06:49:09PM +0100, Hugh Dickins wrote:
> Sorry, I just don't get it.  How does down_read here help?
> Perhaps you thought ksm.c had down_write of mmap_sem in all cases?
> 
> No, and I don't think we want to change its down_reads to down_writes.

Looking ksm.c it should have been down_write indeed...

> Nor do we want to change your down_read here to down_write, that will
> just reintroduce the OOM deadlock that 9/12 was about solving.

I'm not sure anymore I get what this fix is about... mm_users is
allowed to go to 0. If mm_users is allowed to go to 0, it's up to ksm
to check inside its inner loops that mm_users is 0 and bail
out. Bailing out it will unblock exit so that exit_mmap can run. What
exactly is the unfixable issue?
