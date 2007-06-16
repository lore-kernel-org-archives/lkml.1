Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXFPPuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXFPPuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXFPPu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:50:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbXFPPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:50:27 -0400
Date: Sat, 16 Jun 2007 08:49:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
In-Reply-To: <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.98.0706160840290.14121@woody.linux-foundation.org>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <20070615194140.GE8151@cvg> <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Jun 2007, Jan Engelhardt wrote:
> >
> >Heh. Actually, Linux maintainers have generally very consciously _avoided_ 
> >trying to "enforce" coding style issues.
> 
> Really? "it's not going to be merged unless you turn all uint32_t into
> u_int32_t" is a paraphrased variant of what I was told this month.

I suspect different maintainers are hung up on different things, so yes, 
certain things are more likely to carry red flags, and it also depends on 
the patch.

For example, if I get a patch for something that is a whole driver, I 
generally think that while I *prefer* to see it follow the kernel coding 
style, I also expect that the person who sends me the driver is the one 
who is going to maintain it in the future, and thus his personal coding 
style preferences will override any but the strongest objections.

(So if somebody sends me a FSF-style "tabs are two characters, and 
functions must be longer than 300 lines" mess, I generally would prefer to 
not take it at all, but for some really obscure driver I might not care).

In contrast, if a patch modifies code that somebody else really will end 
up touching in the future (maybe not "maintain", but maybe there is no 
single and obvious maintainer), it had better match the code around it.

So to take your particular example: For me, "uint32_t" is certainly better 
than "u_int32_t" (and there's seven times as many of the former as the 
latter in the kernel), but for code _I_ would touch, I'd actually prefer 
the Linux internal "__u32"/"u32", which have no question about what their 
user-space visibility is (ie "__u32" is *always* ok in a header file that 
is visible to user space).

But would I make it a huge issue? Not personally. So it will depend on the 
maintainer.

(Personally, I think the "small functions, no deep levels of indentation, 
and tabs are 8 characters wide" are the most important part by far. But I 
do actually end up complaining about function naming etc too).

		Linus
