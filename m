Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0BSRE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:04:56 -0500
Received: from kroah.org ([198.145.64.141]:57810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab0BSRBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:12 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:53 2010
Message-Id: <20100219163253.659080502@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <len.brown@intel.com>
Subject: [82/93] ACPI: Add NULL pointer check in acpi_bus_start
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit d2f6650a950dadd20667a04a9dc785f240d43695 upstream.

If acpi_bus_add does not return a device and it's passed
to acpi_bus_start, bad things will happen:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8128402d>] acpi_bus_start+0x14/0x24
...
[<ffffffffa008977a>] acpiphp_bus_add+0xba/0x130 [acpiphp]
[<ffffffffa008aa72>] enable_device+0x132/0x2ff [acpiphp]
[<ffffffffa0089b68>] acpiphp_enable_slot+0xb8/0x130 [acpiphp]
[<ffffffffa0089df7>] handle_hotplug_event_func+0x87/0x190 [acpiphp]

Next patch would make this NULL pointer check obsolete, but
better having one more than one missing...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/scan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1357,6 +1357,9 @@ int acpi_bus_start(struct acpi_device *d
 {
 	struct acpi_bus_ops ops;
 
+	if (!device)
+		return -EINVAL;
+
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_start = 1;
 


