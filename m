Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZAaD54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZAaD54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAaD5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:57:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbZAaD5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:57:48 -0500
Date: Fri, 30 Jan 2009 19:57:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <20090131033035.GA26640@elte.hu>
Message-ID: <alpine.LFD.2.00.0901301953280.3150@localhost.localdomain>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <20090131033035.GA26640@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Jan 2009, Ingo Molnar wrote:
> 
> Would be nice to see the kernel image size increase due to this change 
> (which gives a good measure about how much of an issue this is).

Ingo, I don't think you have looked at that header file for a while.

It's already doing that, Davide just changed the names a bit:

	#define wake_up_interruptible(x)        __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)

and the extra parameter is already there in the caller.

(Yeah, Davide did add it to __wake_up_locked and __wake_up_sync, but those 
are really not the common cases).

Sure, we can change those #define's to be actual functions (and perhaps 
not export the low-level __wake_up() functions at all), since it's true 
that it would probably shrink the kernel size, but that is really a 
totally independent issue from the whole epoll wakeups thing.

		Linus
