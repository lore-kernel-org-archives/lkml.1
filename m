Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZJGT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZJGT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759882AbZJGT0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:26:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759875AbZJGT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:26:36 -0400
Date: Wed, 7 Oct 2009 12:25:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <20091007164622.GX30316@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Nick Piggin wrote:
> 
> Oh I did that, used a "seqcount" which is the bare sequence counter
> (and update it while holding d_lock).

Oh, I didn't notice, for a really silly reason: I looked at how you had 
changed DNAME_INLINE_LEN_MIN on 64-bit, and noticed that you were using 8 
bytes for your sequence lock.

But that's only true due to the padding things, and the seqcount itself is 
indeed just 4 bytes. 

Sad. But we do have the added requirement that we want to keep the 
commonly used fields together in the same cacheline, so maybe it's 
unavoidable.

		Linus
