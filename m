Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbYICXdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbYICXdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYICXdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:33:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYICXdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:33:32 -0400
Date: Wed, 3 Sep 2008 19:33:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] x86: add io delay quirk for Presario F700
Message-ID: <20080903193314.0c3cae84@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: add io delay quirk for Presario F700

Manually adding "io_delay=0xed" fixes system lockups in ioapic
mode on this machine.

System Information
	Manufacturer: Hewlett-Packard
	Product Name: Presario F700 (KA695EA#ABF)       

Base Board Information
	Manufacturer: Quanta
	Product Name: 30D3

Reference:
https://bugzilla.redhat.com/show_bug.cgi?id=459546

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.26.noarch.orig/arch/x86/kernel/io_delay.c
+++ linux-2.6.26.noarch/arch/x86/kernel/io_delay.c
@@ -92,6 +92,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_NAME, "30BF")
 		}
 	},
+	{
+		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "Presario F700",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30D3")
+		}
+	},
 	{ }
 };
 
