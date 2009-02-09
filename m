Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZBISU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZBISU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZBISUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:20:45 -0500
Received: from mailserv58-us.natinst.com ([130.164.14.247]:3101 "EHLO
	mailserv58-us.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZBISUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:20:45 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Feb 2009 13:20:45 EST
Date: Mon, 9 Feb 2009 12:01:44 -0600
From: Shawn Bohrer <shawn.bohrer@ni.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
       ds@schleef.org
Subject: [staging] High level Comedi feedback
Message-ID: <20090209180144.GD18058@bohrers.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.18 (2008-05-17)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 02/09/2009 12:05:44 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 02/09/2009 12:20:47 PM,
	Serialize complete at 02/09/2009 12:20:47 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey All,

After reviewing the design of COMEDI there are a few concerns we've
found that could inhibit COMEDI as a general data acquisition framework.
I can elaborate on any of these concerns if needed, and I'd appreciate
any feedback from those who are more familiar with the COMEDI drivers.

1. COMEDI lacks a state model (configure, reserve, commit, start, stop)
that allows for speedy programming, reserving, and starting and stopping
when multiple clients are vying for usage of the shared hardware and
setup/tear-down costs have to be minimized.  The comedi_cmd interface
forces the setup costs to be incurred for every acquisition this is a
performance liability.  The other downside of this interface is that it
does not allow for on-the-fly settings changes such as changing an
acquisition rate or ranges of a channel within a running
acquisition/generation.

2. In general I'm concerned that the comedi_cmd_struct can't be expanded
to support all of the possible timing configurations of existing
hardware.

3. COMEDI expresses timing in terms of nano-seconds, limiting the scan
rate to 1GHz, scopes can go higher than this. The ~4,200V and 4.2A
limits brought by the range scaling coefficients are often suitable, but
could be a problem later with signal conditioned boards. Would value +
unit or value + multiplier be better?

4. COMEDI lacks the fine grained resource reservation (digital lines,
specific routes).

5. COMEDI does not yet support memory mapped digital lines or memory
mapped single point reads/writes directly with the hardware.

6. COMEDI doesn't yet support configuring hardware buffer sizes for deep
on-board FIFOs.

7. The comedi_bond.c driver doesn't attempt any synchronization and
doesn't support buffered operations. These features could be added, in
the kernel, but wouldn't this be better done in user-mode?

--
Shawn
