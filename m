Return-Path: <linux-kernel-owner+w=401wt.eu-S938128AbXHLTmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938128AbXHLTmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937107AbXHLTmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:42:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933285AbXHLTmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:42:35 -0400
Date: Sun, 12 Aug 2007 12:41:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David H?rdeman <david@hardeman.nu>
cc: linux-kernel@vger.kernel.org
Subject: Re: splice question
In-Reply-To: <20070812162820.GA26892@hardeman.nu>
Message-ID: <alpine.LFD.0.999.0708121238390.30176@woody.linux-foundation.org>
References: <20070812162820.GA26892@hardeman.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, David H?rdeman wrote:
> 
> Once the data is in the pipe, my idea was to tee() from the pipe to each
> client socket using nonblocking ops, and then consume the data by splicing it
> to /dev/null.
> 
> The problem is that tee() doesn't support sockets. Is this a limitation that
> would be easy to fix?

It's very intentional. 

You should think of "tee()" as a memcpy() on kernel buffers.

And what are kernel buffers? It's not a socket.

The "kernel buffer" is simply just another name for a pipe.

So tee() *duplicates* the data in pipe, and then you can use "splice()" on 
the duplicated data to actually send it off somewhere else (eg a socket).

(Or any other pipe operation, for that matter - you can read() it into 
user space etc).

> Otherwise I guess I'd have to add a second pipe, then (in a loop)
> tee() from the first to the second pipe and then splice from the second pipe
> to a socket. Doesn't sound very elegant and would need quite a lot of extra
> syscalls.

You really should think of this as a memcpy(), and you'll be in the right 
mindframe. The system calls themselves are cheap.

			Linus
