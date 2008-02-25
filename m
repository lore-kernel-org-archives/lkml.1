Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYBYOqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYBYOqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYBYOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:46:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33378 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754508AbYBYOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:46:09 -0500
Date: Mon, 25 Feb 2008 09:46:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: using long instead of atomic_t when only set/read is required
 (was Re: [Bug 10030] Suspend doesn't work when SD card is inserted)
In-Reply-To: <20080225090316.GA420@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Pavel Machek wrote:

> Hi!
> 
> Alan thinks that `subj` is correct...

More precisely, reads and writes of pointers are always atomic.  That 
is, if a write and a read occur concurrently, it is guaranteed that the 
read will obtain either the old or the new value of the pointer, never 
a mish-mash of the two.  If this were not so then RCU wouldn't work.

> I guess it only works as long as longs are aligned? Should it be
> written down to atomic_ops.txt?

Forget it, I'm going to withdraw the entire thing.  The whole approach 
is wrong.  More details in a new email thread, to follow soon.

Alan Stern

