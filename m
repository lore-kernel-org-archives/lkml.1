Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXBFJpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXBFJpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBFJpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:45:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXBFJpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:45:15 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	 <1170711587.29759.909.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
	 <1170712393.29759.925.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
	 <20070205143110.fca62b57.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
	 <1170717694.29759.941.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 09:45:01 +0000
Message-Id: <1170755101.29759.960.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 15:32 -0800, Linus Torvalds wrote:
> On Mon, 5 Feb 2007, David Woodhouse wrote:
> > 
> > The netfilter example is totally irrelevant here, since 'select' is
> > neither necessary nor sufficient for that. Russell and I have both
> > pointed that out to you already.
> 
> No, the example IS relevant.
> 
> Why?
> 
> Because you don't seem to be getting the whole "be nice" part.

If you'd come down from your high horse for a moment you might realise
that I _agree_ with the 'be nice' part, as long as you don't pessimise
things for those who _do_ know what they're doing. 

The thing you want for netfilter is a _GOOD IDEA_. I agree. I've even
implemented something _very_ similar, for JFFS2 compression options. If
you want to play about with individual compressors you have to enable
the 'Advanced options' first; otherwise you get the sane defaults.
Unless you really want to get your hands dirty, you don't have to know
which compressors we use by default.

It's a bad example because it's not relevant to the 'select' question,
and you're trying to use it as a straw man; assigning to me a belief I
just don't have.

> You continually argue as if being nice isn't an issue, and shouldn't be 
> even an option.

Perhaps I haven't spoken carefully enough. I mean to argue that being
nice is good -- but that we shouldn't do so in a way which _costs_ those
who use the system most.

> And maybe you can do it without select for netfilter, but you sure as HELL 
> cannot do it for things like SCSI and the USB/ATA question.

No, you really aren't paying attention. You CAN DO IT WITHOUT SELECT.

My point is not that we shouldn't be helpful. My point is that 'select'
is the _wrong_ way to be 'helpful', because that's a PITA for other
people. My point is that if we _want_ someone less experienced to be
able to see 'SCSI' light up automatically when they enable USB_STORAGE,
then we can do that IN THE TOOLS, as was demonstrated quite capably a
decade ago by the Nemesis folks.

But you're obviously not actually interested in reading what people say,
so I fully expect you to again pick one sentence out of the above and go
off at a tangent with a straw man again. So forget it. At least some
guidance on when to use depends vs. select _has_ come out of the thread,
which can be written up in Documentation/ and referred to later. That
should at least improve the _completely_ arbitrary use of 'select' we
currently see, such as the patch which started this thread. And I'll go
fix the kconfig tools to have an option for treating all 'select' of
user-visible options as dependencies, but the benefit of the people who
are the _normal_ users of Kconfig stuff.

-- 
dwmw2

