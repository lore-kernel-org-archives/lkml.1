Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXDWNmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXDWNmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXDWNmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:42:47 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:9055 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXDWNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:42:46 -0400
X-AuditID: d80ac21c-adec9bb000003cc8-b7-462cb7d50262 
Date: Mon, 23 Apr 2007 14:42:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
In-Reply-To: <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
Message-ID: <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
 <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
 <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 23 Apr 2007 13:42:28.0008 (UTC) FILETIME=[3BA87280:01C785AD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Hisashi Hifumi wrote:
> >No.  The PG_lru flag bit is just one bit amongst many others:
> >what of concurrent operations changing other bits in that same
> >unsigned long e.g. trying to lock the page by setting PG_locked?
> >There are some places where such micro-optimizations can be made
> >(typically while first allocating the page); but in general, no.
> 
> In i386 and x86_64, btsl is used to change page flag. In this case, if btsl
> without lock prefix
> set PG_locked and PG_lru flag concurrently, does only one operation
> succeed ?

That's right: on an SMP machine, without the lock prefix, the operation
is no longer atomic: what's stored back may be missing the result of
one or the other of the racing operations.

Hugh
