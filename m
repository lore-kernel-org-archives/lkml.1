Return-Path: <linux-kernel-owner+w=401wt.eu-S940226AbXHIMs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940226AbXHIMs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936551AbXHIMnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:43:06 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47743 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939367AbXHIMnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:43:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 9 Aug 2007 08:37:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Chris Snook <csnook@redhat.com>
cc: Jerry Jiang <wjiang@resilience.com>, Chris Friesen <cfriesen@nortel.com>,
       Zan Lynx <zlynx@acm.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
In-Reply-To: <46BA2D72.9060202@redhat.com>
Message-ID: <Pine.LNX.4.64.0708090836070.10666@localhost.localdomain>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
 <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com>
 <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com>
 <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com>
 <46B8E64E.7010708@nortel.com> <1186525977.232321.43.camel@localhost>
 <46B91D0C.5050704@redhat.com> <46B94B94.6000600@nortel.com>
 <46B96719.3050006@redhat.com> <20070808162755.61f50fbf.wjiang@resilience.com>
 <46BA2D72.9060202@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Chris Snook wrote:

> Jerry Jiang wrote:
> > On Wed, 08 Aug 2007 02:47:53 -0400
> > Chris Snook <csnook@redhat.com> wrote:
> >
> > > Chris Friesen wrote:
> > > > Chris Snook wrote:
> > > >
> > > > > This is not a problem, since indirect references will cause the CPU to
> > > > > fetch the data from memory/cache anyway.
> > > > Isn't Zan's sample code (that shows the problem) already using indirect
> > > > references?
> > > Yeah, I misinterpreted his conclusion.  I thought about this for a while,
> > > and realized that it's perfectly legal for the compiler to re-use a value
> > > obtained from atomic_read.  All that matters is that the read itself was
> > > atomic.  The use (or non-use) of the volatile keyword is really more
> > > relevant to the other atomic operations.  If you want to guarantee a
> > > re-read from memory, use barrier().  This, incidentally, uses volatile
> > > under the hood.
> > >
> >
> >
> > So for example, without volatile
> >
> > int a = read_atomic(v);
> > int b = read_atomic(v);
> >
> > the compiler will optimize it as b = a, But with volatile, it will be forced
> > to fetch v's value from memory
> > again.
> >
> > So, come back our initial question,
> > include/asm-v850/atomic.h:typedef struct { int counter; } atomic_t;
> >
> > Why is it right without volatile?
>
> Because atomic_t doesn't promise a memory fetch every time.  It merely
> promises that any atomic_* operations will, in fact, be atomic.  For example,
> posted today:
>
> http://lkml.org/lkml/2007/8/8/122

i'm sure that, when this is all done, i'll finally have an answer to
my original question, "why are some atomic_t's not volatile, while
most are?"

i'm almost scared to ask any more questions.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
