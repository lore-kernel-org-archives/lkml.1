Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZHMTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZHMTw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZHMTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:52:28 -0400
Received: from kroah.org ([198.145.64.141]:36716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZHMTrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:36 2009
Message-Id: <20090813194336.600606763@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [patch 08/28] thinkpad-acpi: disable broken bay and dock subdrivers
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-disable-broken-bay-and-dock-subdrivers.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 550e7fd8afb7664ae7cedb398c407694e2bf7d3c upstream.

Currently, the ThinkPad-ACPI bay and dock drivers are completely
broken, and cause a NULL pointer derreference in kernel mode (and,
therefore, an OOPS) when they try to issue events (i.e. on dock,
undock, bay ejection, etc).

OTOH, the standard ACPI dock driver can handle the hotplug bays and
docks of the ThinkPads just fine (including batteries) as of 2.6.27.
In fact, it does a much better job of it than thinkpad-acpi ever did.

It is just not worth the hassle to find a way to fix this crap without
breaking the (deprecated) thinkpad-acpi dock/bay ABI.  This is old,
deprecated code that sees little testing or use.

As a quick fix suitable for -stable backports, mark the thinkpad-acpi
bay and dock subdrivers as BROKEN in Kconfig.  The dead code will be
removed by a later patch.

This fixes bugzilla #13669, and should be applied to 2.6.27 and later.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Reported-by: Joerg Platte <jplatte@naasa.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -321,6 +321,7 @@ config THINKPAD_ACPI_DOCK
 	bool "Legacy Docking Station Support"
 	depends on THINKPAD_ACPI
 	depends on ACPI_DOCK=n
+	depends on BROKEN
 	default n
 	---help---
 	  Allows the thinkpad_acpi driver to handle docking station events.
@@ -334,7 +335,8 @@ config THINKPAD_ACPI_DOCK
 config THINKPAD_ACPI_BAY
 	bool "Legacy Removable Bay Support"
 	depends on THINKPAD_ACPI
-	default y
+	depends on BROKEN
+	default n
 	---help---
 	  Allows the thinkpad_acpi driver to handle removable bays.  It will
 	  electrically disable the device in the bay, and also generate


