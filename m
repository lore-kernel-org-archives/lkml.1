Return-Path: <linux-kernel-owner+w=401wt.eu-S1764977AbZAQVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764977AbZAQVqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZAQVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:45:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44613 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZAQVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:45:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jan 2009 22:45:54 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: cope with temporary connection loss
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following series, the 1st patch enables the firewire stack to
tolerate brief disappearance of nodes similarly as the ieee1394 stack
has been taught in Linux 2.6.28.

This finally allows me to push the patch
    Date: Wed, 19 Mar 2008 22:02:40 +0100 (CET)
    From: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Subject: firewire: insist on successive self ID complete events
into the mainline, which is a fix that potentially prevents kernel
panics.  This fix had the unfortunate side effect that the firewire-core
topology code destroyed and re-created node representations more often
than before.  Until now, this caused high-level drivers (firewire-sbp2
and userspace drivers) to be unbound and rebound, so that for example
mounted filesystems were lost.

Besides the condition which triggered the "insist on successive self ID
complete events" precautions, there are also other occasions at which
nodes vanish briefly and reappear.  See the changelog of patch 1/4.
firewire-core is now able to keep drivers bound until the nodes come
back, if they come back quickly.

The latter 3 patches are cleanups.

[PATCH 1/4] firewire: keep highlevel drivers attached during brief connection loss
[PATCH 2/4] firewire: core: clean up includes
[PATCH 3/4] firewire: core: move some functions
[PATCH 4/4] firewire: core: remove condition which is always false

 drivers/firewire/fw-device.c |  231 +++++++++++++++++++++++------------
 drivers/firewire/fw-device.h |   14 +-
 2 files changed, 166 insertions(+), 79 deletions(-)
-- 
Stefan Richter
-=====-==--= ---= =---=
http://arcgraph.de/sr/

