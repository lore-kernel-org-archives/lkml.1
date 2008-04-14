Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYDNDY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYDNDY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYDNDYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:24:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:49772 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbYDNDYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:24:02 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804140309.22057.rjw@sisk.pl>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804140231.32245.rjw@sisk.pl> <1208134017.6958.94.camel@pasglop>
	 <200804140309.22057.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 13:23:00 +1000
Message-Id: <1208143380.6958.105.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> To avoid breaking things (from the functional point of view) unnecessarily.
> 
> In short, I don't really see the difference between moving ->prepare() before
> the freezer and droppig the freezer, which I'm not going to do right now.

I believe the use of prepare for things like request_firmware etc... is
worth the effort of fixing the known breakage of not having the freezer
while preventing insertion of new devices (mostly USB). In fact, it
won't be such a big issue as the core should/will return an error from
attempting to add the device in that case.

Ben.


