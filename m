Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbXGTMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbXGTMN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXGTMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:13:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37909 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbXGTMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:13:40 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 20 Jul 2007 08:11:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Gabriel C <nix.or.die@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] IP_VS should depend on EXPERIMENTAL ?
In-Reply-To: <46A0A01A.7030403@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707200805070.11571@localhost.localdomain>
References: <46A0A01A.7030403@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as a short followup to my previous post, at the *very least*, a
cleanup that could be done now is to find all entries which have an
actual dependency on "EXPERIMENTAL" but don't advertise themselves as
such:

...
config MA600_DONGLE
        tristate "Mobile Action MA600 dongle"
        depends on IRTTY_SIR && DONGLE && IRDA && EXPERIMENTAL
	...

and determine which of those should have the dependency on
"EXPERIMENTAL" removed.  no, don't go adding "(EXPERIMENTAL)" to the
prompt -- just deal with *only* those for which the dependency is
clearly out of date and not relevant anymore, and delete it.

that would be, at least, a place to start.  and, yes, there's piles of
potential (net/ipv4/Kconfig):

config TCP_CONG_HSTCP
        tristate "High Speed TCP"
        depends on EXPERIMENTAL
	...
config TCP_CONG_HYBLA
        tristate "TCP-Hybla congestion control algorithm"
        depends on EXPERIMENTAL
	...
config TCP_CONG_VEGAS
        tristate "TCP Vegas"
        depends on EXPERIMENTAL
	...
... etc etc ...


rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
