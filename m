Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbZJGRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbZJGRXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZJGRXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:23:51 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43385 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZJGRXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:23:50 -0400
Date: Wed, 7 Oct 2009 10:22:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Gregory Haskins <ghaskins@novell.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] vbus: proxy uses, select IOQ
Message-Id: <20091007102259.ae014b15.randy.dunlap@oracle.com>
In-Reply-To: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ACCCE79.00CD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

vbus-proxy also uses ioq, so it should select IOQ.

When CONFIG_VBUS_PROXY=[ym] and VBUS_PCIBRIDGE=n:

ERROR: "ioq_init" [drivers/vbus/vbus-proxy.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gregory Haskins <ghaskins@novell.com>
---
 drivers/vbus/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091007.orig/drivers/vbus/Kconfig
+++ linux-next-20091007/drivers/vbus/Kconfig
@@ -5,6 +5,7 @@
 config VBUS_PROXY
        tristate "Virtual-Bus support"
        select SHM_SIGNAL
+       select IOQ
        default n
        help
        Adds support for a virtual-bus model drivers in a guest to connect
