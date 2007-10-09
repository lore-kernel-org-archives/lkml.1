Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXJIFNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXJIFNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXJIFNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:13:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:44180 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXJIFNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:13:45 -0400
Subject: Re: OHCI root_port_reset() deadly loop...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: davem@davemloft.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <20071009040917.DC7FC237446@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071006.235358.104048815.davem@davemloft.net>
	 <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <20071007.005156.85395415.davem@davemloft.net>
	 <20071008.165420.42793456.davem@davemloft.net>
	 <20071009040917.DC7FC237446@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 15:13:36 +1000
Message-Id: <1191906816.6355.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, that's why I asked about EHCI.  My speculation would be that
> OHCI starts the reset, and EHCI claims the port before it completes;
> or contrariwise OHCI starts the reset right after EHCI claims it.
> 
> And there's some point in that process where a hardware race makes
> the trouble you've observed.  I believe there are plenty of other
> places where it's perfectly fine if EHCI grabs the port, or this
> little race would have shown up many times before.

Since we can't know which O/UHCI is paired with which EHCI, we can't
really have generic code to deal with that race, but maybe we can be
smart and basically mutex khubd activity such as port reset vs.
registration of any new HCD ?

I'm not even sure module load order is 100% fault proof here since khubd
spawns as a thread...
 
Ben.


