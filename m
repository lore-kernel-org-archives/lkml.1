Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYDYPlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYDYPlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYDYPk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:40:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYDYPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:40:56 -0400
Date: Fri, 25 Apr 2008 08:33:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
In-Reply-To: <20080425152650.GA894@elte.hu>
Message-ID: <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, Ingo Molnar wrote:
> 
> something like the patch below? (untested)

No. That whole code sequence is total and utter crap. It needs to be 
rewritten.

It first does a BUG_ON() if it's not naturally aligned (because that 
wouldn't be atomic), and then it has code for page crossing! What a TOTAL 
PIECE OF SH*T!

Hint:
 - if it's naturally aligned, it couldn't be page crossing ANYWAY
 - and if it was a page-crosser, it sure as hell couldn't be atomic!

The code is just crap, crap, crap. It needs to be rewritten from scratch. 
I'll have a patch soonish.

		Linus
