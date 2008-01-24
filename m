Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYAXAxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYAXAxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYAXAxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:53:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45314 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbYAXAxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:53:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Jan 2008 01:52:25 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: order of memory accesses (bus generation vs.
 node ID)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Jarod Wilson <jwilson@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <4729A1BF.8010800@s5r6.in-berlin.de>
Message-ID: <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now updated some patches from November according to comments I
received from Nick back then.  As Jarod found out now while testing the
November versions, parts of these patches actually fix multiply reported
bugs.

While updating this stuff, I also found two more read sites where the
read order was not properly enforced.

Incoming:
1/4 firewire: fw-sbp2: use device generation, not card generation
2/4 firewire: fw-cdev: use device generation, not card generation
3/4 firewire: enforce access order between generation and node ID
4/4 firewire: fw-core: react on bus resets while the config ROM is being fetched

 drivers/firewire/fw-cdev.c     |    3 ++-
 drivers/firewire/fw-device.c   |   33 ++++++++++++++++++++++++---------
 drivers/firewire/fw-device.h   |   12 ++++++++++++
 drivers/firewire/fw-sbp2.c     |   14 ++++++++------
 drivers/firewire/fw-topology.c |    5 +++++
 5 files changed, 51 insertions(+), 16 deletions(-)
-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/

