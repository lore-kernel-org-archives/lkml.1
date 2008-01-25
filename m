Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYAYAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYAYAtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYAYAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:49:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbYAYAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:49:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/5] b43: Fix suspend/resume deadlock
Date: Fri, 25 Jan 2008 01:27:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250127.21966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches is intended to fix the suspend/resume deadlock
occuring as a result of unregistering device objects, locked by the PM core,
during suspend/resume cycles by the b43 driver.

In short, the b43 driver is modified to avoid unregistering device objects
during suspend/resume cycles except for the resume code path, in which the
devices are unregistered using the recently introduced suspend-safe method.
For this purpose, it is necessary to introduce the possibility to safely remove
misc devices, leds classdevs and hwrng devices during suspend/resume cycles
(patches 2/5, 4/5, 3/5, respectively).

Please consider for applying.

Thanks,
Rafael

