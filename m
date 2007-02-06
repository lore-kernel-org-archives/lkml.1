Return-Path: <linux-kernel-owner+w=401wt.eu-S965284AbXBFVrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965284AbXBFVrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXBFVrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:47:43 -0500
Received: from sp604003mt.neufgp.fr ([84.96.92.56]:57457 "EHLO smTp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965284AbXBFVrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:47:42 -0500
Date: Tue, 06 Feb 2007 22:46:25 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-reply-to: <20070206.133140.91442326.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, kent.overstreet@gmail.com,
       davidel@xmailserver.org, zach.brown@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org, suparna@in.ibm.com,
       bcrl@kvack.org
Message-id: <45C8F731.4070007@cosmosbay.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <20070206.131631.82049180.davem@davemloft.net>
 <Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org>
 <20070206.133140.91442326.davem@davemloft.net>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 6 Feb 2007 13:28:34 -0800 (PST)
> 
>> Yeah, in 1% of all cases it will block, and you'll want to wait for them. 
>> Maybe the kevent queue works then, but if it needs any more setup than the 
>> nonblocking case, that's a big no.
> 
> So the idea is to just run it to completion if it won't block and use
> a fibril if it would?
> 
> kevent could support something like that too.

It seems to me that kevent was designed to handle many events sources on a 
single endpoint, like epoll (but with different internals). Typical load of 
thousand of sockets/pipes providers glued into one queue.

In the fibril case, I guess a thread wont have many fibrils lying around...

Also, kevent needs a fd lookup/fput to retrieve some queued events, and that 
may be a performance hit for the AIO case, (fget/fput in a multi-threaded 
program cost some atomic ops)

