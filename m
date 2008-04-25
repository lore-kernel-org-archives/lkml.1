Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbYDYQsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbYDYQsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764232AbYDYQrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:47:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763150AbYDYQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:47:21 -0400
Message-ID: <481209F2.4050908@zytor.com>
Date: Fri, 25 Apr 2008 09:42:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal>
In-Reply-To: <20080425163035.GE9503@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Yes, the immediate values, in general, only need to do atomic writes,
> because I have taken care of placing the mov instruction in the correct
> alignment so its immediate value happens to be aligned in memory.
> However, the latest optimisation I did to change a conditional branch
> into a jump when the correct code pattern is detected :
> 
> mov, test, bne short
> into a
> nop2, nop2, nop1, jmp short
> 
> or
> 
> mov, test, bne near
> into a
> nop2, nop2, nop1, jmp near
> 

And how, pray tell, do you deal with the fact that:

a) the EFLAGS may be live on exit;
b) there might be a jump into the middle of this instruction sequence?

	-hpa
