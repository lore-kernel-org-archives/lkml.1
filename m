Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZAITBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZAITBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZAITBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:01:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127AbZAITBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:01:10 -0500
Date: Fri, 9 Jan 2009 11:00:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Dirk Hohndel <hohndel@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
In-Reply-To: <20090109185509.GJ26290@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0901091045090.6528@localhost.localdomain>
References: <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org>
 <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Andi Kleen wrote:
> 
> Ok you're saying we should pay the 4.1% by default for this?

The thing is, YOU ARE MAKING THAT NUMBER UP!

First off, the size increase only matters if it actually increases the 
cache footprint. And it may, but..

Secondly, my whole point here has been that we should not rely on gcc 
doing things behind our back, because gcc will generally do the wrong 
thing. If we decided to be more active about this, we could just choose to 
find the places that matter (in hot code) and fix _those_.

Thirdly, you're just replacing _one_ random gcc choice with _another_ 
random one.

What happens when you say -fno-inline-functions-called-once? Does it 
disable inlining for those functions IN GENERAL, or just for the LARGE 
ones? See?

			Linus
