Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXESQ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXESQ6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXESQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:58:26 -0400
Received: from waste.org ([66.93.16.53]:53859 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbXESQ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:58:25 -0400
Date: Sat, 19 May 2007 11:57:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070519165738.GK11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with 2.6.21-mm2, I'm seeing occassional failures to resume
from suspend-to-ram on my Thinkpad R51. The screen will flash as it
usually does, then go black and the machine will become totally
unresponsive, even to holding down the power button for 30+ seconds.
But the hard drive light will occassionally flash, so the machine is
clearly not completely dead at this point.

The log contains this:

08:57:25 hub 1-0:1.0: over-current change on port 4
08:57:26 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2
08:57:26 ACPI: EC: write_cmd timeout, command = 128
08:57:26 ACPI Exception (evregion-0424): AE_TIME, Returned by Handler for [EmbeddedControl] [20070126]
08:57:26 ACPI Exception (dswexec-0462): AE_TIME, While resolving operands for [OpcodeName unavailable] [20070126]
08:57:26 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.GBIF] (Node c203270c), AE_TIME
08:57:26 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.BAT0._BIF] (Node c2032644), AE_TIME
08:57:26 ACPI Exception (battery-0147): AE_TIME, Evaluating _BIF [20070126]
08:57:26 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2
08:57:26 ACPI: EC: input buffer is not empty, aborting transaction
08:57:26 ACPI Exception (evregion-0424): AE_TIME, Returned by Handler for [EmbeddedControl] [20070126]
08:57:26 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.AC__._PSR] (Node c20324c8), AE_TIME
08:57:26 ACPI Exception (ac-0095): AE_TIME, Error reading AC Adapter state [20070126]
08:57:27 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2
08:57:27 ACPI: EC: input buffer is not empty, aborting transaction
08:57:27 ACPI Exception (evregion-0424): AE_TIME, Returned by Handler for [EmbeddedControl] [20070126]
08:57:27 ACPI Exception (dswexec-0462): AE_TIME, While resolving operands for [OpcodeName unavailable] [20070126]
08:57:27 ACPI Error (psparse-0537): Method parse/execution failed [\_TZ_.THM0._TMP] (Node c202db30), AE_TIME
08:57:27 agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
08:57:27 agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
08:57:27 agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
08:57:27 [drm] Loading R200 Microcode
08:57:27 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2
08:57:27 ACPI: EC: input buffer is not empty, aborting transaction
08:57:28 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2

followed by a continual stream of these:

08:57:32 ACPI Exception (evregion-0424): AE_TIME, Returned by Handler for [EmbeddedControl] [20070126]
08:57:32 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.AC__._PSR] (Node c20324c8), AE_TIME
08:57:32 ACPI Exception (ac-0095): AE_TIME, Error reading AC Adapter state [20070126]
08:57:33 ACPI: EC: acpi_ec_wait timeout, status = 10, expect_event = 2
08:57:33 ACPI: EC: input buffer is not empty, aborting transaction

-- 
Mathematics is the supreme nostalgia of our time.
