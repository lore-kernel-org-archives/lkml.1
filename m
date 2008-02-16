Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYBPPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYBPPxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYBPPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:53:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36853 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYBPPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:52:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Feb 2008 16:51:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
To: Jarod Wilson <jwilson@redhat.com>, Kristian Hoegsberg <krh@bitplanet.net>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.40f086463eb9e187@s5r6.in-berlin.de>
Message-ID: <tkrat.abda19e1774a3da3@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
 <tkrat.8110272bacc3f714@s5r6.in-berlin.de> <47B08F6B.2020502@redhat.com>
 <47B0AE54.8090602@s5r6.in-berlin.de>
 <tkrat.40f086463eb9e187@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> The only remedy seems to be to block the SCSI device until reconnect.

In the longer term, we should look into keeping commands enqueued in
fw-sbp2 during the reconnect phase.

Plus we need full parallelism of sbp2_reconnect and sbp2_login between
all attached targets.  The current single-threaded scheme does not work
too well for more than one target attached to the same bus.  The old
stack handles that case in a single thread too but is better tuned to
sbp2's needs.  The old stack blocks the Scsi_Hosts earlier, guaranteedly
performs all reconnects and re-logins before any new login, and has a
small delay between self-ID-complete and reconnect.  I looked into
changing fw-sbp2's own workqueue delays and into adding a counter to
fw-sbp2 to track outstanding reconnects in order to defer new logins,
but it is too messy.
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/

