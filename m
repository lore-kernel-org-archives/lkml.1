Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZFKQ1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZFKQ1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZFKQ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:27:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbZFKQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:27:33 -0400
Date: Thu, 11 Jun 2009 09:26:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611161714.GA5008@infradead.org>
Message-ID: <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Christoph Hellwig wrote:
>
> Err, no.   This adds tons of userspace code into tools/ which
> should not be in the kernel tree but a proper package.

I disagree.

We've had tons of cases where we tried to "separate" the user-land code 
and the kernel code, in the name of "beauty" of whatever.

It's almost invariably a disaster.

Look at oprofile. F*ck me, what a horrid piece of crap. It took literally 
months for the user mode tools to catch up and get the patches to support 
new functionality into CVS (or is it SVN?), and after that it took even 
longer for them to become part of a release and be picked up by 
distributions. In fact, I'm not sure it is part of a release even now - I 
had to make a bug report to Fedora to get atom and Nehalem support in my 
tools: I think they took the unofficial patch.

Or look at the crazy things we used to do for X. It's going away (slowly), 
because some of the most incestuous things are actually just being 
integrated into the kernel, and so there's less of the "two broken pieces" 
approach, and more of a "one working piece" kind of thing.

So I'd much rather have kernel tools with the kernel, than have to depend 
on some external entity that doesn't really care.

			Linus
