Return-Path: <linux-kernel-owner+w=401wt.eu-S1750710AbXBKVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750710AbXBKVEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXBKVEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:04:24 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:57375 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXBKVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:04:24 -0500
Message-ID: <45CF84D4.3040305@s5r6.in-berlin.de>
Date: Sun, 11 Feb 2007 22:04:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111450.49736.rjw@sisk.pl> <20070211135708.GC1868@1wt.eu> <200702111536.20871.rjw@sisk.pl>
In-Reply-To: <200702111536.20871.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> - Problem what to do with drivers that work for some people and don't work
> for the others (ie. if we don't flag them as known good, we will break the
> setups in which they work)

And this issue is independent of whether a driver has .suspend and
.resume or not. For example, ohci1394 had them for ages but they didn't
work as expected before 2.6.20.

What's more, ohci1394's resume routine alone is insufficient; an
additional facility in ieee1394 was necessary and added for 2.6.21(-rc).
This shows that the original authors of ohci1394's .suspend and .resume
didn't test with actual external devices or gave up when they figured
that the problem reaches into upper subsystem layers. (We still haven't
tested interaction with most of the IEEE 1394 high level.)
-- 
Stefan Richter
-=====-=-=== --=- -=-==
http://arcgraph.de/sr/
