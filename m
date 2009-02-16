Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZBPAp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZBPAp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZBPApQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:45:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:47716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZBPApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:45:15 -0500
Date: Sun, 15 Feb 2009 16:44:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090215164456.34aef7e8@infradead.org>
In-Reply-To: <200902160010.16955.rjw@sisk.pl>
References: <200902160010.16955.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 00:10:15 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> The recent descussion about the Android PM patches sent by Arve shows
> that there is a need to introduce a mechanism allowing us to:
> (1) automatically put the system as a whole into a sleep state (eg.
> suspend to RAM) when it is found to be "idle", where the meaning of
> "idle" has to be defined too,
> (2) put given subset of devices into low power states whenever they
> are not used, without putting the entire system into a sleep state.


For (2), for me the answer is very obvious:

The Device Driver needs to make the decision to put the device to sleep.
There are no ifs and buts about this.

It's the driver who 
a) knows if there's any activity, such as open users
and 
b) is in the right position to know how to put things to sleep.

Of course, the subsystem the driver belongs to can provide helpers
(such as generic activity timeout handlers etc).

For many cases, the drivers do this today already.
There are cases where doing this has side effects, mostly in terms of
latency. It is reasonable to have a general mechanism that provides a
central mechanism to track tolerable latencies; in fact PMQOS provides
this on a high level, and I can imagine that PMQOS needs to be extended
to provide a wider range of type of latencies.

Userland should never ever control the state of a device like this
directly. It should do so by a) closing the device and b) setting
latency / functional requirements.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
