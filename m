Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbXDJVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbXDJVqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDJVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:46:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44574 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXDJVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:46:28 -0400
X-Originating-Ip: 74.109.98.130
Date: Tue, 10 Apr 2007 17:45:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Roland Dreier <rdreier@cisco.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
In-Reply-To: <ada7isjq52p.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0704101743520.24794@CPE00045a9c397f-CM001225dbafb6>
References: <20070410181654.GA10525@arun.site> <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr> <ada7isjq52p.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Roland Dreier wrote:

>  > >but that's where you would use the more explicit
>  > >__RAW_SPIN_LOCK_UNLOCKED, no?  AFAIK, you really can remove the macro
>  > >SPIN_LOCK_UNLOCKED in its entirety.
>  >
>  > I don't remember LDD speaking about __RAW_*. (And other than not
>  > having looked into the code to date, I don't know the difference.)
>
> Don't worry about the __RAW_SPIN_LOCK_UNLOCKED stuff, that's
> obviously not for generic code to use.  The right answer (as I said
> before) is to use DEFINE_SPINLOCK().

that works fine if you're defining a single spinlock, but what do you
do in cases like this:

arch/sparc/lib/atomic32.c:      [0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED

that is, when you're assigning an array of them?  you still need some
kind of generic, unnamed spinlock in those circumstances, no?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
