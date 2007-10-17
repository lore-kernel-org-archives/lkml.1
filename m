Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXJQSO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXJQSO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXJQSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:14:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbXJQSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:14:45 -0400
Date: Wed, 17 Oct 2007 11:13:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
In-Reply-To: <20071017180218.GQ15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171111040.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
 <20071017180218.GQ15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> >
> >  - remove the "memset()" you had added earlier. It's bogus. It cannot be 
> >    the right thing. If the sg list wasn't initialized correctly much 
> >    earlier, trying to initialize it late is pointless - it contains crap.
> 
> It's required to clear output members (like dma_len and so on), since
> some of the IOMU code really wants that initialized.

No it's NOT!

The whole point here is that the sg had *already* better be cleared.

If it wasn't cleared before, that's a bug regardless of anything else. So 
a memset() is guaranteed to be either a no-op or hiding another bug!

So yes, those members had better be zero. It's just that they had better 
be zero long before that memset! The memset should have been done when 
allocating the SG list.

> If you prefer the old next_sg approach to my alternative, that is fine
> with me. But we do need the memset().

Really? Explain why. Entering that code with a non-initialized SG list is 
a bug to begin with.

		Linus
