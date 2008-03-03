Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYCCRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYCCRLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYCCRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:11:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44955 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751319AbYCCRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:11:14 -0500
Date: Mon, 3 Mar 2008 12:11:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
In-Reply-To: <20080303155330.39e45ad4@core>
Message-ID: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Alan Cox wrote:

> > Atomicity of reads of write for pointers and integral types (other than 
> > long long) should be documented.
> 
> NAK.
> 
> Atomicity of reads or writes for pointers and integral types is NOT
> guaranteed. Gcc doesn't believe in your guarantee.

Miscommunication and lack of clarity.  CPU reads and writes _are_ 
guaranteed to be atomic.  What is not guaranteed is that the compiler 
will generate a single read or write instruction corresponding to a 
particular expression in C.

Consider a routine like the following:

	static task_struct *the_task;

	void store_task(void)
	{
		the_task = current;
	}

Is it possible to say whether readers examining "the_task" are 
guaranteed to see a coherent value?

Alan Stern		

