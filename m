Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZALT1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZALT1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZALT0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:26:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZALT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:26:48 -0500
Message-ID: <496B9890.1090002@zytor.com>
Date: Mon, 12 Jan 2009 11:22:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org>
In-Reply-To: <20090112193201.GA23848@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Jan 12, 2009 at 11:02:17AM -0800, Linus Torvalds wrote:
>>> Something at the back of my mind said "aliasing".
>>>
>>> $ gcc linus.c -O2 -S ; grep subl linus.s
>>>         subl    $1624, %esp
>>> $ gcc linus.c -O2 -S -fno-strict-aliasing; grep subl linus.s
>>>         subl    $824, %esp
>>>
>>> That's with 4.3.2.
>> Interesting. 
>>
>> Nonsensical, but interesting.
> 
> What I find nonsensical is that -fno-strict-aliasing generates
> better code here. Normally one would expect the compiler seeing
> more aliases with that option and then be more conservative
> regarding any sharing. But it seems to be the other way round
> here.

For this to be convolved with aliasing *AT ALL* indicates this is done 
incorrectly.

This is about storage allocation, not aliases.  Storage allocation only 
depends on lifetime.

	-hpa

