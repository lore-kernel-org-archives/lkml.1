Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYJQEGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYJQEGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYJQEGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:06:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:47781 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYJQEGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:06:31 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, Geert.Uytterhoeven@sonycom.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       yhlu.kernel@gmail.com, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
References: <48F409E9.3030501@zytor.com>
	 <20081013.223811.174710738.davem@davemloft.net>
	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	 <20081016.013850.85183428.davem@davemloft.net>
	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
	 <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 15:05:10 +1100
Message-Id: <1224216310.7654.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 20:49 -0700, Linus Torvalds wrote:
> 
> On Fri, 17 Oct 2008, Benjamin Herrenschmidt wrote:
> > 
> > Ok, I'll wait for more comments before a respin to :-) I'm mostly
> > wondering whether to use fixed sized format rather than the current
> > variable size (and pad with zeros).
> 
> Sadly, I think that gcc warns if we were to support %08pR, so we can't 
> pass down flags.
> 
> That said, I don't much like SPECIAL in the flags. We never do that thing. 
> Doing a git grep for some range printouts, we tend to do things like

I hesitated, but DaveM convinced me if you get a range of IO ports such
as 138-139, do you know on a first look that it's hex ? :-)

> and the 04 would be parsed as flags, the same way we do %04x. And then if 
> you want the 0x, you can use %p#08R..

Shouldn't we be consistent and have resources always be printed using
the same format ?

Cheers,
Ben.


