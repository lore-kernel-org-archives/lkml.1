Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbXA3V6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbXA3V6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXA3V6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:58:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXA3V6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:58:23 -0500
Date: Tue, 30 Jan 2007 13:58:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Message-ID: <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Zach Brown wrote:
>
> This very rough patch series introduces a different way to provide AIO support
> for system calls.

Yee-haa!

I looked at this approach a long time ago, and basically gave up because 
it looked like too much work.

I heartily approve, although I only gave the actual patches a very cursory 
glance. I think the approach is the proper one, but the devil is in the 
details. It might be that the stack allocation overhead or some other 
subtle fundamental problem ends up making this impractical in the end, but 
I would _really_ like for this to basically go in.

One of the biggest issues I see is signalling. Your mention it, and I 
think that's going to be one of the big issues.

It won't matter at all for a certain class of calls (a lot of the people 
who want to do AIO really end up doing non-interruptible things, and 
signalling is a non-issue), but not only is it going to matter for some 
others, we will almost certainly want to have a way to not just signal a 
task, but a single "fibril" (and let me say that I'm not convinced about 
your naming, but I don't hate it either ;)

But from a quick overview of the patches, I really don't see anything 
fundamentally wrong. It needs some error checking and some limiting (I 
_really_ don't think we want a regular user starting a thousand fibrils 
concurrently), but it actually looks much less invasive than I thought it 
would be.

So yay! Consider me at least preliminarily very happy.

		Linus
