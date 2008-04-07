Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYDGWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYDGWS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYDGWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:18:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746AbYDGWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:18:51 -0400
Date: Mon, 7 Apr 2008 15:17:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
Message-ID: <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site>
 <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org> <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi>
 <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Apr 2008, Pekka J Enberg wrote:
> 
> So something like the following (totally untested) patch modulo the 
> pre-allocation bits.

Hmm. I didn't check, but won't this cause problems on the freeing path 
when we call kmem_cache_free() on the result but with the wrong "struct 
kmem_cache" pointer?

		Linus
