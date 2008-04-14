Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYDNAoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYDNAoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYDNAop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:44:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:33446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYDNAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:44:45 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <ncunningham@crca.org.au>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804140207.19340.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
	 <1208130513.6958.72.camel@pasglop>  <200804140207.19340.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 10:43:10 +1000
Message-Id: <1208133790.6958.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please have a look at this thread:
> http://lkml.org/lkml/2008/3/21/322
> (in short, the reporter sees APM suspend breakage under stress, occuring
> because APM uses our suspending of devices without the freezer).

Note that the above seems to lack any useful information (as usual) such
as what block driver is involved etc...

We fixed IDE to be robust vs. pending IOs a while ago. It's possible
that libata isn't as solid yet, I don't know.

This needs to be done regardless of feezer vs. not freezer. There are
thins in the kernel that can trigger BIOs at any time pretty much
regardless of user space being frozen or not, again, it's a case of
sticking our head in the sand and hoping the freezer hides all our
design bugs.

Ben.


