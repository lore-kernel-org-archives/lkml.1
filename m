Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZKPEbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZKPEbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZKPEbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:31:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36052
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZKPEbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:31:22 -0500
Date: Sun, 15 Nov 2009 20:31:38 -0800 (PST)
Message-Id: <20091115.203138.127196997.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, ltt-dev@lists.casi.polymtl.ca,
       rp@svcs.cs.pdx.edu
Subject: Re: Sparc64 support added to Userspace RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091022195753.GA27253@Krystal>
References: <20091022183242.GA19307@Krystal>
	<20091022195753.GA27253@Krystal>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 22 Oct 2009 15:57:53 -0400

> Feedback is welcome,

__sparc_v8__ does not mean 64-bit longs or pointers as implied here:

#ifndef __SIZEOF_LONG__
#if (defined(__sparc_v8__) || defined(__sparc_v9__))
#define __SIZEOF_LONG__ 8
#else
#define __SIZEOF_LONG__ 4
#endif
#endif

"v8" was the last 32-bit standard of the cpu architecture.

Otherwise looks fine.

Although this port won't be very useful until it can be built in
32-bit mode.  As most applications on sparc64 systems are still
32-bit.  Like on powerpc, people only rarely build things 64-bit on
sparc64.

You need to build with "-Wa,-Av9a" on the GCC command line for that
case so that the assembler allows the v9 instructions emitted by your
macros, even when building for 32-bit.

Hope this helps.
