Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbXJQFxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbXJQFxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXJQFwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:52:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33823 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXJQFwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:52:53 -0400
Date: Wed, 17 Oct 2007 01:52:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: [PATCH 0/6] forcedeth interrupt and task overhaul, v2
Message-ID: <20071017055251.GA19972@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These six changes can be found in the 'fe' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

      [netdrvr] forcedeth: internal simplifications; changelog removal
      [netdrvr] forcedeth: timer overhaul
      [netdrvr] forcedeth: eliminate some duplicate irq handling code
      [netdrvr] forcedeth: unconditionally enable NAPI
      [netdrvr] forcedeth: use NAPI for TX completion
      [netdrvr] interrupt handling overhaul


I rewrote the previous forcedeth patchset, even though the direction and
methods are quite similar to the last patchset.

This hammers out bugs, problems, inconsistencies, mainly with interrupt
handling and locking.  This moves the driver towards removing the
disable_irq() usage, but does not actually take that step (yet).

A few changes just went upstream, too:

Ingo Molnar (1):
      forcedeth: fix NAPI rx poll function
Jeff Garzik (2):
      [netdrvr] forcedeth: improved probe info; dev_printk() cleanups
      [netdrvr] forcedeth: remove in-driver copy of net_device_stats

This patchset is diff'd against the latest linux-2.6.git as of an hour
ago or so.  It applies on top of the three changes listed immediately
above this paragraph.

At this point, it has been tested on

	nVidia Corporation CK804 Ethernet Controller (rev a3)

but I'm definitely interested in other testing, particularly performance
numbers (wire speed? or below?), CPU usage and memory usage info.  Most
particularly CPU usage info.  And maybe interrupt count with/without
this patchset, too.

If you send feedback, 'dmesg' and 'lspci' output is helpful.  The
current forcedeth driver in upstream (0.61) prints out useful diagnostic
information about your chip at bootup.


