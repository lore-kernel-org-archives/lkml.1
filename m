Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXJQSXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXJQSXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXJQSXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:23:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346AbXJQSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:23:21 -0400
Date: Wed, 17 Oct 2007 11:22:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710171119250.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org>
 <20071017180042.GP15552@kernel.dk>
 <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Linus Torvalds wrote:
> 
> So I think your change to use "sg_next()" only when you actually need a 
> next pointer is the correct one after all.

That still leaves the initialization issue. The link pointers need to all 
be initialized at SG allocation time (and not just the last one for the 
case where it's a linked entry).

And if you initialize them at allocation time, does an allocation ever get 
re-used without being free'd in between (if it does, you do indeed need to 
initialize the non-link pointers each time - but I don't see it being the 
case, so ..)

		Linus
