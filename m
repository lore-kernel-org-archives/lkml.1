Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYDYQFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYDYQFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYDYQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:05:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbYDYQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:05:22 -0400
Message-ID: <4811FF60.6040905@zytor.com>
Date: Fri, 25 Apr 2008 08:57:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425155000.GA4438@elte.hu>
In-Reply-To: <20080425155000.GA4438@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> text_poke() itself only applies/unapplies the LOCK prefix - a single 
> byte. We shouldnt be doing that at all: the cost of LOCK is 
> insignificant (a few cycles) and most systems are SMP anyway.
> 

Alas, on older CPUs the cost of LOCK can be massive.  The question is 
how much we really care - the embedded people (who would definitely be 
affected) will simply build UP kernels, and this only affects booting 
SMP kernels on UP.

	-hpa
