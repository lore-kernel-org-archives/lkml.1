Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYJHCgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYJHCgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYJHCfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:35:54 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35479 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754009AbYJHCfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:35:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n5sti/wlBUMggsRzMVUIRL2vYkKrJQZmdrLJ1ZenUIZdiqVlVnTqBHmZg68TcAIPhgWlSQP5UC762ocCgZCB/BgQNIlskZQxS/MZc9VT/EyRn0g9BRKHhoRrATUvTkws8wElS8iWqKwHCNyHdIMTNH1brrZLSVoBCbQzpAbLgs4=  ;
X-YMail-OSG: FNJj_eAVM1nLDmof5.kj60Ee8qjPGHyDuMLSaYgXYOutG7X.AA3yIFn7avuTqGkeAGYRbI9GZidrEgpGdz2pQBogLVVnO1rICBeuWgGnLf.lx6RcNhaTKRMzz2_WENjQZoCtbvEm3.blQjpnsAsPpyvRvtVcwqBqKr6mpvaXEA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 8 Oct 2008 13:35:44 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081335.44576.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 05:59, Peter Zijlstra wrote:
> On Tue, 2008-10-07 at 10:50 -0700, Andrew Morton wrote:

> > It's pretty damn improbable, and I think we can afford to spend the
> > time to get this right in 2.6.29.
>
> The whole point is that such usage is outside the specification and thus
> we don't strictly need to fix this.
>
> So the question Nick is asking is, do we want to slow down the kernel
> for a few broken user-space applications. Esp. since the race doesn't
> affect anybody else except the broken users of the file descriptor.

Right you are. That's the fundamental question. The actual details of
the fix and how likely the race is don't really matter until we
answer the first question (except to say that the "fix" is never going
to be free).

We've lasted this long with the current semantics. So the natural
reaction to anything that strengthens the semantics now is "why?". If
we do that then we can basically never return to the weaker semantics.
So there had better be a really good reason.
