Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0BOG4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:56:41 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43050 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab0BOG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:56:40 -0500
Date: Mon, 15 Feb 2010 08:56:29 +0200
From: Jouni Malinen <j@w1.fi>
To: Michael Neuling <mikey@neuling.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space
 expansion to rlimit
Message-ID: <20100215065629.GA14412@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
 <9296.1266185019@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9296.1266185019@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:03:39AM +1100, Michael Neuling wrote:
> Crud, the "killed" is definitely something this patch could cause.
> 
> I'm not familiar with UML.  Is this the guest and the host booting rc8,
> or just the host?  Does UML use stack protection at all?

Only the guest was booting rc8 (host is Ubuntu 2.6.31-19-generic), i.e.,
the issue shows up in the guest kernel after rc8 (and is removed by
reverting 803bf5). I do not know whether stack protection is used.

> Can you try booting the guest to init=/bin/sh and try running some tests
> to see what you can set 'ulimit -s' to and still be able to run a simple
> command like '/bin/ls'?

With 803bf5 included, init=/bin/sh seems to fail the boot quite
frequently, but not always. Once I get to shell on the UML guest,
/bin/ls fails about half of the time (e.g., running /bin/ls in /root
failed six times out of ten). This was before touching ulimit -s at all
("ulimit -s" shows 8192).

The behavior of 'ls' run with various ulimit -s values:

24-10000: OK or Killed
16-23: OK or Segmentation fault or Killed
1-15: Killed or Segmentation fault

I have no idea what is causing the random behavior in the results, but
anyway, it looks like 'ulimit -s 23' is the first point where
segmentation faults start showing up and 'ulimit -s 15' is the point
where ls fails every time.


If I start the guest (normal boot with multiple virtual consoles) with
803bf5 reverted, 'ulimit -s 84' has /bin/ls working every time and
'ulimit -s 83' makes it fail every time.

-- 
Jouni Malinen                                            PGP id EFC895FA
