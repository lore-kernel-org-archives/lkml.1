Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZBJTJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZBJTJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZBJTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:42 -0500
Received: from kroah.org ([198.145.64.141]:53768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755456AbZBJTDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:41 -0500
Date: Tue, 10 Feb 2009 11:00:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jarod Wilson <jarod@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 16/53] ieee1394: sbp2: add workarounds for 2nd and 3rd
	generation iPods
Message-ID: <20090210190011.GQ14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-sbp2-add-workarounds-for-2nd-and-3rd-generation-ipods.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit 1448d7c6a2ff96d3b52ecae49e2d0f046a097fe0 upstream.

As per https://bugs.launchpad.net/bugs/294391.  These got one sample of
each iPod generation going.  However there still occurred I/O stalls
with the 3rd generation iPod which remain undiagnosed at the time of
this writing.

Acked-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/sbp2.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -395,6 +395,16 @@ static const struct {
 		.model_id		= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/*
+	 * iPod 2nd generation: needs 128k max transfer size workaround
+	 * iPod 3rd generation: needs fix capacity workaround
+	 */
+	{
+		.firmware_revision	= 0x0a2700,
+		.model_id		= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model_id		= 0x000021,

