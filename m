Return-Path: <linux-kernel-owner+w=401wt.eu-S964851AbYDWBXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbYDWBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYDWBXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:23:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbYDWBXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:23:00 -0400
Date: Tue, 22 Apr 2008 18:22:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
In-Reply-To: <20080423011153.GB17572@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0804221817050.2779@woody.linux-foundation.org>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu> <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org>
 <20080422192601.GB12588@elte.hu> <alpine.LFD.1.10.0804221244350.2779@woody.linux-foundation.org> <20080423011153.GB17572@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Nick Piggin wrote:
> 
> The "too expensive to check the shared queue" is one aspect of it. The
> shared queue need not have events *for us* (at least, unless Jens has
> changed the implementation a bit) but it can still have events that we
> would need to check through.
> 
> I don't think deadlock is a problem (any more than with multiple vectors).

I'm happy with it either way, but as pointed out by Ralf, for the MIPS 
version of the patch there aren't even other vectors available.

So sharing the vector is going to be a requirement on other architectures, 
maybe we should look at whether we can make it generic and peform well 
regardless?

			Linus
