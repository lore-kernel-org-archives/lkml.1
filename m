Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZD0OVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZD0OVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZD0OVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:21:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53608 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZD0OVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:21:20 -0400
Date: Mon, 27 Apr 2009 15:21:06 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: James Kosin <jkosin@beta.intcomgrp.com>
Cc: Pavel Machek <pavel@ucw.cz>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090427142106.GE20591@sirena.org.uk>
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com> <49EDD2A7.9090300@compulab.co.il> <20090425081933.GE2428@ucw.cz> <20090425090448.GA4210@sirena.org.uk> <49F5B774.5010501@beta.intcomgrp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F5B774.5010501@beta.intcomgrp.com>
X-Cookie: Use other side for additional listings.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 09:47:32AM -0400, James Kosin wrote:
> Mark Brown wrote:

> > This all started because this approach was nacked for serial drivers.
> > In any case, I'm not sure that'll scale - it may not be desirable or
> > reasonable to do something like that for all devices.  For example, the
> > devices may be connected via a technology that's not suitable (I've
> > worked on systems which used ethernet here).

> Ethernet can be treated as a serial interface as well down to the
> simplest level.  I'm leaving out a lot is making this assumption; but,
> it is true to a fault.

The big difference with ethernet is that it's multi-drop - you can't
turn on the power based on the ethernet interface being in use since
there can be more than one device connected.

> The same applies to disk devices, now we have IDE/SATA/etc. the disk
> device itself doesn't depend on the interface physically, the kernel
> treats all these as suitable interfaces for disk/CDROM/tape devices and
> the world is not turned on its ear just because there is a different
> physical interface.

You're suggesting modifying the link layer to do different things based
on which device is connnected to it; in any case the issue here is that
this class of hardware has no in-kernel driver to provide an abstaction
- it's all done by a user space daemon or similar.
