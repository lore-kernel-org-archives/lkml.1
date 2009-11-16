Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZKPXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZKPXe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZKPXe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:34:58 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38492 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbZKPXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:34:56 -0500
Date: Mon, 16 Nov 2009 15:32:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
       akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [PATCH -next] acpi: get_bios_limit static inline when CPU_FREQ=n
Message-Id: <20091116153237.95f2e42d.randy.dunlap@oracle.com>
In-Reply-To: <20091116181453.b42247cf.sfr@canb.auug.org.au>
References: <20091116181453.b42247cf.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B01E17A.00D7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

For CONFIG_CPU_FREQ=n, make acpi_processor_get_bios_limit()
static inline so that multiple source files that use this
header file do not create multiple definitions of the function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/acpi/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091113.orig/include/acpi/processor.h
+++ linux-next-20091113/include/acpi/processor.h
@@ -318,7 +318,7 @@ static inline int acpi_processor_ppc_has
 	}
 	return 0;
 }
-int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 {
 	return -ENODEV;
 }
