Return-Path: <linux-kernel-owner+w=401wt.eu-S1030500AbXAaSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500AbXAaSVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXAaSVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:21:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030500AbXAaSVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:21:11 -0500
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 13:21:10 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] question on resume()
Date: Wed, 31 Jan 2007 12:04:40 -0600
Message-ID: <3B6D69C3A9EBCA4BA5DA60D9130274293DCC43@dlee13.ent.ti.com>
In-Reply-To: <Pine.LNX.4.44L0.0701311048560.3803-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] question on resume()
Thread-Index: AcdFUSXZ1MtTgrezT7KWC4yBF2wa/QAD7OpQ
References: <20070131093653.GA19643@elf.ucw.cz> <Pine.LNX.4.44L0.0701311048560.3803-100000@iolanthe.rowland.org>
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Alan Stern" <stern@rowland.harvard.edu>, "Pavel Machek" <pavel@ucw.cz>
Cc: "Oliver Neukum" <oneukum@suse.de>, "Oliver Neukum" <oliver@neukum.name>,
       "pm list" <linux-pm@lists.osdl.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Jan 2007 18:04:45.0203 (UTC) FILETIME=[49E25630:01C74562]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Again you misunderstood the question.  The driver must start queued
I/O
> when its resume() method is called.  It should then be okay for the
driver
> to call wake_up_interruptible(), even before tasks are unfrozen.

I kind of like the way MontaVista worked around this in some 2.4 drivers
where no freezer is present.  A tiny amount of state is kept at the
driver and suspend lock outs are added at service entry points and at
thread wake up points inside of the driver.

This way if some process makes a request in or wakes up when the driver
is not ready for the action, that context will get re-slept.

With 2.6 on some of our variants for TI boards we still kept our suspend
lock outs even though the freezer was there.  It allows some interesting
run time idling.  You potentially can turn ON and OFF a driver
individually for something like a high latency operational mode.  I
suppose based on your comments it also works around issues in the
freezer.  It doesn't take all that many lock outs to shore up a driver.

Regards,
Richard W.
