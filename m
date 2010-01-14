Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971Ab0ANE2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0ANE2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 23:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091Ab0ANE17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 23:27:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0ANE16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 23:27:58 -0500
Date: Wed, 13 Jan 2010 20:28:07 -0800 (PST)
Message-Id: <20100113.202807.233259060.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: arnd@arndb.de, geert@linux-m68k.org, acme@redhat.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: sys_recvmmsg: wire up or not?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263442833.724.325.camel@pasglop>
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
	<200912261212.14264.arnd@arndb.de>
	<1263442833.724.325.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 14 Jan 2010 15:20:33 +1100

> Anything happening here ? We're getting that warning on ppc too despite
> the fact that we use socketcall like x86... Should checksyscall be made
> smarter or the syscall just removed from x86 ? :-)

I think it's better to trap directly to the system call rather
than going through yet another demultiplexer.

I severely regretted using sys_socketcall initially on sparc32
because it added a few microseconds to socket syscall latency
(cpus back then were slow :-)
