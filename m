Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZAITVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZAITVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZAITUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:20:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZAITUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:20:53 -0500
Date: Fri, 9 Jan 2009 20:35:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dirk Hohndel <hohndel@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
       Chris Mason <chris.mason@oracle.com>,
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
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Message-ID: <20090109193506.GL26290@one.firstfloor.org>
References: <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org> <alpine.LFD.2.00.0901091045090.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901091045090.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What happens when you say -fno-inline-functions-called-once? Does it 
> disable inlining for those functions IN GENERAL, or just for the LARGE 

It does disable it in general, unless they're marked inline explicitely :

The traditional gcc 2.x rules were:

I Only inline what is marked inline (but it can decide to
not inline)
II Also inline others heuristically only with 
-O3 / -finline-functions [which we don't set in the kernel]

Then at some point this additional rule was added:

- Also inline everything static that is only called once
[on the theory that this shrinks code size which is true
according to my measurements]

-fno-inline-functions-called once disables this new rule.
It's very well and clearly defined.

-Andi

-- 
ak@linux.intel.com
