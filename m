Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYHSEHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYHSEHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYHSEHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:07:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbYHSEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:06:59 -0400
Date: Mon, 18 Aug 2008 21:06:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATH -mm] Fix a race condtion of oops_in_progress
Message-Id: <20080818210657.c7f3cd87.akpm@linux-foundation.org>
In-Reply-To: <1219025007.5663.22.camel@yhuang-dev.sh.intel.com>
References: <1219025007.5663.22.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 10:03:27 +0800 Huang Ying <ying.huang@intel.com> wrote:

> This patch fix a race condition of oops_in_progress. Which may be
> changed on multiple CPU simultaneously, but it is changed via
> non-atomic operation ++/--. This patch changes the definition of
> oops_in_process from int to atomic_t, and accessing method to atomic
> operations.


> extern atomic_t oops_in_progress;

In file included from include/asm/system.h:10,
                 from include/asm/processor.h:17,
                 from include/asm/atomic_32.h:5,
                 from include/asm/atomic.h:2,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets_32.c:7,
                 from arch/x86/kernel/asm-offsets.c:2:
include/linux/kernel.h:236: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'oops_in_progress'
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

we can't inlude asm/atomic.h from linux/kernel.h because asm/atomic.h
includes linux/kernel.h via the above route.

And we cannot forward-declare atomic_t by hand because it's a typedef.

Not sure what to do, really.  Find a different header file in which to
declare oops_in_progress?

