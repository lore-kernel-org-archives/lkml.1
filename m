Return-Path: <linux-kernel-owner+w=401wt.eu-S1946144AbXBBWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946144AbXBBWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946146AbXBBWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:49:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946144AbXBBWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:49:33 -0500
Date: Fri, 2 Feb 2007 14:49:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202222110.GA1212@elte.hu>
Message-ID: <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Ingo Molnar wrote:
> 
> Note: such a 'flip' would only occur when the original context blocks, 
> /not/ on every async syscall.

Right.

So can you take a look at Zach's fibril idea again? Because that's exactly 
what it does. It basically sets a flag, saying "flip to this when you 
block or yield". Of course, it's a bit bigger than just a flag, since it 
needs to describe what to flip to, but that's the basic idea.

Now, if you want to make fibrils *also* then actually use a separate 
thread, that's an extension. But you were arguing as if they should use 
threads to begin with, and that sounds stupid. Now you seem to retract it, 
since you say "only if you need to block".

THAT'S THE POINT. That's what makes fibrils cooperative. The "only if you 
block" is really what makes a fibril be something else than a regular 
thread. 

		Linus
