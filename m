Return-Path: <linux-kernel-owner+w=401wt.eu-S966243AbXDDBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966243AbXDDBlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966252AbXDDBlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:41:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48011 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966243AbXDDBlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:41:18 -0400
Date: Wed, 4 Apr 2007 02:44:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Lang <david.lang@digitalinsight.com>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404024400.56d016e1@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
References: <1175644642.10567.31.camel@shinybook.infradead.org>
	<200704032210
 02.GA13210@cynthia.pants.nu>
	<1175648051.10567.61.camel@shinybook.infradead.
 org>
	<20070403.181645.68159458.davem@davemloft.net>
	<20070404022828.5c9b97f3@the-village.bc.nu>
	<Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > You don't get machines with 64 ethernet ports on add-in cards. There are
> > good reasons for the naming schemes in use.
> 
> I've seen machines offering up to 48, what's the magic number that makes you 
> need to chagne nameing schemes?

Have you tried working with 48 ports when they are not numbered 0-47 or
in some logical fashion ?

> I also know of systems with 50 serial ports on them. the fact that some of the 
> serial ports on the front panel were named differently then other serial ports 
> on the front panel sure didn't make my life easier in dealing with them.

Well the better designed serial setups on Linux use numbering so that you
can look on the multiplexor boxes and know straight away what the
correlation between port number and name is. In the same was as "S0 is
console 1" is nice to have its also nice to have "mux 1 port 4" easily
calculable not think

	"Well now we've got 2 console ports thats S0/S1, a 4 port PCI
card found before us so thats S2 to S5, so we must start as S6 to mux 1
port 4 is going to be umm .. S10"

Let alone the hell that breaks out when you add a new card using this
system.

The ethernet one works better because you've usually got a MAC address
per port (although its not required by any means), which means that the
scripts in the distro can do naming persistency for you and hide the
whole exciting game from you.

Which is also another reason for building the "all serial devices"
mapping by using udev, as it can provide multiple simultaneous views. The
serial console unfortunately rather breaks that approach as Dave pointed
out
