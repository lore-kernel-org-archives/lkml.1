Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYG2Qru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYG2Qru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYG2Qrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:47:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYG2Qrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:47:40 -0400
Date: Tue, 29 Jul 2008 09:44:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
In-Reply-To: <alpine.LFD.1.10.0807290927240.3334@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807290936090.3334@nehalem.linux-foundation.org>
References: <20080729180317.94c64634.sfr@canb.auug.org.au> <20080729085815.GA1301@elte.hu> <20080729202731.F18F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080729114029.GA3836@elte.hu> <alpine.LFD.1.10.0807290927240.3334@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Linus Torvalds wrote:
>
>   [...]                           since statement expressions are gcc 
> extensions, and as such the gcc people could make up any semantics they 
> want to them, including just defining that a statement expression with 
> an lvalue value is the same lvalue rather than any temporary). 

In fact, that does seem what gcc-4.x does. The way to tell is to do

	const int *x;

	({ *x }) = 1;

and it's (a) legal (assignments to non-lvalues wouldn't work) and (b) 
gives a nice warning about assignment to read-only location, which in turn 
implies that the compiler properly just peeled off the de-reference even 
though it was inside the statement expression.

IOW, at least in gcc-4.3 (and apparently in earlier gcc-4 versions, but 
not in gcc-3.4.5), a statement expression with an lvalue return value _is_ 
actually an lvalue.

But that also means that there is no difference what-so-ever between (x) 
and ({ x; }) in gcc-4. And in gcc-3 there is, because apparently in gcc-3 
a statement expression is never an lvalue (which is actually the sane 
thing, imho).

			Linus
