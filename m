Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179Ab0AYTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0AYTB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AYTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:01:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab0AYTBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:01:25 -0500
Date: Mon, 25 Jan 2010 20:00:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix unmap_vma() bug related to mmu_notifiers
Message-ID: <20100125190052.GF5756@random.random>
References: <20100125174556.GA23003@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125174556.GA23003@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:45:56AM -0600, Jack Steiner wrote:
> unmap_vmas() can fail to correctly flush the TLB if a
> callout to mmu_notifier_invalidate_range_start() sleeps.

Not sure I understand: the callbacks invoked by
mmu_notifier_invalidate_range_start can't sleep, or rcu locking inside
mmu notifier will break too (first thing that should be replaced with
srcu if they were allowed to sleep).

In short there's no schedule that could be added because of those
callbacks so if this code isn't ok and schedules and screw on the
mmu_gather tlb it's probably not mmu notifier related.
