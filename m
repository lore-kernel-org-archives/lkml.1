Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXH1LTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXH1LTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXH1LTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:19:01 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3594 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396AbXH1LTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:19:01 -0400
Date: Tue, 28 Aug 2007 13:19:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] v1 of IBM power meter driver
Message-ID: <20070828131942.18449886@hyperion.delvare>
In-Reply-To: <20070828015029.GA10107@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick, hi Henrique,

Good thing that manufacturers start including wattmeters in their
hardware. Hopefully this will help users better control their power
consumption in the long run.

On Mon, 27 Aug 2007 22:50:29 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 27 Aug 2007, Darrick J. Wong wrote:
> > documentation doesn't mention any naming conventions for sensors that
> > measure Watts, so I am proposing that they be called "powerX_input" in a
> > fashion similar to temperature/rpm/current sensors.  If that is
> > agreeable to everyone, I'll post a follow-up patch to amend the
> > documentation.
> 
> What unit should we use? Watts are way, way too big as there is no
> floating/fixed point in sysfs.  10^-6 W is probably what is called for,
> since we already need 10^-3 V and 10^-3 A.  Small portable devices can
> easily draw less than 10^-3 W nowadays.

Good point. The driver currently exports non-integer values, which is
not acceptable, so indeed it needs to be changed. We want at least a
resolution of 10^-3 W. Not sure about 10^-6 W. I am surprised that
portable devices can really draw less than 1 mW, and be it the case, I
doubt that manufacturers will embed a wattmetter: it would probably
draw more current than the rest of the device ;) so it may not be
relevant for our decision.

So I think I'd go with 10^-3 W, but I welcome diverging opinions. Out
of curiosity, what is the physical resolution of IBM's device?

I see that the driver relies on IPMI. Can't it be merged with the
out-of-tree impisensors driver then? This would give that driver some
momentum so that it can finally be merged, and I would like to avoid
having two drivers if one is enough. Note though that I don't know
anything about IPMI so I might as well be totally wrong ;)

-- 
Jean Delvare
