Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXA3Wre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXA3Wre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXA3Wre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:47:34 -0500
Received: from agminet02.oracle.com ([141.146.126.229]:35753 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXA3Wrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:47:33 -0500
In-Reply-To: <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0E1E87C3-954C-4297-9D6C-E98BC79D68C3@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Tue, 30 Jan 2007 14:40:49 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I looked at this approach a long time ago, and basically gave up  
> because
> it looked like too much work.

Indeed, your mention of it in that thread.. a year ago?.. is what got  
this notion sitting in the back of my head.  I didn't like it at  
first, but it grew on me.

> I heartily approve, although I only gave the actual patches a very  
> cursory
> glance. I think the approach is the proper one, but the devil is in  
> the
> details. It might be that the stack allocation overhead or some other
> subtle fundamental problem ends up making this impractical in the  
> end, but
> I would _really_ like for this to basically go in.

As for efficiency and overhead, I hope to get some time with the team  
that work on the Giant Database Software Whose Name We Shall Not  
Speak.  That'll give us some non-trival loads to profile.

> It won't matter at all for a certain class of calls (a lot of the  
> people
> who want to do AIO really end up doing non-interruptible things, and
> signalling is a non-issue), but not only is it going to matter for  
> some
> others, we will almost certainly want to have a way to not just  
> signal a
> task, but a single "fibril" (and let me say that I'm not convinced  
> about
> your naming, but I don't hate it either ;)

Yeah, no doubt.  I'm wildly open to discussion here.  (and yeah, me  
either, but I don't care much about the name.  I got tired of  
qualifying overloaded uses of 'stack' or 'thread', that's all :)).

> But from a quick overview of the patches, I really don't see anything
> fundamentally wrong. It needs some error checking and some limiting (I
> _really_ don't think we want a regular user starting a thousand  
> fibrils
> concurrently), but it actually looks much less invasive than I  
> thought it
> would be.

I think we'll also want to flesh out the submission and completion  
interface so that we don't find ourselves frustrated with it in  
another 5 years.  What's there now is just scaffolding to support the  
interesting kernel-internal part.  No doubt the kevent thread will  
come into play here.

- z
