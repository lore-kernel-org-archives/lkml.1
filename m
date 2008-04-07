Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYDGWoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYDGWoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYDGWoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:44:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53240 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYDGWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:44:03 -0400
Message-ID: <47FAA354.6000704@cs.helsinki.fi>
Date: Tue, 08 Apr 2008 01:42:28 +0300
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
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org> <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi> <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Pekka J Enberg wrote:
>> So something like the following (totally untested) patch modulo the 
>> pre-allocation bits.

Linus Torvalds wrote:
> Hmm. I didn't check, but won't this cause problems on the freeing path 
> when we call kmem_cache_free() on the result but with the wrong "struct 
> kmem_cache" pointer?

Aah, yes. I was thinking of kmalloc() here for which it works as 
expected because kfree() will return the page to the proper cache. But 
we can relax the rules of kmem_cache_free() a bit to make this work (but 
perhaps add a WARN_ON() there if cache doesn't match page->slab).

			Pekka
