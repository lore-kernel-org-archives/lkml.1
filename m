Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYJQDt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYJQDt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYJQDts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:49:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbYJQDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:49:48 -0400
Date: Thu, 16 Oct 2008 20:49:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Roland Dreier <rdreier@cisco.com>, Geert.Uytterhoeven@sonycom.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       yhlu.kernel@gmail.com, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <1224214314.7654.65.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
References: <48F409E9.3030501@zytor.com>  <20081013.223811.174710738.davem@davemloft.net>  <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>  <20081016.013850.85183428.davem@davemloft.net>  <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
  <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Benjamin Herrenschmidt wrote:
> 
> Ok, I'll wait for more comments before a respin to :-) I'm mostly
> wondering whether to use fixed sized format rather than the current
> variable size (and pad with zeros).

Sadly, I think that gcc warns if we were to support %08pR, so we can't 
pass down flags.

That said, I don't much like SPECIAL in the flags. We never do that thing. 
Doing a git grep for some range printouts, we tend to do things like

	[%lx,%lx]
	[%x - %x]
	[%llx, %llx]
	[%016lx - %016lx]
	<%016llx-%016llx>

But using "0x%llx" or "%#llx" is very rare. It happens (notably 
drivers/pci/setup-res.c), but it's not common.

But it would be kind of nice to be able to do extended flags. Maybe we 
could do it with

	%p04R

and the 04 would be parsed as flags, the same way we do %04x. And then if 
you want the 0x, you can use %p#08R..

			Linus
