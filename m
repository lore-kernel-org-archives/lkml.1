Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXBNVKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXBNVKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbXBNVKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:10:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3668 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbXBNVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:10:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 13:09:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702141308240.7796@alien.or.mcafeemobile.com>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Linus Torvalds wrote:

> 
> 
> On Tue, 13 Feb 2007, Ingo Molnar wrote:
> > 
> > the core syslet / async system calls infrastructure code.
> 
> Ok, having now looked at it more, I can say:
> 
>  - I hate it.
> 
> I dislike it intensely, because it's so _close_ to being usable. But the 
> programming interface looks absolutely horrid for any "casual" use, and 
> while the loops etc look like fun, I think they are likely to be less than 
> useful in practice. Yeah, you can do the "setup and teardown" just once, 
> but it ends up being "once per user", and it ends up being a lot of stuff 
> to do for somebody who wants to just do some simple async stuff.
> 
> And the whole "lock things down in memory" approach is bad. It's doing 
> expensive things like mlock(), making the overhead for _single_ system 
> calls much more expensive. Since I don't actually believe that the 
> non-single case is even all that interesting, I really don't like it.
> 
> I think it's clever and potentially useful to allow user mode to see the 
> data structures (and even allow user mode to *modify* them) while the 
> async thing is running, but it really seems to be a case of excessive 
> cleverness.

Ok, that makes the wierdo-count up to two :) I agree with you that the 
chained API can be improved at least.



- Davide


