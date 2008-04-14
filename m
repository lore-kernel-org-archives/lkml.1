Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYDNAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYDNAuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYDNAuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:50:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbYDNAuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:50:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 02:50:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
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
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org> <200804140207.19340.rjw@sisk.pl> <1208133790.6958.89.camel@pasglop>
In-Reply-To: <1208133790.6958.89.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140250.16893.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> > Please have a look at this thread:
> > http://lkml.org/lkml/2008/3/21/322
> > (in short, the reporter sees APM suspend breakage under stress, occuring
> > because APM uses our suspending of devices without the freezer).
> 
> Note that the above seems to lack any useful information (as usual) such
> as what block driver is involved etc...
> 
> We fixed IDE to be robust vs. pending IOs a while ago. It's possible
> that libata isn't as solid yet, I don't know.
> 
> This needs to be done regardless of feezer vs. not freezer. There are
> thins in the kernel that can trigger BIOs at any time pretty much
> regardless of user space being frozen or not, again, it's a case of
> sticking our head in the sand and hoping the freezer hides all our
> design bugs.

Now, you are talking about a completely different thing I agree with.

I gave this example just to show that some drivers break without the freezer
if suspend is carried out under stress, nothing else.

My point is (and has always been) that we can't just drop the freezer right now
without causing functional regressions to appear, at least for some users.

If there had not been _any_ other way to do things, we could do that, but IMO
there is a way (that I described in the previous message).

Thanks,
Rafael
