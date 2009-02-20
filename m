Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZBTHdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZBTHdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZBTHd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:33:28 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:42402 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbZBTHd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:33:27 -0500
X-Greylist: delayed 1983 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 02:33:27 EST
Message-ID: <499E5506.5090406@fastmq.com>
Date: Fri, 20 Feb 2009 08:00:22 +0100
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
References: <499E527B.2030702@fastmq.com>
In-Reply-To: <499E527B.2030702@fastmq.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Speaking of eventfd use cases, we're using it as a bitmap. Everything 
works great, the only problem being that we have to take extra care not 
to set the same bit twice:

fd_counter is 00000000
write (fd, 00001000)
fd_counter is 00001000
write (fd, 00000001)
fd_counter is 00001001
write (fd, 00001000) /* oops! */
fd_counter is 00010001

Would anyone else benefit from a new eventfd flag, say EFD_BITMAP, that 
would cause write(2) to do binary OR rather than + on the counter?

Martin

Martin Sustrik wrote:
>     
> Enter your search termsSubmit search formWeblkml.org
> Date    Wed, 4 Feb 2009 14:58:39 -0800 (PST)
> From    Davide Libenzi <>
> Subject    [patch/rfc] eventfd semaphore-like behavior
> 
> People started using eventfd in scnarios where before where using pipes.
> Many of them use eventfds in a semaphore-like way, like they were before
> with pipes. The problem with eventfd is that a read() on the fd returns
> and wipes the whole counter, making the use of it as semaphore a little
> bit more cumbersome. You can do a read() followed by a write() of
> COUNTER-1, but IMO it's pretty easy and cheap to make this work w/out
> extra steps. This patch introduces a new eventfd flag that tells eventfd
> to only dequeue 1 from the counter, allowing simple read/write to make it
> behave like a semaphore.
> Simple test here:
> 
> http://www.xmailserver.org/eventfd-sem.c
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 

