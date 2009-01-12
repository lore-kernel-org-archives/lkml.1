Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZALB5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZALB5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZALB5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:57:19 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44135 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZALB5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:57:18 -0500
Date: Mon, 12 Jan 2009 01:56:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090112015620.GA6428@shareable.org>
References: <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick> <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain> <49682C05.7030407@zytor.com> <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain> <20090111005458.GA5363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111005458.GA5363@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> If it's used once in a single .c file it should be inlined even if
> it's large.

As Linus has pointed out, because of GCC not sharing stack among
different inlined functions, the above is surprisingly not true.

In kernel it's a problem due to raw stack usage.

In userspace apps (where stack used is larger), inlining single-call
functions could, paradoxically, run slower due to increased stack
dcache pressure for some larger functions.

-- Jamie
