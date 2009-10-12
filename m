Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbZJLQVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbZJLQVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbZJLQVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:21:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932789AbZJLQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:20:59 -0400
Date: Mon, 12 Oct 2009 09:19:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
 uart_close+0x2a/0x1e4
In-Reply-To: <20091012080511.GA22607@elte.hu>
Message-ID: <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Ingo Molnar wrote:
> 
> Note, i have your fix below applied in tip:out-of-tree - it might be the 
> source of this bug? (If yes then this isnt an .32-rc4 problem.)

If yes (but you later reported no), it would still be a 32-rc4 problem, 
because that patch got committed as 0b5759c654 ("tty: Avoid dropping 
ldisc_mutex over hangup tty re-initialization").

So you shouldn't need it in the out-of-tree branch any more, and you 
probably just never noticed because it all merged cleanly.

Commit 46d57a449 (which you then bisected to) looks really irritating, 
since it just renamed variables in annoying ways (ie the old "port" is now 
"uport", and there's a new "port" that means something else). That thing 
should have been split up to do the renaming separately, so that a mis-use 
of "port" would have caused a compile error.

I'm not seeing anything obvious. Alan obviously found one bug already.

		Linus
