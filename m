Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXKCDl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXKCDl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbXKCDlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 23:41:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:44994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772AbXKCDlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 23:41:50 -0400
Date: Sat, 3 Nov 2007 04:41:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071103034146.GA9699@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <472B4ECE.7010602@redhat.com> <alpine.LFD.0.999.0711020950250.3342@woody.linux-foundation.org> <20071102230142.GC26562@wotan.suse.de> <472BC74E.9090505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472BC74E.9090505@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 08:56:46PM -0400, Chuck Ebbert wrote:
> On 11/02/2007 07:01 PM, Nick Piggin wrote:
> > 
> > In the contended multi-threaded tight loop, the xchg lock is slower than inc
> > lock but still beats the fair xadd lock, but that's only because it is
> > just as unfair if not more so on this hardware (runtime difference of up to
> > about 10%)
> > 
> 
> I meant xchg for unlock, not lock.

That is for unlock. 2x the number of atomic operations ~= 2x the cost.

