Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYHPPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYHPPnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYHPPne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:43:34 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:58526 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYHPPnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:43:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFADuNpkhMRKxB/2dsb2JhbACBYrBmgVg
Date: Sat, 16 Aug 2008 11:43:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 : support atomic ops with 64 bits integer values
Message-ID: <20080816154330.GA5880@Krystal>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <48A6EC77.8080904@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:36:22 up 72 days, 20:16,  5 users,  load average: 0.47, 0.41,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> x86_64 add/sub atomic ops does not seems to accept integer values bigger
>> than 32 bits as immediates. Intel's add/sub documentation specifies they
>> have to be passed as registers.
>
> This is correct; this is in fact true for all instructions except "mov".
>
> Whether it's sign- or zero-extending is sometimes subtle, but not in these 
> cases.
>
> Do you happen to know if this is a manifest bug in the current kernel (i.e. 
> if there is anywhere we're using more than ±2 GB as a constant to these 
> functions?)
>

No, I did not hit this on current kernel code and the effect is quite
esasy to detect : the assembler spits an error.

I have hit this problem when tying to implement a better rwlock design
than is currently in the mainline kernel (I know the RT kernel has a
hard time with rwlocks), and had to play with add/sub of large values.
The idea is to bring down the interrupt latency caused by rwlocks shared
between fast read-side interrupt handlers and slow thread context
read-sides (tasklist_lock is the perfect example). In that case, the
worse case interrupt latency is caused by the irq-disabled writer lock
when contended by the slow readers. I will probably post a RFC about
this in a near future.

Mathieu

> Either way, I'll queue this up to tip:x86/urgent if Ingo hasn't already 
> since this is a pure bug fix.
>
> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
