Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXLFMaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXLFMaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXLFM36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:29:58 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:8374 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXLFM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:29:56 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zTcLRvR/w==
From: Stefan Rompf <stefan@loplof.de>
To: David Miller <davem@davemloft.net>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Thu, 6 Dec 2007 13:30:20 +0100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200712061156.48810.stefan@loplof.de> <200712061235.06025.stefan@loplof.de> <20071206.033909.76192198.davem@davemloft.net>
In-Reply-To: <20071206.033909.76192198.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061330.20586.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2007 12:39 schrieb David Miller:

> > Because you just will put enough RAM modules into you server when
> > setting up a scalable system.
>
> This suggestion is avoiding the important semantic issue, and
> won't lead to a real discussion of the core problem.

When writing applications for unix operating systems, it is known since ages 
that stuff can be swapped out and that even things like memory accesses can 
block. So it does not really surprise when a system call has to wait for 
memory - just imagine the kernel code for connect() could be and has been 
swapped out.

Even with moderate swap activity, this memory should be available in much less 
than one second. If on the other hand the system is already threshing, it is 
no difference if it does so within connect() or while reaching the connect() 
system call in the application flow.

Btw, this is where admin responsibility to size their systems kicks in.

So where I would draw the line: connect() is clearly a network related 
function. Therefore, if a nonblocking connect() has to sleep for a local, 
controllable resource like memory to become available, this is ok. Maybe it 
shouldn't wait for a 128MB buffer if someone configured such an abonimation, 
haven't thought deeply about that. But when being told not to wait the 
connection to complete, it should never ever wait for another network related 
activity like IPSEC SA setup to complete, especially not for hours.

IMHO this is what developers expect, and is also consistent with the fact that 
POSIX does not define O_NONBLOCK behaviour for local files.

Stefan
