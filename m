Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYH1RUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYH1RUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYH1RUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbYH1RUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:20:43 -0400
Date: Thu, 28 Aug 2008 10:20:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource/x86: add sticky resource type
In-Reply-To: <20080828082119.GN21875@elte.hu>
Message-ID: <alpine.LFD.1.10.0808281015440.3300@nehalem.linux-foundation.org>
References: <1219888583-31577-1-git-send-email-yhlu.kernel@gmail.com> <20080828082119.GN21875@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Ingo Molnar wrote:
>
> Does anyone have any suggestions of how to improve this some more? (or 
> do it differently)

As far as I can see, THIS IS TOTALLY BROKEN.

There's a reason why we add the broken resources LATE. There's a reason we 
_have_ to add them late.

Trying to come up with these braindamaged schemes to avoid doing it right 
is wrong. Don't do it.

The reason? Those bogus resources that the BIOS reports are simply NOT 
TRUSTWORTHY. They may actually be in all the wrong places, including 
covering a resource half-way, or crossing two real resources.

Yes, it's rare. But it happens. Which is why we should not do these broken 
things that _incorrectly_ assume that the BIOS resources will only ever be 
totally contained within a BAR, or will totally contain one. Think about 
the partial overlap case.

Guys, until you learn that the BIOS resources are _crap_ and at most 
random guesses, you shouldn't touch this code! And it has nothing to do 
with writing "clean" code, or making things "simple", because quite 
frankly, things simply ARE NOT simple!

The fact is, the only reliable way to handle these things has _always_ 
been to ask the hardware first. Add the broken resources from ACPI and 
other BIOS tables _later_. If they conflict, it is the ACPI/BIOS tables 
that should be removed.

Why do I have to tell this to people over and over again?

		Linus
