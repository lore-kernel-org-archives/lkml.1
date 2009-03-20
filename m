Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbZCTAZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbZCTAZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbZCTAYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:24:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761882AbZCTAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:24:44 -0400
Date: Thu, 19 Mar 2009 21:16:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH] acpi: Eliminate a bit o'redudancy
Message-ID: <20090320001638.GF30407@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't checked if this pessimizes code, its just that when testing my
CTF encoder it decided that if the base type has the same bits as the
bitfield member and CTF has no expressiveness as in the bloated DWARF
format to express this case, so, to avoid my testcases from pointing me
this oxymoron, can you please apply this patch?

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index e9f6574..498b0a0 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -236,7 +236,7 @@ struct acpi_device_power {
 /* Performance Management */
 
 struct acpi_device_perf_flags {
-	u8 reserved:8;
+	u8 reserved;
 };
 
 struct acpi_device_perf_state {
