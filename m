Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbZFOQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbZFOQK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbZFOQKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:10:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148AbZFOQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:10:49 -0400
Date: Mon, 15 Jun 2009 18:19:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615161904.GH31969@one.firstfloor.org>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org> <20090615154832.73c89733@lxorguk.ukuu.org.uk> <20090615152427.GF31969@one.firstfloor.org> <20090615162804.4cb75b30@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615162804.4cb75b30@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 04:28:04PM +0100, Alan "zSeries" Cox wrote:

> 	curse a lot
> 	suspend to disk
> 	remove dirt from fans, clean/replace RAM
> 	resume from disk
> 
> The very act of making the ECC error not take out the box creates the

Ok so at least you agree now that handling these errors without 
panic is the right thing to do. That's at least some progress.

> environment whereby the underlying hardware error (if there was one) can
> be cured.

These ECC errors are still somewhat rare (or rather if they become
common you should definitely service the system). That is why
losing a single page of memory for them isn't a big issue normally.

Sure you could spend effort making unpoisioning work,
but it would seem very dubious to me. After all it's just another
4K of memory for each error. 

The only reasonably good use case I heard for unpoisoning was
if you have a lot of huge pages (you can't use a full huge page with one bad 
small page), but that's also still relatively exotic.

-Andi

[1] mostly you need a new special form of RCU I think

-- 
ak@linux.intel.com -- Speaking for myself only.
