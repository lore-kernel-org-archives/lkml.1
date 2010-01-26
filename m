Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777Ab0AZNMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0AZNMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745Ab0AZNME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:12:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59097 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0AZNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:11:59 -0500
Date: Tue, 26 Jan 2010 13:11:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126131146.GC32291@sirena.org.uk>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com> <201001260316.20529.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001260316.20529.david-b@pacbell.net>
X-Cookie: Do not attempt this in your home.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:16:20AM -0800, David Brownell wrote:

> I'd vote to convert all the USB-to-charger interfaces so
> they use notifiers.  After fixing the events ... see
> comments below.  :)

Yes please - it's not just chargers either, this can also be used by
PMICs which do power path management that includes USB.

> Those seem like the wrong events.  The right events for a charger
> would be more along the lines of:

>  - For peripheral:  "you may use N milliAmperes now".
>  - General:  "Don't Charge" (a.k.a. "use 0 mA").

> I don't see how "N" would be passed with those events ...

These are good for the peripheral side.  You do get to pass a void *
along with the notifier value, that could be used to pass data like the
current limit.

> A host *might* want to be able to say things like "supply
> up to N milliAmperes now", e.g. to let a regulator choose
> the most efficient mode.

Yes, they definitely want this - not just for efficiency but also to
allow current limiting to protect the system from excessive current
drain.
