Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYDGVlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYDGVlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYDGVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:41:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38160 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYDGVld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:41:33 -0400
Message-ID: <47FA94AE.4070803@cs.helsinki.fi>
Date: Tue, 08 Apr 2008 00:39:58 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org> <47FA937E.6000009@cs.helsinki.fi>
In-Reply-To: <47FA937E.6000009@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> I suspect the right thing to do is not to mark them for "IO", but mark 
>> them for "short-lived", and allow short-lived allocations that don't 
>> have extended lifetimes to succeed even when a "real" allocation 
>> wouldn't.

Pekka Enberg wrote:
> Yeah, makes sense. We do have GFP_TEMPORARY so we could associate this 
> new semantics with that. But the real problem here is how to do the 
> "allocate harder" part which, btw, sounds very similar to what Peter's 
> kmalloc reserve patches try to do...

Actually, a trivial way to implement that is to have a few "emergency 
kmalloc" caches say for sizes 64, 128, 256, and 512 that have some 
pre-allocated pages into which these GFP_TEMPORARY allocations are 
allowed to dip into on OOM and OOM only.

		Pekka
