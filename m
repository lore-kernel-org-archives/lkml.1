Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZFOIPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZFOIPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFOIO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:14:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:54075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZFOIO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:14:56 -0400
Date: Mon, 15 Jun 2009 10:14:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615081453.GC8665@wotan.suse.de>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <20090615064447.GA18390@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615064447.GA18390@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:44:47AM +0200, Nick Piggin wrote:
> Did we verify with filesystem maintainers (eg. btrfs) that the
> !ISREG test will be enough to prevent oopses?

BTW. this is quite a significant change I think and not
really documented well enough. Previously a filesystem
will know exactly when and why pagecache in a mapping
under its control will be truncated (as opposed to
invalidated).

They even have opportunity to hold locks such as i_mutex.

And depending on what they do, they could do interesting
things even with ISREG files.

So, I really think this needs review by filesystem
maintainers and it would be far safer to use invalidate
until it is known to be safe.

