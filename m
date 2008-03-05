Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbYCEWap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbYCEWap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYCEWaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:30:35 -0500
Received: from the.earth.li ([217.147.81.2]:40279 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbYCEWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:30:34 -0500
Date: Wed, 5 Mar 2008 22:30:32 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080305223032.GA1385@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article
<alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
(earth.lists.linux-kernel) you wrote:

> It's a few days late, but I was waiting for some updates for some of the 
> most annoying regressions until releasing it, so the end result is 
> hopefully more useful as a result.

Still crashes in acpi_get_data for me; the patch mentioned
<1204241934.10256.151.camel@acpi-hp-zz.sh.intel.com> and tracked at

http://bugzilla.kernel.org/show_bug.cgi?id=10132

still doesn't seem to have hit mainline and still fixes the issue for me.

-----
From: Lin Ming <ming.m.lin@intel.com>

Fix a memory overflow bug when copying
NULL internal package element object to external.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/utilities/utobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/utilities/utobject.c
===================================================================
--- linux-2.6.orig/drivers/acpi/utilities/utobject.c
+++ linux-2.6/drivers/acpi/utilities/utobject.c
@@ -432,7 +432,7 @@ acpi_ut_get_simple_object_size(union acp
         * element -- which is legal)
         */
        if (!internal_object) {
-               *obj_length = 0;
+               *obj_length = sizeof(union acpi_object);
                return_ACPI_STATUS(AE_OK);
        }

-----

J.

-- 
/-\                             | 101 things you can't have too much
|@/  Debian GNU/Linux Developer |     of : 8 - Hard drive space.
\-                              |
