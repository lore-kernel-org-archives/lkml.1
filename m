Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYFCABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYFCABU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYFCABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:01:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbYFCABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:01:11 -0400
Date: Mon, 2 Jun 2008 17:00:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, greg@kroah.com,
       jeff@garzik.org, davej@redhat.com
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
Message-Id: <20080602170031.d5c03225.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806030000110.9919@blonde.site>
References: <48402DAA.60202@linux.intel.com>
	<Pine.LNX.4.64.0805302017580.16427@blonde.site>
	<Pine.LNX.4.64.0806030000110.9919@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 00:44:38 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> +					if (in_atomic())
> +						kunmap_atomic(kaddr, KM_USER0);
> +					else
> +						kunmap(kmapped_page);

eek.

/*
 * Are we running in atomic context?  WARNING: this macro cannot
 * always detect atomic context; in particular, it cannot know about
 * held spinlocks in non-preemptible kernels.  Thus it should not be
 * used in the general case to determine whether sleeping is possible.
 * Do not use in_atomic() in driver code.
 */
#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)

