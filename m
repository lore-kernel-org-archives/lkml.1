Return-Path: <linux-kernel-owner+w=401wt.eu-S1161379AbXDWLRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161379AbXDWLRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161427AbXDWLRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:17:19 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:4071 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161425AbXDWLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:17:18 -0400
X-AuditID: d80ac287-a5e9bbb000005f82-0b-462c95bd1a4d 
Date: Mon, 23 Apr 2007 12:16:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
In-Reply-To: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
Message-ID: <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 23 Apr 2007 11:16:38.0842 (UTC) FILETIME=[DCBFA9A0:01C78598]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Hisashi Hifumi wrote:
> 
> PageLRU flag operation is protected by zone->lru_lock, so
> SetPageLRU/ClearPageLRU
> can be replaced to __SetPageLRU/__ClearPageLRU non-atomic bit operation.

No.  The PG_lru flag bit is just one bit amongst many others:
what of concurrent operations changing other bits in that same
unsigned long e.g. trying to lock the page by setting PG_locked?
There are some places where such micro-optimizations can be made
(typically while first allocating the page); but in general, no.

Hugh
