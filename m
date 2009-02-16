Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZBPGXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZBPGXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 01:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZBPGXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 01:23:07 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:10108 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBPGXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 01:23:05 -0500
X-IronPort-AV: E=Sophos;i="4.38,214,1233532800"; 
   d="scan'208";a="142746240"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff\, Richard" <r-woodruff2@ti.com>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 15 Feb 2009 22:23:04 -0800
In-Reply-To: <20090215164456.34aef7e8@infradead.org> (Arjan van de Ven's
	message of "Sun, 15 Feb 2009 16:44:56 -0800")
Message-ID: <adad4di7vef.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Feb 2009 06:23:04.0469 (UTC) FILETIME=[06776450:01C98FFF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > (2) put given subset of devices into low power states whenever they
 > > are not used, without putting the entire system into a sleep state.

 > For (2), for me the answer is very obvious:

 > The Device Driver needs to make the decision to put the device to sleep.
 > There are no ifs and buts about this.

For PC-like systems this is probably all that needs to be said.  However
for highly integrated SoC systems (as Android is obviously targeting)
there is another level of complexity due to the interdependency among
various devices... eg things like if I know the SD controller and the
wifi chip are both asleep then I can put my SDIO controller to sleep;
and if the SDIO controller and the NAND controller are both asleep then
I can stop clock X and save more power; etc etc.

This is what the PowerOp/DPM work was all about.  Unfortunately that
doesn't seem to have made much progress upstream.  But there's no doubt
in my mind that we need some framework beyond individual drivers that
manages the system's power as a whole.  And the current device tree is
probably not sufficient -- eg the bus hierarchy of a device may not
match up with the clock tree at all.

 - R.
