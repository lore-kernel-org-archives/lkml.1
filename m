Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbXF3Vve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbXF3Vve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXF3Vv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:51:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbXF3VvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:51:25 -0400
Date: Sat, 30 Jun 2007 14:51:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: linux@horizon.com
cc: davidel@xmailserver.org, linux-kernel@vger.kernel.org
Subject: Re: A simpler variant on sys_indirect?
In-Reply-To: <20070630205235.6638.qmail@science.horizon.com>
Message-ID: <alpine.LFD.0.98.0706301447530.1172@woody.linux-foundation.org>
References: <20070630205235.6638.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jun 2007, linux@horizon.com wrote:
> 
> The downsides are that you need to save and restore the prefix flags
> across signal delivery, and you have a second user/kernel/user transition.

Both of these are basically horrible mistakes. 

The first one will almost certainly break things that get clever, like 
strace, and just make things really hard to debug.

The second one means that you are guaranteed to be basically twice as slow 
on any fast system call, since the system call overhead itself is usually 
quite a noticeable cost, often dominating everything else.

> And if the kernel entry overhead IS a problem, wouldn't you want to
> batch together the non-prefix system calls as well, using something like
> the syslet ideas that were kicked around recently?  That would
> allow less than 1 kernel entry per system call, even with prefixes.

The batching has serious problems, not the least of which is that it's a 
fundamentally more complex interface, and introduces issues like "how do 
we pass values from one system call to the next". 

That's why I shot it down for syslets too. 

			Linus
