Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYITW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYITW7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYITW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:59:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:18949 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYITW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:59:24 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Martin Doucha <next_ghost@quick.cz>
Subject: [Bug 11603] Re: ACPI PnP on Intel MU440EX
Date: Sat, 20 Sep 2008 16:59:18 -0600
User-Agent: KMail/1.9.9
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       matthieu castet <castet.matthieu@free.fr>,
       bugme-daemon@bugzilla.kernel.org
References: <48BA9B2C.7060007@quick.cz> <48CD65D0.9090202@quick.cz> <200809162339.40330.bjorn.helgaas@hp.com>
In-Reply-To: <200809162339.40330.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201659.19268.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11603

Thanks for opening this bug report, Martin.

The DSDT definitely includes the parallel device.  The device can be
in several modes, so there are actually three sections for it: LPT,
EPP, and ECP.  None of them showed up in the PNP debug output, so the
_STA methods must be telling us the device isn't present at all.

If you turn on CONFIG_ACPI_DEBUG and boot with these options:
  acpi.debug_layer=0x10000 acpi.debug_level=0x10

we should see the results of evaluating _STA.

Does the BIOS setup screen have any config items related to the
parallel port?  If so, can you experiment with them and find out
whether they make any difference?
