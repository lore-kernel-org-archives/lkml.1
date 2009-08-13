Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZHMT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZHMT7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZHMT7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:34 -0400
Received: from kroah.org ([198.145.64.141]:41721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbZHMT7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:28 2009
Message-Id: <20090813195128.556439418@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [patch 27/74] thinkpad-acpi: disable broken bay and dock subdrivers
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-disable-broken-bay-and-dock-subdrivers.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/platform/x86/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -265,6 +265,7 @@ config THINKPAD_ACPI_DOCK
 	bool "Legacy Docking Station Support"
 	depends on THINKPAD_ACPI
 	depends on ACPI_DOCK=n
+	depends on BROKEN
 	default n
 	---help---
 	  Allows the thinkpad_acpi driver to handle docking station events.
@@ -278,7 +279,8 @@ config THINKPAD_ACPI_DOCK
 config THINKPAD_ACPI_BAY
 	bool "Legacy Removable Bay Support"
 	depends on THINKPAD_ACPI
-	default y
+	depends on BROKEN
+	default n
 	---help---
 	  Allows the thinkpad_acpi driver to handle removable bays.  It will
 	  electrically disable the device in the bay, and also generate


