Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbXIFQKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbXIFQKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 12:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbXIFQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 12:10:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58930 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbXIFQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 12:10:10 -0400
Date: Thu, 6 Sep 2007 09:09:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stray nulls when reading from AF_UNIX sockets
Message-Id: <20070906090950.21d3d637.randy.dunlap@oracle.com>
In-Reply-To: <46E02137.8030600@control.lth.se>
References: <46E02137.8030600@control.lth.se>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 17:48:07 +0200 Anders Blomdell wrote:

> Hi,
> 
> With recent kernels (2.6.22.x), we are experiencing that random null characters
> are read by  our mySQL server (i.e. the number of bytes read by the server is
> larger than the number of bytes written). I'm currently investigating the
> problem (that occurs every 1-35 hours on a loaded system). A current suspect is
> the following code in  net/unix/af_unix.c:
> 
>   static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>                                  struct msghdr *msg, size_t size,
>                                  int flags)
>   {
>     ...
>     return copied ? : err;
>   }
> 
> Shouldn't this read:
> 
>     return copied ? copied : err;
> 
> Or am I missing something?
> 
> Please CC me personally.

It's (?:) a gcc extension.  See

http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/Conditionals.html#Conditionals

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
