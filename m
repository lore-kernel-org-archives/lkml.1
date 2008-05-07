Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbYEGPB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbYEGPB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbYEGPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:01:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757686AbYEGPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:01:09 -0400
Date: Wed, 7 May 2008 08:00:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507153538.446693af@core>
Message-ID: <alpine.LFD.1.10.0805070757170.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507153538.446693af@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Alan Cox wrote:
>
> > But my preferred option would indeed be just turning it back into a 
> > spinlock - and screw latency and BKL preemption - and having the RT people 
> > who care deeply just work on removing the BKL in the long run.
> 
> It isn't as if the RT build can't use a different lock type to the
> default build.

Well, considering just *how* bad the new BKL apparently is, I think that's 
a separate issue. The semaphore implementation is simply not worth it. At 
a minimum, it should be a mutex.

> > Is BKL preemption worth it? Sounds very dubious. Sounds even more dubious 
> > when we now apparently have even more reason to aim for removing the BKL 
> > rather than trying to mess around with it.
> 
> We have some horrible long lasting BKL users left unfortunately.

Quite frankly, maybe we _need_ to have a bad BKL for those to ever get 
fixed. As it was, people worked on trying to make the BKL behave better, 
and it was a failure. Rather than spend the effort on trying to make it 
work better (at a horrible cost), why not just say "Hell no - if you have 
issues with it, you need to work with people to get rid of the BKL 
rather than cluge around it".

			Linus
