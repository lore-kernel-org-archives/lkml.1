Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYDHUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYDHUqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYDHUp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:45:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42746 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718AbYDHUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:45:57 -0400
Date: Tue, 8 Apr 2008 13:45:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <Pine.LNX.4.64.0804082340120.11104@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0804081344280.30874@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy>
 <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi>
 <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org>
 <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi>
 <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
 <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804082340120.11104@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Pekka J Enberg wrote:

> So something like this fugly patch on top of the SLUB variable order 
> patches that let the allocator fall-back to smaller page orders. Survives 
> OOM in my testing and the box seems to be bit more responsive even under X 
> with this.

Hmmmm... Peter has the most experience with these issues. Maybe the best 
would be to have this sort of logic in a more general way in the page 
allocator? Similar issues surely exist with the page allocator and a fix 
there would fix it for all users.

