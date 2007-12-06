Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXLFItN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXLFItN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXLFIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:48:57 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:12487 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXLFIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:48:56 -0500
X-Greylist: delayed 50871 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 03:48:55 EST
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zTcLRvR/w==
From: Stefan Rompf <stefan@loplof.de>
To: David Miller <davem@davemloft.net>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Thu, 6 Dec 2007 09:49:01 +0100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20071204.223023.262159049.davem@davemloft.net> <200712051939.08384.stefan@loplof.de> <20071205.182500.166603251.davem@davemloft.net>
In-Reply-To: <20071205.182500.166603251.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712060949.02524.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2007 03:25 schrieb David Miller:

> POSIX says nothing about the semantics of route resolution.

Of course not. Applications must not care about what happens at the transport 
layer.

> Non-blocking doesn't mean "cannot sleep no matter what".

... and as O_CREAT on open() isn't specifically documented to apply to 
filenames starting with 'a', it is perfectly normal that "echo x >ash" always 
fails since 2.6.22. To revert to the old behaviour, please do "echo 1 
>/proc/sys/fs/allow_a_file_creation".

Ok, irony aside. Just have a look at
http://www.opengroup.org/onlinepubs/009695399/functions/connect.html (I hope 
009695399 is not a personalition cookie ;-)

"If the connection cannot be established immediately and O_NONBLOCK is set for 
the file descriptor for the socket, connect() shall fail and set errno to 
[EINPROGRESS], but the connection request shall not be aborted, and the 
connection shall be established asynchronously."

I think the words "shall fail" and "immediately" are quite clear.

> > If this is changed for some IP sockets, event-driven applications
> > will randomly and subtly break.
>
> If this was such a clear cut case we'd have changed things
> a long time ago, but it isn't so don't pretend this is the
> case.

Well, the only reason this doesn't break on a daily basis is because the code 
isn't in the kernel that long and not many people run applications on an 
IPSEC gateway. This will change if kernel based IPSEC is used for roadwarrior 
connections or dnssec based anonymous IPSEC someday. Trust me, you will 
revert this misbehaviour in -stable then.

For some real life applications that break when nonblocking connect() blocks, 
please look f.e. at squid or mozilla firefox.

Stefan
