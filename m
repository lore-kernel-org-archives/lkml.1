Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYGMJiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYGMJiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYGMJiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:38:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYGMJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:38:15 -0400
Message-ID: <4879CCFD.70208@firstfloor.org>
Date: Sun, 13 Jul 2008 11:38:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <87mykn2sos.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 12 Jul 2008, Andi Kleen wrote:
>> Linus, the fact that is not explained by your theory is why
>> Ctrl-Z+kill works but Ctrl-C doesn't.
> 
> Umm. Read the reports more carefully. Many of the complaints are about ^Z 
> too.

At least the original report was about Ctrl-C only versus Ctrl-Z.

I see the problem regularly myself that Ctrl-C doesn't work,
but Ctrl-Z+kill does (although I unfortunately cannot
reproduce it on demand). But it was with programs who shouldn't catch Ctrl-C,
like find. I confirmed with ltrace that at least my version of find doesn't
catch any signals.

Take the original report for example:

http://marc.info/?l=linux-kernel&m=121464952615807&w=2

It also had trouble interrupting find:

$ find / >/dev/null
find: `/boot/lost+found': Permission denied
^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C

but Ctrl-Z+kill worked immediately.

> The reason? It's quite common to catch ^C in order to do cleanup.

Yes I understand that, but I don't think it's the case here.

I'm afraid it's more a "has a simple explanation that is wrong"
case here.

Or we might be talking about multiple different bugs.

-Andi
