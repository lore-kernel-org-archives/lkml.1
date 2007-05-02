Return-Path: <linux-kernel-owner+w=401wt.eu-S1766844AbXEBR2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766844AbXEBR2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766848AbXEBR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:28:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4747 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766844AbXEBR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:28:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 2 May 2007 10:28:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable objects
In-Reply-To: <20070501230529.424f17c6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>
 <20070501230529.424f17c6.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Andrew Morton wrote:

> David, could you provide some feedback please?  The patches are stunningly
> free of comments, but you used to do that to me pretty often so my sympathy
> is limited ;)

You bastard! :)
Ok, from a brief look ...

[general]
The code adds an extra indirection over the already existing 
file_operations, that IMO already sufficently abstract a file.
The compat code, if I read it correctly, does not support files crossing 
32/64 bits boundaries (exec or SCM_RIGHTS).

[timers]
Returns a structure instead of a 32 bit counter (ala timerfd), and needs 
extra compat code.

[signal]
All the discussions that went on for signalfd has been lost. It pins the 
task struct and it does not handle process detach signaling.

[aio]
I prefer a signaling-only approach like the 20 lines patch I posted, and 
use the standard AIO calls to fetch results. This code simply wraps AIO 
calls. This is just my opinions of course, and others may disagree.

[futex]
I intentionally stayed out of there after all the talks about futexfd 
being killed due to the impossibility of getting an interface right (did 
not follow the talk, so I can't tell the level of BS contained in the 
previous statement). We also have a nice printk in there, with the first 
kill-on deadline that ever made mainline :)

         printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
                "will be removed from the kernel in June 2007\n",
                 current->comm);




- Davide


