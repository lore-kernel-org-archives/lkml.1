Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXFGMYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXFGMYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbXFGMYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:24:03 -0400
Received: from mailgw4.ericsson.se ([193.180.251.62]:41790 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbXFGMYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:24:00 -0400
X-AuditID: c1b4fb3e-ae9ecbb0000061ca-44-4667f8dff4ad 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 7 Jun 2007 14:23:58 +0200
Message-ID: <A6D19A13FE030A409EC4362C172E091F016F51BC@eseldmw101.eemea.ericsson.se>
In-Reply-To: <200706051723.56436.bjorn.helgaas@hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Thread-Index: AcenyJ+XAlqYHhyQQD+3xkILXFiOXABNQF9w
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <7VXmfiOJ.1181030230.9946640.samuel@sortiz.org> <A6D19A13FE030A409EC4362C172E091F016F51B1@eseldmw101.eemea.ericsson.se> <200706051723.56436.bjorn.helgaas@hp.com>
From: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Cc: "Samuel Ortiz" <samuel@sortiz.org>, <arvidjaar@mail.ru>,
       <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <ambx1@neo.rr.com>
X-OriginalArrivalTime: 07 Jun 2007 12:23:58.0854 (UTC) FILETIME=[B95F5260:01C7A8FE]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn wrote:

> Something's wrong with this strategy.  The BIOS is telling us 
> that an SMCf010 device is present, active, and responds at io 
> ports 0x100-0x107 and 0x2e8-0x2ef.  The fact that it happens 
> to be on the other side of an ISA or LPC bridge should be 
> immaterial to the OS driver.

Yes, ideally. Yes of course it is wrong, or from a platonic
perspective. If nobody wrote buggy BIOS:es there would be no
problem.

There is some history in the preconfigure functions:
these come from the smcinit tool (see http://irda.sourceforge.net/smcinit/),
the hacks target laptops where the (buggy) BIOS does not properly
preconfigure the bridge. The assumption in the current code
is that Toshiba laptops with this smscchip will have the problem,
because they always had in the past...

I have no idea how bridges on such laptops are really preconfigured,
possibly with some special hacks to the (manufacturer-supplied-assumed)
"driver CD" for Windows only that apply some low-level tweaks to the
WinNT/XP boot process. All info an reverse-engineering on this subject
is warmly welcomed.

There are some troubles further related to issues due to laptops
supporting both ACPI and APM too I think, never dug into it.

Linus
