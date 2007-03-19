Return-Path: <linux-kernel-owner+w=401wt.eu-S1030360AbXCSVlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360AbXCSVlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965088AbXCSVke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:40:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbXCSVkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:40:17 -0400
Date: Mon, 19 Mar 2007 14:38:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 10/31] EHCI: add delay to bus_resume before accessing ports
Message-ID: <20070319213829.GL9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ehci-add-delay-to-bus_resume-before-accessing-ports.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as870) adds a delay to ehci-hcd's bus_resume routine.
Apparently there are controllers and/or BIOSes out there which need
such a delay to get the ports back into their correct state.  This
fixes Bugzilla #8190.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -134,6 +134,10 @@ static int ehci_bus_resume (struct usb_h
 	/* restore CMD_RUN, framelist size, and irq threshold */
 	writel (ehci->command, &ehci->regs->command);
 
+	/* Some controller/firmware combinations need a delay during which
+	 * they set up the port statuses.  See Bugzilla #8190. */
+	mdelay(8);
+
 	/* manually resume the ports we suspended during bus_suspend() */
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {

-- 
