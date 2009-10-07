Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbZJGUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbZJGUxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZJGUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:53:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbZJGUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:53:07 -0400
Date: Wed, 7 Oct 2009 13:51:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <87eipfymcv.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Andi Kleen wrote:
> 
> With some strategic prefetches it might be cheap enough to use 
> two cache lines. Just fetch it with the other.

I _seriously_ doubt that.

This is one of the biggest (and hottest) hash tables in the whole kernel.

No amount of prefetching will help the fact that you effectively double 
your cache footprint / working set if you have to fetch two cachelines in 
the hot case lookup rather than one.

			Linus
