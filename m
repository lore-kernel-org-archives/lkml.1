Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbXGFEoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbXGFEoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 00:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXGFEoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 00:44:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:39144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbXGFEoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 00:44:04 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <200707061403.15932.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707060935.12706.nigel@nigel.suspend2.net>
	 <1183694055.3388.108.camel@localhost.localdomain>
	 <200707061403.15932.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 14:41:40 +1000
Message-Id: <1183696901.3388.119.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I/O from swsusp and suspend2 use bios directly, so the page cache isn't an 
> issue for them (apart from the fact that Suspend2 saves the page cache 
> separately so it can get a full image). Not sure about uswsusp.
> 
> Only having half the amount of memory doesn't sound like a big limitation for 
> modern desktops & laptops, but don't forget that there are embedded guys 
> wanting to hbernate too :)

Wait wait wait ... uses the BIOS ? what do you mean ?

I know that for example, things like MacOS X use a separate polled path to
the storage driver for suspend (works fine for the built-in IDE, but more
complicated in large scale). If you can use BIOS calls to write your
suspend image, that is, if you don't need any of the normal block
infrastructure, then you don't need a freezer ! not at all !

You just do like STR ... and at the end of the day, once you have stopped
all your driver, you shut interrupts off and do the BIOS thing....

I fail to see how processes could dirty pages while/after the BIOS thingy :-)

But then, the problem with that approach is that of course, you need a BIOS
capable of doing that (or a special sideband path to the "blessed" block
driver that will be used for suspend ... not necessarily a hard thing to do,
would be trivial to add support to drivers/ide or libata for that sort of
things I suppose).

Ben.


