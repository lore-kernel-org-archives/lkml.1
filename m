Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXK2Jjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXK2Jjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXK2Jjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:39:42 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32895 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXK2Jjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:39:41 -0500
Date: Thu, 29 Nov 2007 11:39:37 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
In-Reply-To: <19f34abd0711290110n501ddb43wf3ab69b526acef95@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711291127470.26543@sbz-30.cs.Helsinki.FI>
References: <474C34CC.6060509@gmail.com>  <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
 <19f34abd0711290110n501ddb43wf3ab69b526acef95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Nov 29, 2007 9:02 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Is it really necessary to track every memory address? Tracking slab
> > objects would require far less memory. You might also want to make
> > kzalloc() and GFP_ZERO mark the memory area as initialized to avoid
> > some page faults.

On Thu, 29 Nov 2007, Vegard Nossum wrote:
> Yes, we are in fact only tracking the memory within SLUB allocations
> (minus what SLUB itself needs for bookkeeping -- like the caches).

Yeah but you didn't answer my question: why do we track every memory 
address instead of slab objects? What's the benefit? Like I already said, 
tracking slab objects would require much less memory which makes the 
thing more practical. It also reduces the number of false positives (the 
CONFIG_OPTIMIZE_FOR_SIZE problem). And we already have slab poisoning to 
cover the cases we would not catch with this scheme.

On Thu, 29 Nov 2007, Vegard Nossum wrote:
> As for the kzalloc() and GFP_ZERO, I believe these will write zeros to
> the data in question before the memory is returned to the caller. In
> that case, the area will be "automatically" set to initialized since
> these writes are also intercepted by kmemcheck.

Yes, and what I proposed is as a potential optimization. Debugging aids 
need to be fast enough to be practical.

			Pekka
