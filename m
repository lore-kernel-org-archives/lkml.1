Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYDHVNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYDHVNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYDHVNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:13:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36679 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYDHVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:13:32 -0400
Message-ID: <47FBDF9E.90102@cs.helsinki.fi>
Date: Wed, 09 Apr 2008 00:11:58 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org> <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi> <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org> <Pine.LNX.4.64.0804082340120.11104@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0804081344280.30874@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0804081344280.30874@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Hmmmm... Peter has the most experience with these issues. Maybe the best 
> would be to have this sort of logic in a more general way in the page 
> allocator? Similar issues surely exist with the page allocator and a fix 
> there would fix it for all users.

This needs some support in the slab allocator anyway. Keep in mind that 
the patch is specifically addressing writeback in OOM conditions so we 
must (1) prioritize GFP_TEMPORARY allocations over everyone else (which 
just get NULL) and (2) use the remaining available memory as efficiently 
as possible for _all_ GFP_TEMPORARY allocations.

Peter is, however, bringing up a good point that my patch doesn't 
actually _guarantee_ anything so I'm still wondering if this approach 
makes any sense... But I sure do like Linus' ideas of marking 
short-lived allocations and trying harder for them in OOM.

			Pekka
