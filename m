Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZAJFH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZAJFH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZAJFHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:07:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZAJFHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:07:05 -0500
Message-ID: <49682C05.7030407@zytor.com>
Date: Fri, 09 Jan 2009 21:03:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>  <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>  <20090109231227.GA25070@elte.hu>  <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>  <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick> <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> There's none. In fact, it's wrong, unless you _also_ have an extern 
> definition (according to the "new" gcc rules as of back in the days).
> 
> Of course, as long as "inline" really means _always_ inline, it won't 
> matter. So in that sense Ingo is right - we _could_. Which has no bearing 
> on whether we _should_, of course.
> 

I was thinking about experimenting with this, to see what level of
upside it might add.  Ingo showed me numbers which indicate that a
fairly significant fraction of the cases where removing inline helps is
in .h files, which would require code movement to fix.  Hence to see if
it can be automated.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

